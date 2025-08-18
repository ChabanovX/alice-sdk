import 'package:equatable/equatable.dart';

sealed class AliceEvent extends Equatable {
  const AliceEvent();

  @override
  List<Object?> get props => [];
}

/// Ключевое слово "Алиса" распознано - начинаем запись команды
final class AliceStartListening extends AliceEvent {
  const AliceStartListening();
}

/// Останавливаем запись - по таймауту (15 сек) или получен ответ от сервера
final class AliceStopListening extends AliceEvent {
  const AliceStopListening();
}
