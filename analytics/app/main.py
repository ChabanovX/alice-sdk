import logging
from fastapi import FastAPI, HTTPException
from app.schemas import RawText, ProcessedText, TextWithRequestType
from app.voice_assistant import VoiceAssistant

logger = logging.getLogger(__name__)

app = FastAPI(title="Text Clustering Service")

va = VoiceAssistant()


@app.post("/cluster", response_model=ProcessedText)
async def request_endpoint(payload: RawText):
    try:
        result = va.get_request_and_details(payload.text)
        location = result.get("location", {})
        return ProcessedText(
            intention=result["intention"],
            route_choice=result.get("route_choice"),
            tariff=result.get("tariff"),
            places=location.get("places"),
            addresses=location.get("addresses"),
        )
    except Exception as e:
        logger.exception("Bad processitng /cluster")

        detail = f"{type(e).__name__}: {e}"
        raise HTTPException(status_code=500, detail="Server Error")


@app.post("/details-by-type", response_model=ProcessedText)
async def details_endpoint(payload: TextWithRequestType):
    try:
        result = va.get_request_details_by_type(payload.text, payload.request_type)
        location = result.get("location", {})
        return ProcessedText(
            intention=result["intention"],
            route_choice=result.get("route_choice"),
            tariff=result.get("tariff"),
            places=location.get("places"),
            addresses=location.get("addresses"),
        )
    except Exception as e:
        logger.exception("Bad processitng /cluster")

        detail = f"{type(e).__name__}: {e}"
        raise HTTPException(status_code=500, detail="Server Error")
