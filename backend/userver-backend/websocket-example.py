import asyncio
import websockets
import logging

WS_URI = "ws://localhost:8080/text-to-speech"

async def text_to_speech_ws(output_file="output.ogg"):
    async with websockets.connect(WS_URI, max_size=None) as ws:
        print(f"Connected to {WS_URI}")

        text = "привет привет это текст синтезированный из спич кит и это круто поки поки"
        await ws.send(text)
        print(f"Sent text: {text[:50]}...")

        audio_data = b""
        try:
            while True:
                msg = await ws.recv()
                if isinstance(msg, bytes):
                    logging.warning("CHECK")
                    audio_data += msg
                else:
                    # Если сервер посылает текст — мог быть сигнал окончания
                    if msg == "EOS":
                        print("Received EOS signal")
                        break
                    else:
                        print(f"Received text message: {msg}")
        except websockets.exceptions.ConnectionClosedOK:
            print("WebSocket closed normally")
        except Exception as e:
            print(f"Error: {e}")
            return

        # Сохраняем аудио в файл
        with open(output_file, "wb") as f:
            f.write(audio_data)
        print(f"Audio saved to {output_file}")

if __name__ == "__main__":
    asyncio.run(text_to_speech_ws())
