## 🚀 Быстрый старт

### 1. Установка

Добавьте в `pubspec.yaml`:
```yaml
dependencies:
  alice_voice_assistant:
    path: path/to/alice_voice_player
```

### 2. Добавьте аудио файлы

В `pubspec.yaml`:
```yaml
flutter:
  assets:
    - assets/audio/
    - assets/images/
```

### 3. Базовое использование

```dart
import 'package:alice_voice_player/alice_voice_player.dart';

// Воспроизведение аудио
final alice = AliceVoiceAssistant();
await alice.playAudio('assets/audio/message.mp3');
```

### 4. Использование анимированного виджета

```dart
import 'package:flutter/material.dart';
import 'package:alice_voice_assistant/alice_voice_player.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            // Анимированный логотип - автоматически реагирует на аудио
            AliceAnimatedLogo(
              logoPath: 'assets/images/alice.png',
              size: 100,
              glowColor: Colors.blue,
            ),
            
            ElevatedButton(
              onPressed: () {
                AliceVoiceAssistant().playAudio('assets/audio/hello.mp3');
              },
              child: Text('Воспроизвести'),
            ),
          ],
        ),
      ),
    );
  }
}
```

## 🎨 Виджеты

### AliceAnimatedLogo
Базовый анимированный логотип с эффектами свечения и пульсации.

```dart
AliceAnimatedLogo(
  logoPath: 'assets/images/alice.png',
  size: 100,
  glowColor: Colors.blue,
  pulseIntensity: 0.3,
  showGlow: true,
  showRipple: true,
)
```

### AliceAnimatedLogoAdvanced
Продвинутый виджет с анимированными звуковыми волнами.

```dart
AliceAnimatedLogoAdvanced(
  logoPath: 'assets/images/alice.png',
  size: 150,
  waveColor: Colors.teal,
  showSoundWaves: true,
  waveCount: 4,
)
```

## 🔧 Конфигурация

```dart
final config = AliceConfiguration(
  maxQueueSize: 10,
  interruptOnHighPriority: true,
  defaultVolume: 0.8,
);

final alice = AliceVoiceAssistant(config);
```

## 📋 Примеры использования

### Воспроизведение с приоритетом
```dart
// Обычное сообщение
await alice.playAudio('assets/audio/info.mp3');

// Срочное сообщение (прерывает текущее)
await alice.playAudio(
  'assets/audio/urgent.mp3',
  priority: MessagePriority.high,
  immediate: true,
);
```

### Управление очередью
```dart
// Проверить длину очереди
print('Сообщений в очереди: ${alice.queueLength}');

// Очистить очередь
alice.clearQueue();

// Остановить воспроизведение
await alice.stop();
```

### Управление громкостью
```dart
// Установить громкость (0.0 - 1.0)
await alice.setVolume(0.5);
```

## 🎯 Готовые методы для такси-приложений

```dart
await alice.playAnswerNewOrder();              // Новый заказ
await alice.playAnswerPassengerMessage(text);  // Сообщение пассажира
await alice.playAnswerRouteBuilt(time, dist);  // Маршрут построен
await alice.playAnswerOrderCompleted();        // Заказ завершен
```
