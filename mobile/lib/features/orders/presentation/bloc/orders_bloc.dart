import 'package:bloc/bloc.dart';
import 'package:voice_assistant/features/orders/domain/repos/orders_repository.dart';
import 'package:voice_assistant/features/orders/presentation/bloc/orders_event.dart';
import 'package:voice_assistant/features/orders/presentation/bloc/orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final OrdersRepository repo;

  OrdersBloc(this.repo) : super(const Offline()) {
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
