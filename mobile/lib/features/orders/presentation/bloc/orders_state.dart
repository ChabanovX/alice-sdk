part of 'orders_bloc.dart';

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

class OfferArrived extends OrdersState {
  const OfferArrived({required this.orderOffer});
  final OrderOffer orderOffer;
}

class InRouteToPickup extends OrdersState {}

class InRedZone extends OrdersState {}

class AtPickup extends OrdersState {}

class OrdersError extends OrdersState {
  final String message;
  const OrdersError(this.message);

  @override
  List<Object?> get props => [message];
}

class GoOnBusiness extends OrdersState {
  const GoOnBusiness({required this.isToHome});
  final bool isToHome;
}

class GoByWay extends OrdersState {
  const GoByWay();
}


class GoWithOrdersOnWay extends OrdersState {
  const GoWithOrdersOnWay();
}
