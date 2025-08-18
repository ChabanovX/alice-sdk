from enum import Enum
from typing import Optional
from pydantic import BaseModel


class RequestType(str, Enum):
    accept = "accept"
    decline = "decline"
    read_passenger_message = "read_passenger_message"
    read_passenger_preferences = "read_passenger_preferences"
    call_passenger = "call_passenger"
    route = "route"
    route_choice = "route_choice"
    business = "business"
    home = "home"
    find_nearby_places = "find_nearby_places"
    tariff_change = "tariff_change"
    other = "other"


class RawText(BaseModel):
    text: str


class TextWithRequestType(BaseModel):
    text: str
    request_type: RequestType


class ProcessedText(BaseModel):
    intention: RequestType
    addresses: Optional[str] = None
    route_choice: Optional[list[int]] = None
    tariff: Optional[str] = None
    places: Optional[list[str]] = None
