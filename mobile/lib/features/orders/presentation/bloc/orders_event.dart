part of 'orders_bloc.dart';

sealed class OrdersEvent {}

class AppStarted extends OrdersEvent {}

class GoOnlinePressed extends OrdersEvent {}

class GoOfflinePressed extends OrdersEvent {}

class OfferPushed extends OrdersEvent {
  final OrderOffer offer;
  OfferPushed(this.offer);
}

class OfferExpired extends OrdersEvent {}

class AcceptOfferPressed extends OrdersEvent {}

class DeclineOfferPressed extends OrdersEvent {}

class ArrivedAtPickupPressed extends OrdersEvent {}
