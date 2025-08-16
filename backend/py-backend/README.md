# Speechkit-service

## Описание сервиса

Сервис для потоковой обработки голосовых сообщений по WebSocket.

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

3) Внестите api-ключ в переменную окружения:

```bash
export API_KEY= ...Ваш api-ключ от yandex speech-kit, (как его получить смотрите в документации)...
```

4) Запустите сервис:

```bash
fastapi run app/server.py --port 8081
```

Готово! Ваш сервис доступен по адресу: `http://localhost:8081`, API вебсокета: `ws://localhost:8081/ws`

5) Выполните один из файлов примера(из того же виртуального окружения), рассмотрите их подробно:

---
С помощью микрофона:

```bash
python3 examples/example-mic-stream.py
```

---
С помощью аудиофайла:

```bash
python3 examples/example-client.py --file audio_examples/find-close-scenario.wav
```

---

### Формат аудиодорожек

- язык — русский;
- формат аудиопотока — LPCM с частотой дискретизации 8000 Гц;
- количество аудиоканалов — 1;

### Примечание

Рекомендуется отдавать примерно **4000** байтов за раз, в таком формате это получается отправка чанка раз в **250** мс, что довольно оптимально.

## Запуск в docker-контейнере(рекомендуется)

1) Внесите api-ключ в переменную окружения

2) Выполните сборку:

```bash
docker build -t speechkit-service .
```

3) Запустите сервис:

```bash
docker run --rm -p 8081:8081 -e API_KEY="$API_KEY" speechkit-service
```

### Тестирование

1) Создайте виртуальное окружение:

```bash
python3 -m venv venv
source venv/bin/activate
```

2) Установите зависимости:

```bash
pip install --no-cache-dir --upgrade -r requirements.txt
```

3) Внестите api-ключ в переменную окружения:

```bash
export API_KEY= ...Ваш api-ключ от yandex speech-kit, (как его получить смотрите в документации)...
```

4) Запустите сервис:

```bash
fastapi run app/server.py --port 8081
```

5) Запустите тесты:

```bash
cd tests
pytest -v test-ws.py
```