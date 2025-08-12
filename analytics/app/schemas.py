from typing import Optional
from pydantic import BaseModel

class RawText(BaseModel):
    text: str

class ProcessedText(BaseModel):
    scenario: str
    address: str
    route_number: Optional[int] = None
    fare: str