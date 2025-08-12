# Migration Guide

This guide helps you migrate from the old Flutter-dependent `alice_voice_player` to the new pure Dart TTS library.

## Breaking Changes

### 1. Package Name Change
- **Old**: `alice_voice_assistant`
- **New**: `alice_voice_player`

### 2. Flutter Dependencies Removed
The new package is a pure Dart library with no Flutter dependencies.

### 3. API Changes

#### Old API (Flutter-based)
```dart
import 'package:alice_voice_assistant/alice_voice_player.dart';

// Initialize
final alice = AliceVoiceAssistant();

// Play audio files
await alice.playAudio('assets/audio/message.mp3');

// Use widgets
AliceAnimatedLogo(
  logoPath: 'assets/images/alice.png',
  size: 100,
)
```

#### New API (Pure Dart TTS)
```dart
import 'package:alice_voice_player/alice_tts.dart';

// Initialize
final tts = YandexSpeechKitTts();
await tts.init(
  apiKey: 'your-api-key',
  voice: 'alena',
  format: 'mp3',
);

// Synthesize text to audio
final bytes = await tts.synthesizeBytes('Hello world');
await File('result.mp3').writeAsBytes(bytes);
```

## Migration Steps

### Step 1: Update Dependencies

**Old pubspec.yaml:**
```yaml
dependencies:
  alice_voice_assistant:
    path: packages/alice_voice_player
  flutter:
    sdk: flutter
  just_audio: ^0.9.36
```

**New pubspec.yaml:**
```yaml
dependencies:
  alice_voice_player:
    path: packages/alice_voice_player
  http: ^1.1.0
```

### Step 2: Update Imports

**Old:**
```dart
import 'package:alice_voice_assistant/alice_voice_player.dart';
```

**New:**
```dart
import 'package:alice_voice_player/alice_tts.dart';
```

### Step 3: Replace Audio Playback Logic

**Old (playing audio files):**
```dart
final alice = AliceVoiceAssistant();
await alice.playAudio('assets/audio/hello.mp3');
```

**New (synthesizing text):**
```dart
final tts = YandexSpeechKitTts();
await tts.init(apiKey: 'your-api-key');

final bytes = await tts.synthesizeBytes('Hello world');
// Save to file or pass to audio player
await File('hello.mp3').writeAsBytes(bytes);
```

### Step 4: Remove Widget Usage

**Old (Flutter widgets):**
```dart
AliceAnimatedLogo(
  logoPath: 'assets/images/alice.png',
  size: 100,
  glowColor: Colors.blue,
)
```

**New (no widgets):**
```dart
// Widgets are removed. Use your own UI components.
// The TTS library only provides audio synthesis.
```

### Step 5: Update Error Handling

**Old:**
```dart
try {
  await alice.playAudio('audio.mp3');
} catch (e) {
  print('Playback error: $e');
}
```

**New:**
```dart
try {
  final bytes = await tts.synthesizeBytes('Hello world');
} on AliceTtsException catch (e) {
  switch (e.type) {
    case AliceTtsExceptionType.auth:
      print('Authentication error: ${e.message}');
      break;
    case AliceTtsExceptionType.network:
      print('Network error: ${e.message}');
      break;
    default:
      print('TTS error: ${e.message}');
  }
}
```

## Integration with Flutter Apps

If you're using this in a Flutter app, you'll need to handle audio playback separately:

```dart
import 'package:audioplayers/audioplayers.dart';
import 'package:alice_voice_player/alice_tts.dart';

class FlutterTtsService {
  final YandexSpeechKitTts _tts = YandexSpeechKitTts();
  final AudioPlayer _player = AudioPlayer();

  Future<void> initialize() async {
    await _tts.init(apiKey: 'your-api-key');
  }

  Future<void> speak(String text) async {
    final bytes = await _tts.synthesizeBytes(text);
    
    // Save to temporary file
    final tempFile = File('${Directory.systemTemp.path}/tts_${DateTime.now().millisecondsSinceEpoch}.mp3');
    await tempFile.writeAsBytes(bytes);
    
    // Play with audioplayers
    await _player.play(DeviceFileSource(tempFile.path));
  }

  void dispose() {
    _player.dispose();
    _tts.dispose();
  }
}
```

## Configuration Migration

### Old Configuration
```dart
final config = AliceConfiguration(
  maxQueueSize: 10,
  interruptOnHighPriority: true,
  defaultVolume: 0.8,
  amplitudeSimulation: AmplitudeSimulationConfig(
    enabled: true,
    baseAmplitude: 0.5,
  ),
);
```

### New Configuration
```dart
await tts.init(
  apiKey: 'your-api-key',
  voice: 'alena',
  format: 'mp3',
  sampleRateHz: 48000,
  timeout: Duration(seconds: 10),
  maxRetries: 3,
  retryDelay: Duration(seconds: 1),
);
```

## Testing Migration

### Old Tests
```dart
testWidgets('Alice widget test', (tester) async {
  await tester.pumpWidget(AliceAnimatedLogo());
  // Widget tests
});
```

### New Tests
```dart
test('TTS synthesis test', () async {
  final tts = YandexSpeechKitTts();
  await tts.init(apiKey: 'test-key');
  
  expect(() => tts.synthesizeBytes('test'), throwsA(isA<AliceTtsException>()));
});
```

## Common Issues

### 1. "Flutter dependencies not found"
**Solution**: The new package is pure Dart. Remove Flutter-specific imports and dependencies.

### 2. "Widget not found"
**Solution**: Widgets are removed. Use your own UI components or integrate with Flutter audio packages.

### 3. "Audio playback not working"
**Solution**: The new library only synthesizes audio. You need to handle playback separately using packages like `audioplayers` or `just_audio`.

### 4. "API key required"
**Solution**: Set up Yandex Cloud SpeechKit and provide API credentials.

## Support

If you encounter issues during migration:

1. Check the [README.md](README.md) for usage examples
2. Run the examples: `dart run examples/echo_cli.dart`
3. Review the test files for implementation details
4. Ensure you have valid Yandex Cloud credentials
