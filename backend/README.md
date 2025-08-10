# classifier_service

## Описание приложения

На данный момент сервис имеет одну единственную ручку `/classify-message` в которую дается текст из голосового сообщения, а на выход выдается `json` со сценарием + доп. информация.

Пример команды:

```bash
curl -i \
-X POST "http://localhost:8080/classify-message" \
-d '{"text": "Прими заказ"}'
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

```bash
docker build -t classifier_service_dev -f Dockerfile .
docker run -p 8080:8080 -it classifier_service_dev
```