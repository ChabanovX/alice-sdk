import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:record/record.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

enum AliceCommand {
  accept('accept'),
  decline('decline'),
  none('');

  const AliceCommand(this.value);
  final String value;

  static AliceCommand fromString(String command) {
    for (final cmd in AliceCommand.values) {
      if (cmd.value == command) {
        return cmd;
      }
    }
    return AliceCommand.none;
  }
}

class AliceCommandRecognizeService {
  final SpeechToText _speechToText = SpeechToText();
  final AudioRecorder _recorder = AudioRecorder();
  final StreamController<String> _testController =
      StreamController<String>.broadcast();
  final StreamController<void> _keywordController =
      StreamController<void>.broadcast();
  final StreamController<void> _stopRecordingController =
      StreamController<void>.broadcast();

  Stream<String> get testStream => _testController.stream;
  Stream<void> get keywordStream => _keywordController.stream;
  Stream<void> get stopRecordingStream => _stopRecordingController.stream;
  final _dio = Dio();
  WebSocket? _socket;

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

  bool get isListening => _isListening;
  bool get isRecording => _isRecording;
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
      onError: (error) {
        _startSpeechRecognition();
      },
    );
  }

  /// Установить соединение с вебсокетом
  Future<void> _openConnection() async {
    try {
      _socket = await WebSocket.connect(
        'ws://ws.158.160.191.199.nip.io:30080/ws',
        headers: {'Authorization': 'Basic dGVhbTQyOnNlY3JldHBhc3M='},
      );

      _socket!.listen(
        (message) {
          _testController
              .add(message.toString());
          _stopRecording();
          final Map<String, dynamic> text = jsonDecode(message.toString());
          _dio
              .post(
            'http://158.160.191.199:30080/classify-message',
            data: {'text': text['raw_text']},
            options: Options(
              headers: {
                'Authorization': 'Basic dGVhbTQyOnNlY3JldHBhc3M=',
                'Content-Type': 'application/json',
              },
            ),
          )
              .then((value) {
            _closeConnection();
            final Map<String, dynamic> result = jsonDecode(value.toString());
            _testController.add(result['intention']);
          });
        },
        onError: (error) {
          _stopRecording();
        },
        onDone: () {},
        cancelOnError: false,
      );
    } catch (e) {
      await _stopRecording();
    }
  }

  /// Закрыть соединение с вебсокетом
  void _closeConnection() {
    _socket?.close();
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
      _keywordController.add(null); // Уведомляем о обнаружении ключевого слова
      _openConnection().then((_) => _startRecording());
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

      Timer(const Duration(seconds: 15), () {
        _stopRecordingController.add(null); // Уведомляем о таймауте
        _stopRecording();
      });
    } catch (e) {
      _isRecording = false;
      _resumeListening();
    }
  }

  /// Отправляем кусок аудио на сервер
  void _sendAudioChunk(Uint8List chunk) {
    _socket?.add(chunk); // Отправляем бинарные данные напрямую
  }

  /// Останавливаем запись
  Future<void> _stopRecording() async {
    if (!_isRecording) return;

    try {
      await _recordingSubscription?.cancel();

      if (await _recorder.isRecording()) {
        await _recorder.stop();
      }

      // Отправляем сигнал окончания потока, как в test_socket.dart
      _socket?.add('EOS');

      _isRecording = false;
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
    _socket?.close();
    _recordingSubscription?.cancel();
    _recorder.dispose();
    _testController.close();
    _keywordController.close();
    _stopRecordingController.close();
  }
}
