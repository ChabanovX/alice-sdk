import asyncio
import websockets
import argparse

CHUNK_SIZE = 4000


async def send_file(uri, path, auth_header):
    headers = {}
    if auth_header:
        headers["Authorization"] = auth_header
    async with websockets.connect(uri, additional_headers=headers, max_size=None) as ws:
        print("Connected to WebSocket")
        with open(path, "rb") as f:
            while True:
                chunk = f.read(CHUNK_SIZE)
                if not chunk:
                    break
                await ws.send(chunk)
                # await asyncio.sleep(0.01)

        await ws.send("EOS")
        print("Send file!")

        try:
            resp = await asyncio.wait_for(ws.recv(), timeout=30.0)
            print("FINAL JSON FROM SERVER:", resp)
        except asyncio.TimeoutError:
            print("Timed out waiting for final result.")
        except Exception as e:
            print("Error waiting for result:", e)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--file", required=True,
                        help="Path to raw PCM file (s16le, 8kHz, mono)")
    parser.add_argument("--url", default="ws://localhost:8081/ws")
    parser.add_argument("--auth_header", help="Authorization header, e.g. 'Basic ...'")
    args = parser.parse_args()
    asyncio.run(send_file(args.url, args.file, args.auth_header))
