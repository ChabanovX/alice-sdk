import json
import requests
import asyncio
from typing import Dict


class OpenRouterError(RuntimeError):
    """Error by request to OpenRouter."""
    def __str__(self) -> str:
        return str(self.args[0]) if self.args else ""


class QueryResolver:
    def __init__(self):
        self.ENDPOINT = "https://openrouter.ai/api/v1/chat/completions"
        self.MODEL_ID = "mistralai/mistral-7b-instruct:free"

        try:
            with open("api-keys.txt", "r", encoding="utf-8") as f:
                self.keys = [line.strip() for line in f if line.strip()]
            if not self.keys:
                raise OpenRouterError("File api-key.txt does not contains api-keys")
        except FileNotFoundError:
            raise OpenRouterError("File api-key.txt not found")

        self.current_index = 0
        self.request_count = 0
        self.switch_interval = 50

        self.HEADERS_BASE = {
            "X-Title": "taxi-intent-wrapper",
            "Content-Type": "application/json",
        }
        self.PROMPT = """
        Ты — модуль распознавания интента для голосового ассистента-таксиста.
        Возвращай строго и только валидный JSON (ни слова, ни пояснений) с четырьмя полями:
        {
        "scenario": "<ACCEPT_ORDER|CANCEL_ORDER|VOICE_MESSAGE|VOICE_WISH|CALL_PASSENGER|CREATE_ROUTE|CHOOSE_ROUTE|BUSINESS|HOME|FIND|CHANGE_FARE|OTHER>",
        "address": "<строка или пустая строка>",
        "route_number": <число или null>,
        "fare": "<эконом|комфорт|комфорт+ или пустая строка>"
        }

        Пользуйся телько этими правилами, не придумывай данные которых нет на входе.

        Правила определения:
        - Если не уверен в сценарии — верни "OTHER".
        - Сценарии (примерные фразы):
        ACCEPT_ORDER: "прими заказ", "беру", "подтверди заказ"
        CANCEL_ORDER: "откажись от заказа", "не беру", "Не бери заказ"
        VOICE_MESSAGE: "озвучь сообщение пассажира", "что сказал пассажир"
        VOICE_WISH: "есть ли лыжи", "есть собаки", "есть животные", "скажи пожелания пассажира"
        CALL_PASSENGER: "позвони пассажиру", "свяжись с пассажиром"
        CREATE_ROUTE: "проложи маршрут ...", "как доехать ...", "маршрут до ...", "поехали до ..."
        CHOOSE_ROUTE: "первый маршрут", "второй", "3", "давай по второму"
        BUSINESS: "По делам до ...", "Включи режим по делам"
        HOME: "Домой", "Хочу домой", "Поехали домой"
        FIND: "Найди ближайший ...", "Где поблизости ..."
        CHANGE_FARE: "Поменяй тариф на эконом/комфорт/комфорт+"
        OTHER: любое прочее

        Извлечение адреса:
        - Только для сценариев CREATE_ROUTE|BUSINESS|FIND
        - Ищи адрес после триггер-слов: "на", "в", "до", "улица", "ул.", "проспект", "пр.", "пл.", "площадь", "дом", "рядом с", "возле", "ориентир" и т.п.
        - Возвращай **ровно** ту подстроку, которая соответствует адресу в запросе, без вводных/служебных слов ("поехали", "давай", "пожалуйста").
        - Если не найден явный адрес или не тот сценарий — вернуть пустую строку.

        Извлечение тарифа:
        - Только для сценария CHANGE_FARE
        - Для CHANGE_FARE ищи слова "эконом", "комфорт", "комфорт+" (в разных падежах); верни нормализованную форму: "эконом", "комфорт" или "комфорт+" в поле `fare`. Если тариф не найден или не тот сценарий — пустая строка.

        Извлечение номера маршрута:
        - Только для сценария CHOOSE_ROUTE
        - Для CHOOSE_ROUTE возвращай выбранный номер как integer в поле `route_number`; `address` — пустая строка.
        - Если номер не найден или не тот сценарий - то null

        Возврат:
        - `route_number` — integer или null.
        - `address` и `fare` — строки; если нет — пустая строка.

        Примеры (обязательно возвращай только JSON):
        Вход: "Проложи маршрут до ул. Ленина, 10, подъезд 2"
        Выход: {"scenario":"CREATE_ROUTE","address":"ул. Ленина, 10, подъезд 2","route_number":null,"fare":""}

        Вход: "Первый вариант"
        Выход: {"scenario":"CHOOSE_ROUTE","address":"","route_number":1,"fare":""}

        Вход: "Поменяй тариф на комфорт+"
        Выход: {"scenario":"CHANGE_FARE","address":"","route_number":null,"fare":"комфорт+"}

        Вход: "Прими заказ"
        Выход: {"scenario":"ACCEPT_ORDER","address":"","route_number":null,"fare":""}

        Вход: "Расскажи анекдот"
        Выход: {"scenario":"OTHER","address":"","route_number":null,"fare":""}
        """
    def _switch_key(self):
        self.current_index = (self.current_index + 1) % len(self.keys)
        self.request_count = 0

    def _get_api_key(self) -> str:
        if self.request_count >= self.switch_interval:
            self._switch_key()
        self.request_count += 1
        return self.keys[self.current_index]

    def _build_headers(self) -> Dict[str, str]:
        return {"Authorization": f"Bearer {self._get_api_key()}", **(self.HEADERS_BASE)}

    def _send_request(self, query: str) -> requests.Response:
        payload = {
            "model": self.MODEL_ID,
            "messages": [
                {"role": "system", "content": self.PROMPT},
                {"role": "user", "content": query},
            ],
            "temperature": 0.3,
            "max_tokens": 128,
            "stream": False,
        }

        return requests.post(
            self.ENDPOINT,
            headers=self._build_headers(),
            data=json.dumps(payload),
            timeout=60,
        )

    def _get_body(self, query: str) -> requests.Response:
        for _ in range(len(self.keys)):
            try:
                r = self._send_request(query)
                if r.status_code == 429:  # лимит по ключу
                    self._switch_key()
                    continue
                r.raise_for_status()
                return r

            except requests.RequestException as e:
                raise OpenRouterError(f"HTTP-error: {e}") from e

        raise OpenRouterError("All API keys exhausted or returned 429(limit error)")

    def query_to_json(self, query: str) -> str:
        r = self._get_body(query)

        try:
            body = r.json()
            raw_content = body["choices"][0]["message"]["content"]
            parsed = json.loads(raw_content)
            scenario = parsed.get("scenario", "OTHER")

            address = parsed.get("address", "")
            if scenario not in {"CREATE_ROUTE", "BUSINESS", "FIND"}:
                address = ""

            route_number = None
            if scenario == "CHOOSE_ROUTE":
                raw_num = parsed.get("route_number")
                if raw_num is not None and str(raw_num).strip() != "":
                    try:
                        route_number = int(raw_num)
                    except (ValueError, TypeError):
                        route_number = None

            fare = ""
            if scenario == "CHANGE_FARE":
                raw_fare = (parsed.get("fare") or "").lower().strip()
                if raw_fare in {"эконом", "экономный", "эконому"}:
                    fare = "эконом"
                elif "комфорт+" in raw_fare or raw_fare == "комфорт+":
                    fare = "комфорт+"
                elif "комфорт" in raw_fare:
                    fare = "комфорт"
                else:
                    fare = ""
        except (KeyError, IndexError, ValueError, json.JSONDecodeError) as e:
            raise OpenRouterError(f"OpenRouter bad response: {r.text}") from e

        result = {
            "scenario": scenario,
            "address": address,
            "route_number": route_number,  # None -> станет null в JSON
            "fare": fare,
        }

        return result

def processText(raw_text: str) -> str:
    resolver = QueryResolver()
    return resolver.query_to_json(raw_text)