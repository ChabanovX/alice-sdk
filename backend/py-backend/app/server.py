import os
import asyncio
import grpc
import logging
from fastapi import FastAPI, WebSocket

# модули gRPC
import yandex.cloud.ai.stt.v3.stt_pb2 as stt_pb2
import yandex.cloud.ai.stt.v3.stt_service_pb2_grpc as stt_srv

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s [%(levelname)s] %(message)s",
)

app = FastAPI()


@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()
    api_key = os.getenv("API_KEY")
    if not api_key:
        logging.error("API_KEY not found")
        await websocket.close(code=1008)
        return

    cred = grpc.ssl_channel_credentials()
    channel = grpc.aio.secure_channel("stt.api.cloud.yandex.net:443", cred)
    stub = stt_srv.RecognizerStub(channel)

    async def request_generator():
        recognize_options = stt_pb2.StreamingOptions(
            recognition_model=stt_pb2.RecognitionModelOptions(
                audio_format=stt_pb2.AudioFormatOptions(
                    raw_audio=stt_pb2.RawAudio(
                        audio_encoding=stt_pb2.RawAudio.LINEAR16_PCM,
                        sample_rate_hertz=8000,
                        audio_channel_count=1
                    )
                ),
                text_normalization=stt_pb2.TextNormalizationOptions(
                    text_normalization=stt_pb2.TextNormalizationOptions.TEXT_NORMALIZATION_ENABLED,
                    profanity_filter=True,
                    literature_text=False
                ),
                language_restriction=stt_pb2.LanguageRestrictionOptions(
                    restriction_type=stt_pb2.LanguageRestrictionOptions.WHITELIST,
                    language_code=['ru-RU']
                ),
                audio_processing_type=stt_pb2.RecognitionModelOptions.REAL_TIME
            ),
            eou_classifier=stt_pb2.EouClassifierOptions(
                default_classifier=stt_pb2.DefaultEouClassifier(
                    type=stt_pb2.DefaultEouClassifier.EouSensitivity.DEFAULT,
                    max_pause_between_words_hint_ms=2000
                )
            )
        )

        yield stt_pb2.StreamingRequest(session_options=recognize_options)

        while True:
            try:
                msg = await websocket.receive()
            except Exception as e:
                logging.warning(f"Can't recieve message from WebSocket: {e}")
                break

            if 'bytes' in msg:
                data = msg['bytes']
                if data:
                    yield stt_pb2.StreamingRequest(chunk=stt_pb2.AudioChunk(data=data))
                continue

            if 'text' in msg:
                text = msg['text']
                if text == "EOS":
                    logging.info("got EOS, finishing")
                    yield stt_pb2.StreamingRequest(eou=stt_pb2.Eou())

    try:
        responses = stub.RecognizeStreaming(
            request_generator(),
            metadata=(('authorization', f'Api-Key {api_key}'),)
        )
        async for response in responses:
            event = response.WhichOneof('Event')
            if event == 'partial' and response.partial.alternatives:
                partial_text = response.partial.alternatives[0].text
                logging.debug(f"[PARTIAL] {partial_text}")
            if event == 'final':
                text = response.final.alternatives[0].text if response.final.alternatives else ""
                logging.info(f"[FINAL] {text}")
            if event == 'final_refinement':
                norm_text = response.final_refinement.normalized_text.alternatives[0].text
                logging.info(f"[REFINED] {norm_text}")
                await websocket.send_json({"raw_text": norm_text})
                break
    except grpc.RpcError as err:
        logging.error(f"gRPC error: {err}")

    try:
        await websocket.close()
    except Exception as e:
        logging.warning(f"Error closing WebSocket: {e}")
