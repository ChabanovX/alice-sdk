import 'dart:async';

import 'package:just_audio/just_audio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/alice_command_recognize_service.dart';
import '../../../core/services/alice_speaker_service.dart';
import '../../../di.dart';
import 'alice_event.dart';
import 'alice_state.dart';

class AliceBloc extends Bloc<AliceEvent, AliceState> {
  AliceBloc() : super(const AliceSleeping()) {
    on<AliceStartListening>(_onStartListening);
    on<AliceStopListening>(_onStopListening);

    _initializeService();
  }

  final AliceSpeakingService _speaker = getIt<AliceSpeakingService>();
  final AliceCommandRecognizeService _recognizeService =
      AliceCommandRecognizeService();
  StreamSubscription? _keywordSubscription;
  StreamSubscription? _responseSubscription;

  Stream<AliceCommand> get commandStream =>
      _recognizeService.testStream.map(AliceCommand.fromString);

  Future<void> _initializeService() async {
    try {
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

      // await Future.delayed(Duration(seconds: 10));
      // _recognizeService.mockCommand();
    } catch (e) {
      // Игнорируем ошибки инициализации
    }
  }

  Future<void> _onStartListening(
    AliceStartListening event,
    Emitter<AliceState> emit,
  ) async {
    try {
      await _speaker.playActivationSound();
      emit(const AliceActive());
    } catch (e) {
      // Игнорируем ошибки звука
    }
  }

  Future<void> _onStopListening(
    AliceStopListening event,
    Emitter<AliceState> emit,
  ) async {
    try {
      // await _speaker.playDeactivationSound();
      emit(const AliceSleeping());
    } catch (e) {
      // Игнорируем ошибки звука
    }
  }

  @override
  Future<void> close() {
    _keywordSubscription?.cancel();
    _responseSubscription?.cancel();
    _recognizeService.dispose();
    return super.close();
  }
}
