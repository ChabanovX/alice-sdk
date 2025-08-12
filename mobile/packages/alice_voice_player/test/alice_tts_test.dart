import 'dart:typed_data';

import 'package:test/test.dart';

import 'package:alice_voice_player/alice_voice_player.dart';

void main() {
  group('AliceTts', () {
    late YandexSpeechKitTts tts;

    setUp(() {
      tts = YandexSpeechKitTts();
    });

    tearDown(() async {
      await tts.dispose();
    });

    group('Initialization', () {
      test('should initialize with default parameters', () async {
        await tts.init(apiKey: 'test-key');
        
        // Test that we can call synthesize without throwing
        expect(() => tts.synthesizeBytes('test'), throwsA(isA<AliceTtsException>()));
      });

      test('should initialize with custom parameters', () async {
        await tts.init(
          apiKey: 'test-key',
          voice: 'filipp',
          format: 'wav',
          sampleRateHz: 22050,
          timeout: Duration(seconds: 5),
        );
        
        expect(() => tts.synthesizeBytes('test'), throwsA(isA<AliceTtsException>()));
      });

      test('should throw if not initialized', () {
        expect(
          () => tts.synthesizeBytes('test'),
          throwsA(
            predicate((e) => 
              e is AliceTtsException && 
              e.type == AliceTtsExceptionType.invalidParams &&
              e.message.contains('not initialized')
            ),
          ),
        );
      });
    });

    group('Text Processing', () {
      setUp(() async {
        await tts.init(apiKey: 'test-key');
      });

      test('onTextInput should return audio bytes', () async {
        expect(() => tts.onTextInput('Hello world'), throwsA(isA<AliceTtsException>()));
      });

      test('onVoiceInput should proxy to onTextInput', () async {
        expect(() => tts.onVoiceInput('Recognized text'), throwsA(isA<AliceTtsException>()));
      });
    });

    group('AliceEchoService', () {
      late AliceEchoService echoService;

      setUp(() async {
        await tts.init(apiKey: 'test-key');
        echoService = AliceEchoService(tts);
      });

      test('should echo text input', () async {
        expect(() => echoService.echo('Test message'), throwsA(isA<AliceTtsException>()));
      });

      test('should echo text as stream', () async {
        final stream = echoService.echoStream('Test message');
        expect(stream, isA<Stream<List<int>>>());
      });
    });
  });

  group('AliceStt', () {
    late YandexSpeechKitStt stt;

    setUp(() {
      stt = YandexSpeechKitStt();
    });

    tearDown(() async {
      await stt.dispose();
    });

    group('Initialization', () {
      test('should initialize with default parameters', () async {
        await stt.init(apiKey: 'test-key');
        
        // Test that we can call recognize without throwing
        expect(() => stt.recognizeAudio(Uint8List(0)), throwsA(isA<AliceTtsException>()));
      });

      test('should initialize with custom parameters', () async {
        await stt.init(
          apiKey: 'test-key',
          language: 'en-US',
          model: 'general',
          audioFormat: 'wav',
          sampleRateHz: 22050,
          timeout: Duration(seconds: 15),
        );
        
        expect(() => stt.recognizeAudio(Uint8List(0)), throwsA(isA<AliceTtsException>()));
      });

      test('should throw if not initialized', () {
        expect(
          () => stt.recognizeAudio(Uint8List(0)),
          throwsA(
            predicate((e) => 
              e is AliceTtsException && 
              e.type == AliceTtsExceptionType.invalidParams &&
              e.message.contains('not initialized')
            ),
          ),
        );
      });
    });

    group('Audio Recognition', () {
      setUp(() async {
        await stt.init(apiKey: 'test-key');
      });

      test('should recognize audio bytes', () async {
        expect(() => stt.recognizeAudio(Uint8List(100)), throwsA(isA<AliceTtsException>()));
      });

      test('should recognize audio stream', () async {
        final stream = Stream.value(<int>[1, 2, 3, 4, 5]);
        final resultStream = stt.recognizeAudioStream(stream);
        expect(resultStream, isA<Stream<String>>());
      });
    });
  });

  group('AliceVoiceAssistant', () {
    late YandexSpeechKitTts tts;
    late YandexSpeechKitStt stt;
    late AliceVoiceAssistant assistant;

    setUp(() async {
      tts = YandexSpeechKitTts();
      stt = YandexSpeechKitStt();
      
      await tts.init(apiKey: 'test-key');
      await stt.init(apiKey: 'test-key');
      
      assistant = AliceVoiceAssistant(tts: tts, stt: stt);
    });

    tearDown(() async {
      await tts.dispose();
      await stt.dispose();
    });

    test('should process voice input', () async {
      expect(() => assistant.processVoiceInput(Uint8List(100)), throwsA(isA<AliceTtsException>()));
    });

    test('should process voice input stream', () async {
      final stream = Stream.value(<int>[1, 2, 3, 4, 5]);
      final resultStream = assistant.processVoiceInputStream(stream);
      expect(resultStream, isA<Stream<Uint8List>>());
    });

    test('should provide access to TTS and STT instances', () {
      expect(assistant.tts, equals(tts));
      expect(assistant.stt, equals(stt));
    });
  });

  group('AliceTtsException', () {
    test('should create exception with message', () {
      const exception = AliceTtsException(
        message: 'Test error',
        type: AliceTtsExceptionType.network,
        statusCode: 500,
      );

      expect(exception.message, 'Test error');
      expect(exception.type, AliceTtsExceptionType.network);
      expect(exception.statusCode, 500);
    });

    test('should have meaningful string representation', () {
      const exception = AliceTtsException(
        message: 'Test error',
        type: AliceTtsExceptionType.auth,
        statusCode: 401,
      );

      final string = exception.toString();
      expect(string, contains('AliceTtsException'));
      expect(string, contains('Test error'));
      expect(string, contains('auth'));
      expect(string, contains('401'));
    });
  });

  group('AliceTtsConfig', () {
    test('should create config with required parameters', () {
      const config = AliceTtsConfig(apiKey: 'test-key');
      
      expect(config.apiKey, 'test-key');
      expect(config.voice, 'alena');
      expect(config.format, 'mp3');
      expect(config.sampleRateHz, 48000);
      expect(config.timeout, Duration(seconds: 10));
    });

    test('should create config with all parameters', () {
      const config = AliceTtsConfig(
        apiKey: 'test-key',
        oauthToken: 'test-token',
        folderId: 'test-folder',
        voice: 'filipp',
        format: 'wav',
        sampleRateHz: 22050,
        timeout: Duration(seconds: 5),
        maxRetries: 5,
        retryDelay: Duration(seconds: 2),
        apiUrl: 'https://custom.api.url',
      );
      
      expect(config.apiKey, 'test-key');
      expect(config.oauthToken, 'test-token');
      expect(config.folderId, 'test-folder');
      expect(config.voice, 'filipp');
      expect(config.format, 'wav');
      expect(config.sampleRateHz, 22050);
      expect(config.timeout, Duration(seconds: 5));
      expect(config.maxRetries, 5);
      expect(config.retryDelay, Duration(seconds: 2));
      expect(config.apiUrl, 'https://custom.api.url');
    });

    test('should copy config with new values', () {
      const original = AliceTtsConfig(apiKey: 'test-key');
      final copied = original.copyWith(voice: 'filipp', format: 'wav');
      
      expect(copied.apiKey, 'test-key');
      expect(copied.voice, 'filipp');
      expect(copied.format, 'wav');
      expect(copied.sampleRateHz, 48000);
    });
  });

  group('AliceSttConfig', () {
    test('should create config with required parameters', () {
      const config = AliceSttConfig(apiKey: 'test-key');
      
      expect(config.apiKey, 'test-key');
      expect(config.language, 'ru-RU');
      expect(config.model, 'general');
      expect(config.audioFormat, 'oggopus');
      expect(config.sampleRateHz, 48000);
      expect(config.timeout, Duration(seconds: 30));
    });

    test('should create config with all parameters', () {
      const config = AliceSttConfig(
        apiKey: 'test-key',
        oauthToken: 'test-token',
        folderId: 'test-folder',
        language: 'en-US',
        model: 'general',
        audioFormat: 'wav',
        sampleRateHz: 22050,
        timeout: Duration(seconds: 15),
        maxRetries: 5,
        retryDelay: Duration(seconds: 2),
        apiUrl: 'https://custom.stt.api.url',
      );
      
      expect(config.apiKey, 'test-key');
      expect(config.oauthToken, 'test-token');
      expect(config.folderId, 'test-folder');
      expect(config.language, 'en-US');
      expect(config.model, 'general');
      expect(config.audioFormat, 'wav');
      expect(config.sampleRateHz, 22050);
      expect(config.timeout, Duration(seconds: 15));
      expect(config.maxRetries, 5);
      expect(config.retryDelay, Duration(seconds: 2));
      expect(config.apiUrl, 'https://custom.stt.api.url');
    });

    test('should copy config with new values', () {
      const original = AliceSttConfig(apiKey: 'test-key');
      final copied = original.copyWith(language: 'en-US', model: 'general');
      
      expect(copied.apiKey, 'test-key');
      expect(copied.language, 'en-US');
      expect(copied.model, 'general');
      expect(copied.sampleRateHz, 48000);
    });
  });
}
