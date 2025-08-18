from app.intention_classifier import IntentClassifier
from app.location_extractor import LocationExtractor
from app.tariff_classifier import TariffClassifier
from app.route_choice_extractor import RouteChoiceExtractor


class VoiceAssistant:
    def __init__(self) -> None:
        self.intention_classifier = IntentClassifier()
        self.tariff_classifier: TariffClassifier = TariffClassifier()
        self.route_choice_extractor: RouteChoiceExtractor = RouteChoiceExtractor()
        self.location_extractor: LocationExtractor = LocationExtractor()

    def get_request_and_details(self, text: str) -> dict:
        text = text.lower()
        result: dict[str, str | dict] = {
            "intention": self.intention_classifier.predict_intention(text),
        }
        if result["intention"] == "tariff_change":
            result["tariff"] = self.tariff_classifier.predict_tariff(text)
        elif result["intention"] == "route_choice":
            result["route_choice"] = self.route_choice_extractor.extract_route_choice(text)
        elif result["intention"] in ("find_nearby_places", "route", "business"):
            result["location"] = self.location_extractor.extract_location(text)
        return result

    def get_request_details_by_type(self, text: str, request_type: str) -> dict:
        text = text.lower()
        result: dict[str, str | dict] = {
            "intention": request_type,
        }
        if result["intention"] == "tariff_change":
            result["tariff"] = self.tariff_classifier.predict_tariff(text)
        elif result["intention"] == "route_choice":
            result["route_choice"] = self.route_choice_extractor.extract_route_choice(text)
        elif result["intention"] in ("find_nearby_places", "route", "business"):
            result["location"] = self.location_extractor.extract_location(text)
        return result
