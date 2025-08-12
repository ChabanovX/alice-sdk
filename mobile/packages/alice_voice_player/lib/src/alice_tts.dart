import 'dart:typed_data';

import 'package:alice_voice_player/src/models/stt_config.dart';
import 'package:alice_voice_player/src/models/tts_config.dart';
import 'package:alice_voice_player/src/models/tts_exception.dart';

/// Abstract interface for text-to-speech synthesis
abstract class AliceTts {
  /// Initializes the TTS service with configuration
  Future<void> init({
    required String apiKey,
    String? oauthToken,
    String? folderId,
    String voice = 'alena',
    String format = 'mp3',
    int sampleRateHz = 48000,
    Duration timeout = const Duration(seconds: 10),
  });

  /// Synthesizes text to audio bytes
  Future<Uint8List> synthesizeBytes(String text);

  /// Synthesizes text to audio stream
  Stream<List<int>> synthesizeStream(String text);

  /// Processes text input and returns synthesized audio
  Future<Uint8List> onTextInput(String text);

  /// Processes voice input (recognized text) and returns synthesized audio
  Future<Uint8List> onVoiceInput(String recognizedText);

  /// Disposes resources
  Future<void> dispose();
}

/// Abstract interface for speech-to-text recognition
abstract class AliceStt {
  /// Initializes the STT service with configuration
  Future<void> init({
    required String apiKey,
    String? oauthToken,
    String? folderId,
    String language = 'ru-RU',
    String model = 'general',
    String audioFormat = 'oggopus',
    int sampleRateHz = 48000,
    Duration timeout = const Duration(seconds: 30),
  });

  /// Recognizes speech from audio bytes
  Future<String> recognizeAudio(Uint8List audioBytes);

  /// Recognizes speech from audio stream
  Stream<String> recognizeAudioStream(Stream<List<int>> audioStream);

  /// Disposes resources
  Future<void> dispose();
}

/// Helper service that provides echo functionality
/// Takes input text and returns synthesized audio of the same text
class AliceEchoService {
  /// Creates a new echo service with TTS implementation
  AliceEchoService(this._tts);

  final AliceTts _tts;

  /// Processes text and returns synthesized audio
  Future<Uint8List> echo(String text) => _tts.onTextInput(text);

  /// Processes text as stream
  Stream<List<int>> echoStream(String text) async* {
    yield* _tts.synthesizeStream(text);
  }
}

/// Combined service for voice assistant functionality
/// Provides both TTS and STT capabilities
class AliceVoiceAssistant {
  /// Creates a new voice assistant with TTS and STT implementations
  AliceVoiceAssistant({
    required AliceTts tts,
    required AliceStt stt,
  })  : _tts = tts,
        _stt = stt;

  final AliceTts _tts;
  final AliceStt _stt;

  /// Processes voice input: records audio, recognizes speech, synthesizes response
  Future<Uint8List> processVoiceInput(Uint8List audioBytes) async {
    // Step 1: Recognize speech from audio
    final recognizedText = await _stt.recognizeAudio(audioBytes);
    
    // Step 2: Synthesize response (echo for now)
    return _tts.onTextInput(recognizedText);
  }

  /// Processes voice input with streaming
  Stream<Uint8List> processVoiceInputStream(Stream<List<int>> audioStream) async* {
    // Step 1: Recognize speech from audio stream
    final recognizedTextStream = _stt.recognizeAudioStream(audioStream);
    
    await for (final recognizedText in recognizedTextStream) {
      // Step 2: Synthesize response for each recognized text
      final audioBytes = await _tts.onTextInput(recognizedText);
      yield audioBytes;
    }
  }

  /// Gets TTS instance
  AliceTts get tts => _tts;

  /// Gets STT instance
  AliceStt get stt => _stt;
}
