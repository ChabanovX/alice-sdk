import asyncio
import pytest
import websockets
import json

WS_URL = "ws://localhost:8081/ws"
TEST_PCM = "../audio_examples/client-wish-scenario.wav"
CHUNK_SIZE = 4000


@pytest.mark.asyncio
async def test_websocket_connect_and_close():
    async with websockets.connect(WS_URL) as ws:
        assert ws.state == websockets.protocol.State.OPEN

        await ws.close()
        assert ws.state == websockets.protocol.State.CLOSED


@pytest.mark.asyncio
async def test_send_eos_and_receive_final():
    async with websockets.connect(WS_URL) as ws:
        await ws.send("EOS")

        try:
            response = await asyncio.wait_for(ws.recv(), timeout=5.0)
            json_body = json.loads(response)
        except asyncio.TimeoutError:
            json_body = None

        assert json_body is None or isinstance(json_body, str)


@pytest.mark.asyncio
async def test_send_pcm_file():
    async with websockets.connect(WS_URL) as ws:
        with open(TEST_PCM, "rb") as f:
            while True:
                chunk = f.read(CHUNK_SIZE)
                if not chunk:
                    break
                await ws.send(chunk)

        await ws.send("EOS")

        try:
            response = await asyncio.wait_for(ws.recv(), timeout=10.0)
            json_body = json.loads(response)
            raw_text = json_body.get("raw_text", "")
        except asyncio.TimeoutError:
            raw_text = None

        assert raw_text == "Расскажи пожелания пассажира пожалуйста"
