import 'dart:typed_data';

import 'package:alice_voice_player/src/models/stt_config.dart';
import 'package:alice_voice_player/src/models/tts_config.dart';
import 'package:alice_voice_player/src/models/tts_exception.dart';

abstract class AliceTts {
  Future<void> init({
    required String apiKey,
    String? oauthToken,
    String? folderId,
    String voice = 'alena',
    String format = 'mp3',
    int sampleRateHz = 48000,
    Duration timeout = const Duration(seconds: 10),
  });

  Future<Uint8List> synthesizeBytes(String text);

  Stream<List<int>> synthesizeStream(String text);

  Future<Uint8List> onTextInput(String text);

  Future<Uint8List> onVoiceInput(String recognizedText);

  Future<void> dispose();
}

abstract class AliceStt {
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

  Future<String> recognizeAudio(Uint8List audioBytes);

  Stream<String> recognizeAudioStream(Stream<List<int>> audioStream);

  Future<void> dispose();
}

class AliceEchoService {
  AliceEchoService(this._tts);

  final AliceTts _tts;

  Future<Uint8List> echo(String text) => _tts.onTextInput(text);

  Stream<List<int>> echoStream(String text) async* {
    yield* _tts.synthesizeStream(text);
  }
}

class AliceVoiceAssistant {
  AliceVoiceAssistant({
    required AliceTts tts,
    required AliceStt stt,
  })  : _tts = tts,
        _stt = stt;

  final AliceTts _tts;
  final AliceStt _stt;

  Future<Uint8List> processVoiceInput(Uint8List audioBytes) async {
    final recognizedText = await _stt.recognizeAudio(audioBytes);
    
    return _tts.onTextInput(recognizedText);
  }

  Stream<Uint8List> processVoiceInputStream(Stream<List<int>> audioStream) async* {
    final recognizedTextStream = _stt.recognizeAudioStream(audioStream);
    
    await for (final recognizedText in recognizedTextStream) {
      final audioBytes = await _tts.onTextInput(recognizedText);
      yield audioBytes;
    }
  }

  AliceTts get tts => _tts;

  AliceStt get stt => _stt;
}
