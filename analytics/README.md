# Analytics_server

## Описание сервиса

`TBA`

## Работа с приложением

1) Создайте виртуальное окружение:

```bash
python3 -m venv venv
source venv/bin/activate
```

2) Установите зависимости:

```bash
pip install --no-cache-dir --upgrade -r requirements.txt
```

3) Запустите сервис:

```bash
fastapi dev app/main.py
```

4) После старта сервиса будет доступна документация по адресу `http://localhost:8000/docs`

Попробуйте постучаться в сервис:

```bash
curl -X 'POST' \
  'http://localhost:8000/cluster' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
  "text": "Приними заказ плиз"
}'
```

## Тестирование

- Запустите тесты по команде из виртуального окружения:

```bash
python -m pytest -c tests/pytest.ini
```

## Запуск в docker контейнере

Прежде всего вам потребуется `docker`, установите с помощью вашего пакетного менеджера (или скачайте `docker-desktop`)

1) Соберите образ командой: `docker build -t analytics-server .`

2) Запустите контейнер: `docker run -p 8000:8000 analytics-server`

3) Сервис будет доступен по адресу: `http://localhost:8000/cluster`, а автоматическая документация по адресу `http://localhost:8000/docs`
