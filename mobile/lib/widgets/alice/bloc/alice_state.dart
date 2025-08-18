import 'package:equatable/equatable.dart';

sealed class AliceState extends Equatable {
  const AliceState();

  @override
  List<Object?> get props => [];
}

/// Alice спит - пассивно слушает ключевое слово "Алиса"
final class AliceSleeping extends AliceState {
  const AliceSleeping();
}

/// Alice активна - записывает команду и обрабатывает её
final class AliceActive extends AliceState {
  const AliceActive();
}
