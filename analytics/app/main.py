import logging
from fastapi import FastAPI, HTTPException
from app.schemas import RawText, ProcessedText
from app.voice_assistant import VoiceAssistant 

logger = logging.getLogger(__name__)

app = FastAPI(title="Text Clustering Service")

va = VoiceAssistant()

@app.post("/cluster", response_model=ProcessedText)
async def cluster_endpoint(payload: RawText):
    try:
        result = va.get_request_details(payload.text)
        return ProcessedText(**result)
    except Exception as e:
        logger.exception("Bad processitng /cluster")

        detail = f"{type(e).__name__}: {e}"
        raise HTTPException(status_code=500, detail="Server Error")