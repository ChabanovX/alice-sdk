import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:record/record.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class AliceCommandRecognizeService {
  WebSocketChannel? _socket;
  final SpeechToText _speechToText = SpeechToText();
  final AudioRecorder _recorder = AudioRecorder();
  final StreamController<String> _testController =
      StreamController<String>.broadcast();

  Stream<String> get testStream => _testController.stream;

  final List<String> _keyWords = [
    'алиса',
    'алис',
    'алисе',
    'алисы',
    'алису',
    'алисо',
  ];

  bool _isListening = false;
  bool _isRecording = false;
  Timer? _listeningTimer;
  StreamSubscription<Uint8List>? _recordingSubscription;

  Future<void> init() async {
    await _speechToText.initialize(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          if (_isListening && !_isRecording) {
            _startSpeechRecognition();
          }
        }
      },
    );
  }

  /// Установить соединение с вебсокетом
  void _openConnection() {
    //_socket = WebSocketChannel.connect(Uri.parse('ws://localhost:8080'));
  }

  /// Закрыть соединение с вебсокетом
  void _closeConnection() {
    // _socket?.sink.close();
    // _socket = null;
  }

  /// Начать слушать команды
  void startListening() {
    if (_isListening) return;
    _startSpeechRecognition();
  }

  /// Распознавание ключевых слов
  void _startSpeechRecognition() {
    _isListening = true;

    _speechToText.listen(
      onResult: _resultListener,
      localeId: 'ru-RU',
      listenFor: const Duration(seconds: 30),
    );
  }

  /// Сюда приходят результаты распознавания
  void _resultListener(SpeechRecognitionResult result) {
    final words = result.recognizedWords.toLowerCase();

    if (_keyWords.any(words.contains)) {
      _openConnection();
      _startRecording();
    }
  }

  /// Если распознали ключевое слово, то начинаем запись
  Future<void> _startRecording() async {
    if (_isRecording) return;

    try {
      _isRecording = true;
      await _speechToText.stop();

      const config = RecordConfig(
        encoder: AudioEncoder.pcm16bits,
        sampleRate: 8000,
        numChannels: 1,
      );

      final stream = await _recorder.startStream(config);

      _recordingSubscription = stream.listen(
        _sendAudioChunk,
        onError: (error) {
          _stopRecording();
        },
        cancelOnError: false,
      );

      // TODO: в будущем отменять запись при получении ответа от сервера
      // а не через 15 секунд
      Timer(const Duration(seconds: 15), _stopRecording);
    } catch (e) {
      _isRecording = false;
      _resumeListening();
    }
  }

  /// Отправляем кусок аудио на сервер
  void _sendAudioChunk(Uint8List chunk) {
    _socket?.sink.add(jsonEncode(chunk));
    _testController.add(jsonEncode(chunk));
  }

  /// Останавливаем запись
  Future<void> _stopRecording() async {
    if (!_isRecording) return;

    try {
      await _recordingSubscription?.cancel();

      if (await _recorder.isRecording()) {
        await _recorder.stop();
      }
      _isRecording = false;
      _closeConnection();
      _resumeListening();
    } catch (e) {
      _isRecording = false;
      _resumeListening();
    }
  }

  /// Продолжаем слушать команды
  void _resumeListening() {
    if (!_isListening) return;
    _startSpeechRecognition();
  }

  /// Останавливаем прослушивание команд
  void stopListening() {
    _isListening = false;
    _listeningTimer?.cancel();
    _speechToText.stop();

    if (_isRecording) {
      _stopRecording();
    }
  }

  void dispose() {
    stopListening();
    _socket?.sink.close();
    _recordingSubscription?.cancel();
    _recorder.dispose();
    _testController.close();
  }
}
