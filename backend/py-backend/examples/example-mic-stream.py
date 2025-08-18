import asyncio
import sounddevice as sd
import numpy as np
import websockets
import queue
import threading
import argparse

SAMPLE_RATE = 8000
CHANNELS = 1
CHUNK_MS = 200
CHUNK_FRAMES = int(SAMPLE_RATE * CHUNK_MS / 1000)

thread_q = queue.Queue()
stop_event = threading.Event()


async def websocket_sender_from_threadq(api_ws, auth_header):
    headers = {}
    if auth_header:
        headers["Authorization"] = auth_header
    print("Connecting to", api_ws)
    try:
        async with websockets.connect(api_ws, additional_headers=headers, max_size=None) as ws:
            print("websocket connected")
            while True:
                item = await asyncio.get_event_loop().run_in_executor(None, thread_q.get)
                if item is None:
                    print("Sending EOS")
                    try:
                        await ws.send("EOS")
                        final = await asyncio.wait_for(ws.recv(), timeout=30.0)
                        print("Json from server:", final)
                    except asyncio.TimeoutError:
                        print("Timed out waiting for final result.")
                    except websockets.ConnectionClosed:
                        try:
                            final = await ws.recv()
                            print("Json from server after close:", final)
                        except Exception:
                            print("No final message received after close.")
                    thread_q.task_done()
                    break
                try:
                    await ws.send(item.tobytes())
                except websockets.ConnectionClosed:
                    print(
                        "WebSocket closed by server, trying to receive final message...")
                    try:
                        final = await ws.recv()
                        print("Json from server after close:", final)
                    except Exception:
                        print("No final message received after close.")
                    stop_event.set()
                    break
                except Exception as e:
                    print("Error sending chunk:", e)
                    stop_event.set()
                    break
                finally:
                    thread_q.task_done()
    except Exception as e:
        print("WebSocket sender error:", e)
        stop_event.set()
    finally:
        print("Sender task finished.")


def audio_callback(indata, frames, time_info, status):
    if stop_event.is_set():
        return
    if status:
        print("audio callback status:", status)
    if indata.dtype == np.float32:
        samples = np.clip(indata[:, 0], -1.0, 1.0)
        int16 = (samples * 32767.0).astype(np.int16)
    else:
        int16 = indata[:, 0].astype(np.int16)
    try:
        thread_q.put_nowait(int16.copy())
    except queue.Full:
        print("thread_q is full — dropping audio chunk")


async def main(api_ws, auth_header):
    sender_task = asyncio.create_task(websocket_sender_from_threadq(api_ws, auth_header))

    stream = sd.InputStream(
        samplerate=SAMPLE_RATE,
        channels=CHANNELS,
        dtype='float32',
        blocksize=CHUNK_FRAMES,
        callback=audio_callback
    )

    print("Start recording. Press Enter to stop.")
    with stream:
        await asyncio.get_event_loop().run_in_executor(None, input)

    stop_event.set()
    thread_q.put(None)

    await sender_task
    print("Done.")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--url", default="ws://localhost:8081/ws", help="WebSocket server URL")
    parser.add_argument("--auth_header", help="Authorization header, e.g. 'Basic ...'")
    args = parser.parse_args()
    asyncio.run(main(args.url, args.auth_header))
