# classifier_service

## Описание приложения

На данный момент сервис имеет одну единственную ручку `/classify-message` в которую дается текст из голосового сообщения, а на выход выдается `json` со сценарием + доп. информация.

Пример команды:

```bash
curl -i \
-X POST "http://localhost:8080/classify-message" \
-H "Content-Type: application/json" \
-d '{"user_id": "u", "voice_start_time": "2025-08-16T22:55:00+0300", "request_text": "где рядом дом 1 пушкина"}'
```

Пример ответа:
```
{"intention":"home","addresses":null,"route_choice":null,"tariff":null,"places":null}
```

## Работа с приложением

### Требования

Необходимо, чтобы были установлены следующие компоненты:

- **Docker**
- VSCode Dev Containers Extension (если собираетесь работать с дев. контейнерами)

### Сборка

Запуск сборки из дев. контейнера(рекомендуется):

```bash
make build-release
```

Запуск сборки via Docker:

```bash
make docker-build-release
```

### Запуск сервиса

Запуск сервиса из дев. контейнера(рекомендуется):

```bash
make start-release
```

Запуск сервиса via Docker:

```bash
make docker-start-release
```

### Тестирование

Запуск тестов из дев. контейнера(рекомендуется):

```bash
make test-release
```

Запуск тестов via Docker:

```bash
make docker-test-release
```

#### Продакшн

Из папки `backend` запустите:

```bash
docker compose up
```

И попробуйте постучаться в сервер (команда выше)

В ответ придет `json`
