import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/navigation/manager.dart';
import '../../domain/entities/order_offer.dart';

part 'orders_event.dart';

part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  OrdersBloc(super.initialState) {
    on<AppStarted>(_onAppStarted);
    on<GoOnlinePressed>(_onGoOnline);
    on<GoOfflinePressed>(_onGoOffline);
    on<OfferPushed>(_onOfferPushed);
    on<OfferExpired>(_onOfferExpired);
    on<AcceptOfferPressed>(_onAcceptOfferPressed);
    on<DeclineOfferPressed>(_onDeclineOfferPressed);
    on<ArrivedAtPickupPressed>(_onArrivedAtPickupPressed);
    add(AppStarted());
  }
  Future<void> _onAppStarted(
    AppStarted event,
    Emitter<OrdersState> emit,
  ) async {
    emit(const Offline());
  }

  /// Получить заказ
  Future<OrderOffer> getOrder() async {
    // Просто возвращаем заказ, не добавляем события
    return OrderOffer(
      roadDistance: '1,2 км',
      roadTime: '13 мин',
      deliveryType: DeliveryType.close,
      address: 'улица Покровка, 45с1',
      passengerRating: 4.92,
      options: ['Платная подача', 'Детское кресло, от 9 мес'],
      coefficient: 1.85,
    );
  }

  Future<void> _onGoOnline(
    GoOnlinePressed event,
    Emitter<OrdersState> emit,
  ) async {
    emit(const OnlineIdle());
    await Future.delayed(const Duration(seconds: 6));
    final order = await getOrder();
    emit(OfferArrived(orderOffer: order));
  }

  Future<void> _onGoOffline(
    GoOfflinePressed event,
    Emitter<OrdersState> emit,
  ) async {
    emit(const Offline());
    await NavigationManager.pop(navigator: NavigationManager.ordersNavigator);
  }

  Future<void> _onOfferPushed(
    OfferPushed event,
    Emitter<OrdersState> emit,
  ) async {
    emit(OfferArrived(orderOffer: event.offer));
  }

  Future<void> _onOfferExpired(
    OfferExpired event,
    Emitter<OrdersState> emit,
  ) async {}

  Future<void> _onAcceptOfferPressed(
    AcceptOfferPressed event,
    Emitter<OrdersState> emit,
  ) async {
    emit(InRouteToPickup());
    await Future.delayed(const Duration(seconds: 6));
    emit(AtPickup());
  }

  Future<void> _onDeclineOfferPressed(
    DeclineOfferPressed event,
    Emitter<OrdersState> emit,
  ) async {}

  Future<void> _onArrivedAtPickupPressed(
    ArrivedAtPickupPressed event,
    Emitter<OrdersState> emit,
  ) async {}

  void goNextState() {
    switch (state) {
      case Offline():
        add(GoOnlinePressed());
      case OnlineIdle():
        add(OfferPushed(OrderOffer(
          roadDistance: '1,2 км',
          roadTime: '13 мин',
          deliveryType: DeliveryType.close,
          address: 'улица Покровка, 45с1',
          passengerRating: 4.92,
          options: ['Платная подача', 'Детское кресло, от 9 мес'],
          coefficient: 1.85,
        )));
      case OfferArrived():
        add(ArrivedAtPickupPressed());
      case InRouteToPickup():
        add(GoOfflinePressed());
      case AtPickup():
        add(GoOfflinePressed());
      case OrdersError():
        add(GoOfflinePressed());
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
