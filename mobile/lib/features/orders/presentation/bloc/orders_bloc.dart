import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/order_offer.dart';
import '../../domain/repos/orders_repository.dart';

part 'orders_event.dart';
part 'orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  // TODO: inject via DI
  final OrdersRepository repo = OrdersRepository();

  OrdersBloc() : super(const Offline()) {
    on<AppStarted>(_onAppStarted);
    on<GoOnlinePressed>(_onGoOnline);
    on<GoOfflinePressed>(_onGoOffline);
    on<OfferPushed>(_onOfferPushed);
    on<OfferExpired>(_onOfferExpired);
    on<AcceptOfferPressed>(_onAcceptOfferPressed);
    on<DeclineOfferPressed>(_onDeclineOfferPressed);
    on<ArrivedAtPickupPressed>(_onArrivedAtPickupPressed);
  }

  Future<void> _onAppStarted(
    AppStarted event,
    Emitter<OrdersState> emit,
  ) async {}

  Future<void> _onGoOnline(
    GoOnlinePressed event,
    Emitter<OrdersState> emit,
  ) async {
    emit(const OnlineIdle());
  }

  Future<void> _onGoOffline(
    GoOfflinePressed event,
    Emitter<OrdersState> emit,
  ) async {}

  Future<void> _onOfferPushed(
    OfferPushed event,
    Emitter<OrdersState> emit,
  ) async {}

  Future<void> _onOfferExpired(
    OfferExpired event,
    Emitter<OrdersState> emit,
  ) async {}

  Future<void> _onAcceptOfferPressed(
    AcceptOfferPressed event,
    Emitter<OrdersState> emit,
  ) async {}

  Future<void> _onDeclineOfferPressed(
    DeclineOfferPressed event,
    Emitter<OrdersState> emit,
  ) async {}
  
  Future<void> _onArrivedAtPickupPressed(
    ArrivedAtPickupPressed event,
    Emitter<OrdersState> emit,
  ) async {}
}
