# Alice Voice Assistant - Mobile App

Мобильное приложение такси с интегрированным голосовым помощником "Алиса" для управления заказами и взаимодействия с системой.

## Архитектура проекта

### Технический стек:
- **Framework**: Flutter 3.x
- **State Management**: BLoC Pattern
- **DI Container**: GetIt
- **UI**: Custom Material Design 3
- **Audio**: just_audio для воспроизведения
- **Recording**: record + speech_to_text для записи
- **Network**: WebSocket для реального времени

### Архитектурные паттерны:

**Clean Architecture + Feature-based структура**
```
lib/
├── features/
│   ├── orders/           # Управление заказами
│   ├── profile/          # Профиль водителя
│   ├── chat/             # Чат с пассажирами
│   └── navigation/       # Главная навигация
├── widgets/
│   └── alice/            # Компоненты голосового помощника
├── core/
│   ├── services/         # Голосовые сервисы
│   └── navigation/       # Система навигации
└── di.dart              # Dependency Injection
```

## Реализация голосового помощника

### 1. Сервис распознавания команд (`AliceCommandRecognizeService`)

**Принцип работы:**
- Пассивное прослушивание ключевого слова "Алиса" через `speech_to_text`
- При обнаружении → активация записи команды
- Отправка аудио через WebSocket на backend для NLP обработки
- Получение классифицированной команды

```dart
// Основные команды
enum AliceCommand {
  accept,                    // "Принять заказ"
  decline,                   // "Отклонить"  
  readPassengerMessage,      // "Прочитать сообщение"
  readPassengerPreferences,  // "Прочитать предпочтения"
}
```

**Реализация WebSocket подключения:**
```dart
// WebSocket для распознавания
_socket = await WebSocket.connect(
  'ws://ws.158.160.191.199.nip.io:30080/ws',
  headers: {'Authorization': getAuth()},
);

// Отправка аудио chunks в реальном времени
final stream = await _recorder.startStream(config);
stream.listen((chunk) => _socket?.add(chunk));
```

### 2. Сервис синтеза речи (`AliceSpeakingService`)

**Text-to-Speech через WebSocket:**
- Подключение к TTS endpoint
- Потоковая передача текста
- Получение Ogg/Opus аудио chunks
- Кэширование в временные файлы + воспроизведение

```dart
// Синтез речи
Future<void> sayText(String phrase) async {
  final oggFile = await _synthesizeToTempFile(phrase);
  await _ttsPlayer.setFilePath(oggFile.path);
  await _ttsPlayer.play();
}

// WebSocket TTS
final ws = await WebSocket.connect(
  'ws://158.160.191.199:30080/text-to-speech',
  headers: {'Authorization': getAuth()}
);
ws.add(text);  // Отправляем текст
// Получаем аудио chunks и записываем в файл
```

**Звуковые эффекты:**
- Активация: `assets/audio/alice_on.mp3`
- Деактивация: `assets/audio/alice_off.mp3`
- Audio ducking при одновременном воспроизведении

### 3. BLoC управление состоянием

**AliceBloc** управляет жизненным циклом голосового помощника:

```dart
sealed class AliceState {
  AliceSleeping();  // Пассивное прослушивание "Алиса"
  AliceActive();    // Запись команды
}

// События
AliceStartListening();  // Ключевое слово распознано
AliceStopListening();   // Команда обработана/таймаут
```

**Интеграция с UI:**
```dart
BlocListener<AliceBloc, AliceState>(
  listener: (context, state) {
    if (state is AliceActive) {
      // Показать индикатор записи
      // Запустить анимацию
    }
  }
)
```

### 4. UI компоненты голосового интерфейса

**AliceFloatingWidget** - главный виджет помощника:
- Автоматическое позиционирование над любыми BottomSheet
- Анимированные состояния (покой/активность)
- Речевые пузыри с сообщениями
- Масштабирование при активации

**Адаптивное позиционирование:**
```dart
// Отслеживание высоты BottomSheet для корректного размещения
ValueListenableBuilder<double>(
  valueListenable: BottomSheetManager().scaffoldBottomSheetHeight,
  builder: (context, height, child) {
    return AnimatedPositioned(
      bottom: height + 16, // 16px над BottomSheet
      child: AliceWidget(),
    );
  }
)
```

## Интеграция в бизнес-логику приложения

### Голосовое управление заказами:

**OrdersPage** подписывается на команды Alice:
```dart
// Подписка на голосовые команды
_commandSubscription = aliceBloc.commandStream.listen((command) {
  switch (command) {
    case AliceCommand.accept:
      if (state is OfferArrived) {
        speaker.sayText('Приняла.');
        ordersBloc.add(AcceptOfferPressed());
      }
    case AliceCommand.readPassengerMessage:
      speaker.sayText('Читаю: ${order.message}');
  }
});
```

### Контекстно-зависимые ответы:

Alice анализирует текущее состояние приложения:
```dart
// Различные ответы в зависимости от контекста
if (state is OfferArrived) {
  speaker.sayText('Приняла заказ');
} else {
  speaker.sayText('У вас нет доступных заказов');
}
```

### Проактивные уведомления:

```dart
// Автоматические голосовые уведомления
if (state is InRedZone) {
  speaker.sayText('Упс, вы в красной зоне. Покиньте ее как можно скорее');
}

if (state is OfferArrived) {
  speaker.sayText('Вау! Повышенный коэффициент! ${order.coefficient}!');
}
```

## Особенности реализации

### Система навигации:
- Мульти-навигаторы для каждой вкладки bottom navigation
- Кастомная система BottomSheet с измерением высоты
- Адаптивное позиционирование Alice относительно модальных окон

### Performance оптимизации:
- Стриминг аудио для минимизации задержек
- Кэширование TTS в temp файлах
- Переиспользование WebSocket соединений
- Lazy loading голосовых сервисов

### Запуск проекта:

```bash
# Установка зависимостей
flutter pub get

# Настройка permissions для микрофона
# Android: android/app/src/main/AndroidManifest.xml

# Запуск приложения  
flutter run

# Тестирование голосовых команд:
# 1. Скажите "Алиса" для активации
# 2. "Принять заказ" / "Отклонить" / "Прочитать сообщение"
```

Проект демонстрирует современную реализацию голосового интерфейса в мобильном приложении с использованием WebSocket, потокового аудио и реактивной архитектуры на Flutter.
