import 'dart:async';

import 'package:just_audio/just_audio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/alice_command_recognize_service.dart';
import 'alice_event.dart';
import 'alice_state.dart';

class AliceBloc extends Bloc<AliceEvent, AliceState> {
  AliceBloc() : super(const AliceSleeping()) {
    on<AliceStartListening>(_onStartListening);
    on<AliceStopListening>(_onStopListening);

    _initializeService();
  }

  final AliceCommandRecognizeService _recognizeService =
      AliceCommandRecognizeService();
  AudioPlayer? _soundPlayer;
  StreamSubscription? _keywordSubscription;
  StreamSubscription? _responseSubscription;

  Stream<AliceCommand> get commandStream => _recognizeService.testStream
      .map(AliceCommand.fromString);

  Future<void> _initializeService() async {
    try {
      // Инициализируем аудио плеер для звуков
      _soundPlayer = AudioPlayer();

      // Инициализируем сервис распознавания
      await _recognizeService.init();

      // Подписываемся на обнаружение ключевого слова "Алиса"
      _keywordSubscription = _recognizeService.keywordStream.listen((_) {
        add(const AliceStartListening());
      });

      // Подписываемся на ответы от сервера и таймауты
      _responseSubscription = _recognizeService.testStream.listen((response) {
        add(const AliceStopListening());
      });

      // Подписываемся на таймауты записи (15 секунд)
      _recognizeService.stopRecordingStream.listen((_) {
        add(const AliceStopListening());
      });

      // Запускаем пассивное прослушивание ключевого слова
      _recognizeService.startListening();
    } catch (e) {
      // Игнорируем ошибки инициализации
    }
  }

  Future<void> _onStartListening(
    AliceStartListening event,
    Emitter<AliceState> emit,
  ) async {
    try {
      emit(const AliceActive());
      await _playActivationSound();
    } catch (e) {
      // Игнорируем ошибки звука
    }
  }

  Future<void> _onStopListening(
    AliceStopListening event,
    Emitter<AliceState> emit,
  ) async {
    try {
      emit(const AliceSleeping());
      await _playDeactivationSound();
    } catch (e) {
      // Игнорируем ошибки звука
    }
  }

  Future<void> _playActivationSound() async {
    try {
      await _soundPlayer?.setAsset('assets/audio/alice_on.mp3');
      await _soundPlayer?.play();
    } catch (e) {
      // Игнорируем ошибки звука
    }
  }

  Future<void> _playDeactivationSound() async {
    try {
      await _soundPlayer?.setAsset('assets/audio/alice_off.mp3');
      await _soundPlayer?.play();
    } catch (e) {
      // Игнорируем ошибки звука
    }
  }

  @override
  Future<void> close() {
    _keywordSubscription?.cancel();
    _responseSubscription?.cancel();
    _recognizeService.dispose();
    _soundPlayer?.dispose();
    return super.close();
  }
}
