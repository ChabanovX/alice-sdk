import logging
from fastapi import FastAPI, HTTPException
from app.schemas import RawText, ProcessedText
from app.cluster import processText # пусть пока функция называется так, на данный момент это заглушка

logger = logging.getLogger(__name__)

app = FastAPI(title="Text Clustering Service")

@app.post("/cluster", response_model=ProcessedText)
async def cluster_endpoint(payload: RawText):
    try:
        result = processText(payload.text)
        return ProcessedText(**result)
    except Exception as e:
        logger.exception("Bad processitng /cluster")

        detail = f"{type(e).__name__}: {e}"
        raise HTTPException(status_code=500, detail="Server Error")