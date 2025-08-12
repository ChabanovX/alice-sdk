import 'package:equatable/equatable.dart';

sealed class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object?> get props => [];
}

class Offline extends OrdersState {
  const Offline();
}

class OnlineIdle extends OrdersState {
  const OnlineIdle();
}

class OfferArrived extends OrdersState {}

class InRouteToPickup extends OrdersState {}

class AtPickup extends OrdersState {}

class OrdersError extends OrdersState {
  final String message;
  const OrdersError(this.message);

  @override
  List<Object?> get props => [message];
}
