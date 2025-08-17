import asyncio
import websockets
import sys
import logging

async def text_to_speech_ws(uri, text_file, output_file="output.ogg"):
    async with websockets.connect(uri, max_size=None) as ws:
        print(f"Connected to {uri}")

        # Читаем текст из файла и отправляем как текстовое сообщение
        with open(text_file, "r", encoding="utf-8") as f:
            text = f.read()
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
    if len(sys.argv) < 3:
        print("Usage: python tts_ws.py <websocket_uri> <text_file>")
        sys.exit(1)

    uri = sys.argv[1]
    text_file_path = sys.argv[2]

    asyncio.run(text_to_speech_ws(uri, text_file_path))
