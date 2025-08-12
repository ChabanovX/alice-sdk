# Alice Voice Player

A pure Dart library for text-to-speech synthesis using Yandex SpeechKit. Provides headless TTS capabilities without UI dependencies.

## Features

- **Pure Dart**: No Flutter dependencies, works in any Dart environment
- **Yandex SpeechKit Integration**: Direct integration with Yandex Cloud TTS API
- **Multiple Output Formats**: Support for MP3, WAV, and other formats
- **Streaming Support**: Process long texts efficiently with streaming API
- **Error Handling**: Comprehensive error handling with retry logic
- **Configurable**: Customizable voice, format, and audio parameters

## Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  alice_voice_player:
    path: packages/alice_voice_player
```

## Quick Start

### Basic Usage

```dart
import 'dart:io';
import 'package:alice_voice_player/alice_tts.dart';

Future<void> main() async {
  final tts = YandexSpeechKitTts();
  
  await tts.init(
    apiKey: Platform.environment['YANDEX_API_KEY']!,
    folderId: Platform.environment['YANDEX_FOLDER_ID'],
    voice: 'alena',
    format: 'mp3',
    sampleRateHz: 48000,
  );
  
  final bytes = await tts.synthesizeBytes('Привет! Это проверка голоса.');
  await File('result.mp3').writeAsBytes(bytes);
  print('Готово: result.mp3, размер: ${bytes.length} байт');
}
```

### Streaming Usage

```dart
final audioStream = tts.synthesizeStream('Длинный текст для стриминга...');

await for (final chunk in audioStream) {
  // Process audio chunk
  print('Получен чанк: ${chunk.length} байт');
}
```

### Echo Service

```dart
final echoService = AliceEchoService(tts);
final audioBytes = await echoService.echo('Текст для озвучивания');
```

## Configuration

### Authentication

You can authenticate using either:

1. **API Key** (recommended):
```dart
await tts.init(apiKey: 'your-api-key');
```

2. **OAuth Token + Folder ID**:
```dart
await tts.init(
  apiKey: 'your-api-key',
  oauthToken: 'your-oauth-token',
  folderId: 'your-folder-id',
);
```

### Voice Settings

```dart
await tts.init(
  apiKey: 'your-api-key',
  voice: 'alena',        // Available: alena, filipp, jane, omazh, oksana
  format: 'mp3',         // Available: mp3, wav, oggopus
  sampleRateHz: 48000,   // Sample rate in Hz
  timeout: Duration(seconds: 10),
);
```

## Error Handling

The library provides detailed error information:

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
    case AliceTtsExceptionType.rateLimit:
      print('Rate limit exceeded: ${e.message}');
      break;
    default:
      print('Other error: ${e.message}');
  }
}
```

## Examples

### CLI Example

```bash
# Basic usage
dart run examples/echo_cli.dart --text "Hello world" --out "result.mp3"

# With custom voice
dart run examples/echo_cli.dart --text "Привет мир" --voice "alena" --out "hello.mp3"

# Using environment variables
export YANDEX_API_KEY="your-api-key"
export YANDEX_FOLDER_ID="your-folder-id"
dart run examples/echo_cli.dart --text "Test" --out "test.mp3"
```

### Stream Example

```bash
dart run examples/echo_stream.dart your-api-key result.mp3
```

## API Reference

### AliceTts

Main interface for TTS operations:

```dart
abstract class AliceTts {
  Future<void> init({...});
  Future<Uint8List> synthesizeBytes(String text);
  Stream<List<int>> synthesizeStream(String text);
  Future<Uint8List> onTextInput(String text);
  Future<Uint8List> onVoiceInput(String recognizedText);
  Future<void> dispose();
}
```

### YandexSpeechKitTts

Implementation for Yandex SpeechKit:

```dart
class YandexSpeechKitTts implements AliceTts {
  // Implementation details
}
```

### AliceEchoService

Helper service for echo functionality:

```dart
class AliceEchoService {
  Future<Uint8List> echo(String text);
  Stream<List<int>> echoStream(String text);
}
```

## Setup

1. **Yandex Cloud Account**: Create an account at [cloud.yandex.ru](https://cloud.yandex.ru)
2. **SpeechKit Service**: Enable SpeechKit in your Yandex Cloud project
3. **API Key**: Generate an API key in the Yandex Cloud console
4. **Folder ID**: Note your folder ID (optional, but recommended)

## Environment Variables

Set these environment variables for authentication:

```bash
export YANDEX_API_KEY="your-api-key"
export YANDEX_FOLDER_ID="your-folder-id"
```

## Limitations

- **No STT**: This library only provides TTS (text-to-speech), not STT (speech-to-text)
- **Yandex Only**: Currently only supports Yandex SpeechKit
- **No UI**: This is a headless library, no UI components included

## Testing

Run the test suite:

```bash
dart test
```

## License

This project is licensed under the MIT License.
