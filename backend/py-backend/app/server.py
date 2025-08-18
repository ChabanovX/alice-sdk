import os
import time
import asyncio
import logging
from typing import Optional
import aiohttp
import grpc
from fastapi import FastAPI, WebSocket

# gRPC modules
import yandex.cloud.ai.stt.v3.stt_pb2 as stt_pb2
import yandex.cloud.ai.stt.v3.stt_service_pb2_grpc as stt_srv

logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s] %(message)s")

METADATA_TOKEN_URL = "http://169.254.169.254/computeMetadata/v1/instance/service-accounts/default/token"
METADATA_HEADER = {"Metadata-Flavor": "Google"}
REFRESH_INTERVAL = 3600  # 1 hour

app = FastAPI()


class IAMTokenManager:
    def __init__(self, session: aiohttp.ClientSession):
        self._session = session
        self.token: str | None = None
        self.expires_at: float = 0.0
        self._lock = asyncio.Lock()

    async def fetch_token_once(self) -> None:
        try:
            async with self._session.get(METADATA_TOKEN_URL, headers=METADATA_HEADER, timeout=5) as resp:
                if resp.status != 200:
                    text = await resp.text()
                    logging.warning(f"Metadata token request returned {resp.status}: {text}")
                    return
                data = await resp.json()
                access_token = data.get("access_token")
                expires_in = int(data.get("expires_in", 0))
                if access_token:
                    async with self._lock:
                        self.token = access_token
                        self.expires_at = time.time() + expires_in
                    logging.info(f"Fetched IAM token from metadata (expires in {expires_in}s).")
        except Exception as e:
            logging.warning(f"Failed to fetch IAM token from metadata: {e}")

    async def get_token(self) -> Optional[str]:
        async with self._lock:
            return self.token


async def _background_token_refresher(app: FastAPI):
    token_manager: IAMTokenManager = app.state.iam_token_manager
    await token_manager.fetch_token_once()

    try:
        while True:
            await asyncio.sleep(REFRESH_INTERVAL)
            await token_manager.fetch_token_once()
    except asyncio.CancelledError:
        logging.info("Token refresher cancelled, exiting background task.")
        raise


@app.on_event("startup")
async def startup():
    app.state.aiohttp_session = aiohttp.ClientSession()
    app.state.iam_token_manager = IAMTokenManager(app.state.aiohttp_session)
    app.state.token_refresher_task = asyncio.create_task(_background_token_refresher(app))
    logging.info("Started aiohttp session and token refresher task.")


@app.on_event("shutdown")
async def shutdown():
    task = app.state.token_refresher_task
    task.cancel()
    try:
        await task
    except asyncio.CancelledError:
        pass
    await app.state.aiohttp_session.close()
    logging.info("Shutdown: token refresher stopped and aiohttp session closed.")


@app.websocket("/ws")
async def websocket_endpoint(websocket: WebSocket):
    await websocket.accept()

    token_manager: IAMTokenManager = websocket.app.state.iam_token_manager
    api_key = os.getenv("API_KEY")

    iam_token = await token_manager.get_token()
    if not iam_token and not api_key:
        logging.error("No IAM token available and no API_KEY fallback set — refusing connection.")
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
                logging.warning(f"Can't receive message from WebSocket: {e}")
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
                    break

    iam_token = await token_manager.get_token()
    if iam_token:
        metadata = (('authorization', f'Bearer {iam_token}'),)
    else:
        metadata = (('authorization', f'Api-Key {api_key}'),)

    try:
        responses = stub.RecognizeStreaming(request_generator(), metadata=metadata)
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
    finally:
        try:
            await websocket.close()
        except Exception as e:
            logging.warning(f"Error closing WebSocket: {e}")
        await channel.close()
