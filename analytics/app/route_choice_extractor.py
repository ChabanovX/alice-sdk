import re
from pymorphy3 import MorphAnalyzer

class RouteChoiceExtractor:
    def __init__(self) -> None:
        self.morph: MorphAnalyzer = MorphAnalyzer()
        self.numeral_map = {
            'один': 1, 'первый': 1,
            'два': 2, 'второй': 2,
            'три': 3, 'третий': 3,
            'четыре': 4, 'четвертый': 4,
            'пять': 5, 'пятый': 5,
            'шесть': 6, 'шестой': 6,
            'семь': 7, 'седьмой': 7,
            'восемь': 8, 'восьмой': 8,
            'девять': 9, 'девятый': 9,
            'десять': 10, 'десятый': 10,
        }


    def extract_route_choice(self, text: str) -> str:
        found_numbers: list[str] = []

        found_numbers.extend(filter(lambda x: 1 <= x <= 10, map(int, re.findall(r'\b\d+\b', text))))

        words: list[str] = text.strip(".!?;").split()
        for word in words:
            parsed_word = self.morph.parse(word)[0]

            if parsed_word.normal_form in self.numeral_map:
                found_numbers.append(self.numeral_map[parsed_word.normal_form])

        return found_numbers
