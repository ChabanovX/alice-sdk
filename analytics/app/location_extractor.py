from transformers import pipeline


class LocationExtractor:
    def __init__(self) -> None:
        self.ner_pipe = pipeline("ner", model="aidarmusin/address-ner-ru", device=-1)

    def _get_token_text(self, token: str) -> str:
        return (" " if not token['word'].startswith("#") else "") + token['word'].lstrip("#")

    def extract_location(self, text: str) -> dict[str, str | list[str]]:
        address_data = self.ner_pipe(text)
        places: str = ""
        address: str = ""

        for token in address_data:
            token_text = self._get_token_text(token)
            if token['entity'].endswith('Settlement'):
                places += token_text
            else:
                address += token_text

        address = address.strip()
        places = places.strip().split()

        return {
            "places": places,
            "addresses": address
        }
