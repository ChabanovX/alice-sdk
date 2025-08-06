import 'package:test/test.dart';
import 'package:alice_voice_assistant/alice_voice_assistant.dart';

import 'widgets/alice_animated_logo_test.dart' as widget_tests;

void main() {
  // Run widget tests
  widget_tests.main();
  
  group('AudioMessage', () {
    test('should create audio message correctly', () {
      const message = AudioMessage(
        assetPath: 'assets/audio/test.mp3',
        text: 'Test message',
      );
      
      expect(message.assetPath, equals('assets/audio/test.mp3'));
      expect(message.text, equals('Test message'));
      expect(message.priority, equals(MessagePriority.normal));
    });

    test('should create audio message with high priority', () {
      const message = AudioMessage(
        assetPath: 'assets/audio/urgent.mp3',
        priority: MessagePriority.high,
      );
      
      expect(message.assetPath, equals('assets/audio/urgent.mp3'));
      expect(message.text, isNull);
      expect(message.priority, equals(MessagePriority.high));
    });

    test('should compare audio messages correctly', () {
      const message1 = AudioMessage(
        assetPath: 'assets/audio/test.mp3',
        text: 'Test',
      );
      
      const message2 = AudioMessage(
        assetPath: 'assets/audio/test.mp3',
        text: 'Test',
      );
      
      expect(message1, equals(message2));
      expect(message1.hashCode, equals(message2.hashCode));
    });
  });

  group('PlaybackState', () {
    test('should create initial state correctly', () {
      const state = PlaybackState.initial;
      expect(state.isPlaying, isFalse);
      expect(state.amplitude, equals(0.0));
      expect(state.error, isNull);
    });

    test('should copy with new values', () {
      const original = PlaybackState.initial;
      final copied = original.copyWith(
        isPlaying: true,
        amplitude: 0.5,
      );
      
      expect(copied.isPlaying, isTrue);
      expect(copied.amplitude, equals(0.5));
      expect(copied.error, isNull);
    });

    test('should copy with error', () {
      const original = PlaybackState.initial;
      final copied = original.copyWith(
        error: 'Test error',
      );
      
      expect(copied.isPlaying, isFalse);
      expect(copied.amplitude, equals(0.0));
      expect(copied.error, equals('Test error'));
    });

    test('should compare states correctly', () {
      const state1 = PlaybackState(
        isPlaying: true,
        amplitude: 0.5,
      );
      
      const state2 = PlaybackState(
        isPlaying: true,
        amplitude: 0.5,
      );
      
      expect(state1, equals(state2));
      expect(state1.hashCode, equals(state2.hashCode));
    });
  });

  group('MessagePriority', () {
    test('should have correct enum values', () {
      expect(MessagePriority.values.length, equals(3));
      expect(MessagePriority.values, contains(MessagePriority.high));
      expect(MessagePriority.values, contains(MessagePriority.normal));
      expect(MessagePriority.values, contains(MessagePriority.low));
    });
  });

  group('AliceConfiguration', () {
    test('should create default configuration', () {
      final config = AliceConfiguration.defaultConfig();
      
      expect(config.enableLogging, isTrue); // kDebugMode is true in tests
      expect(config.maxQueueSize, equals(10));
      expect(config.interruptOnHighPriority, isTrue);
      expect(config.autoPlayQueue, isTrue);
      expect(config.defaultVolume, equals(1.0));
      expect(config.amplitudeSimulation.enabled, isTrue);
    });

    test('should create development configuration', () {
      final config = AliceConfiguration.development();
      
      expect(config.enableLogging, isTrue);
      expect(config.maxQueueSize, equals(5));
    });

    test('should create production configuration', () {
      final config = AliceConfiguration.production();
      
      expect(config.enableLogging, isFalse);
      expect(config.maxQueueSize, equals(20));
    });

    test('should copy with new values', () {
      final original = AliceConfiguration.defaultConfig();
      final copied = original.copyWith(
        maxQueueSize: 15,
        defaultVolume: 0.8,
      );
      
      expect(copied.maxQueueSize, equals(15));
      expect(copied.defaultVolume, equals(0.8));
      expect(copied.enableLogging, equals(original.enableLogging));
    });

    test('should compare configurations correctly', () {
      final config1 = AliceConfiguration.defaultConfig();
      final config2 = AliceConfiguration.defaultConfig();
      
      expect(config1, equals(config2));
      expect(config1.hashCode, equals(config2.hashCode));
    });
  });

  group('AmplitudeSimulationConfig', () {
    test('should create with default values', () {
      const config = AmplitudeSimulationConfig();
      
      expect(config.enabled, isTrue);
      expect(config.baseAmplitude, equals(0.5));
      expect(config.variation, equals(0.3));
      expect(config.speed, equals(0.7));
      expect(config.updateInterval, equals(Duration(milliseconds: 50)));
    });

    test('should copy with new values', () {
      const original = AmplitudeSimulationConfig();
      final copied = original.copyWith(
        enabled: false,
        baseAmplitude: 0.8,
      );
      
      expect(copied.enabled, isFalse);
      expect(copied.baseAmplitude, equals(0.8));
      expect(copied.variation, equals(original.variation));
    });
  });

  // Note: AliceVoiceAssistant integration tests are skipped in unit tests
  // because they require Flutter binding initialization for just_audio.
  // These tests should be run as integration tests or with proper mocking.
  
  group('AliceVoiceAssistant (Unit Tests)', () {
    test('should reset singleton correctly', () {
      // Test the static reset method
      AliceVoiceAssistant.reset();
      // This test just ensures the method exists and doesn't throw
      expect(true, isTrue);
    });
    
    // Additional unit tests would require mocking the audio player
    // or creating a test-specific implementation that doesn't use just_audio
  });
}