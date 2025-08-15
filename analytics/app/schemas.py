from typing import Optional
from pydantic import BaseModel

class RawText(BaseModel):
    text: str

class ProcessedText(BaseModel):
    intention: str
    addresses: Optional[str] = None
    route_choice: Optional[list[int]] = None
    tariff: Optional[str] = None
    places: Optional[str] = None