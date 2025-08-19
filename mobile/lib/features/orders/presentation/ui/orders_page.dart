part of 'ui.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  StreamSubscription<AliceCommand>? _commandSubscription;

  @override
  void initState() {
    super.initState();
    _subscribeToCommands();
  }

  @override
  void dispose() {
    _commandSubscription?.cancel();
    super.dispose();
  }

  void _subscribeToCommands() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final aliceBloc = context.read<AliceBloc>();
      _commandSubscription = aliceBloc.commandStream.listen((command) {
        switch (command) {
          case AliceCommand.accept:
            _handleTakeOrderCommand();
            break;
          case AliceCommand.decline:
            _handleOtherCommand();
          case AliceCommand.other:
            _handleOtherCommand();
            break;
          case AliceCommand.none:
            _handleOtherCommand();
            break;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<OrdersBloc>();
    return BlocListener<OrdersBloc, OrdersState>(
      listener: (context, state) {
        if (state is OfferArrived) {
          NavigationManager.showBottomSheet<bool>(
            BlocProvider.value(
              value: bloc,
              child: SheetOffer(state: state),
            ),
          ).then((result) {
            BottomSheetManager().resetModalBottomSheetHeight();
          });
        }
      },
      child: BlocBuilder<OrdersBloc, OrdersState>(
        builder: (context, state) {
          return Scaffold(
            bottomSheet: MeasuredScaffoldBottomSheet(
              child: switch (state) {
                Offline() => const SheetOfflineV2(),
                OnlineIdle() => const SheetOfflineV2(),
                OfferArrived() => const SheetOfflineV2(),
                InRouteToPickup() => const SheetToPickup(),
                AtPickup() => const SheetAtArriving(),
                OrdersError() => SheetOffline(),
                _ => SizedBox(),
              },
            ),
            body: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    const MapOffline(),
                    Positioned(
                      left: 14,
                      top: 46 + 16,
                      child: state is Offline
                          ? const ControlOfflineWidget()
                          : GestureDetector(
                              onTap: () {
                                NavigationManager.showBottomSheet(
                                  SheetLeaveLineV2(
                                    onTap: () {
                                      bloc.add(GoOfflinePressed());
                                    },
                                  ),
                                  navigator: BottomSheetNavigator.orders,
                                  displayMode:
                                      BottomSheetDisplayMode.aboveNavigationBar,
                                );
                              },
                              child: const ControlOnlineWidget(
                                employment: 52,
                              ),
                            ),
                    ),
                    if (state is Offline)
                      ValueListenableBuilder<double>(
                        valueListenable:
                            BottomSheetManager().scaffoldBottomSheetHeight,
                        builder: (context, scaffoldHeight, child) {
                          return Positioned(
                            left: 16,
                            right: 16,
                            bottom: scaffoldHeight + 16,
                            child: DefaultSmallButton(
                              text: 'На линию',
                              onPressed: bloc.goNextState,
                            ),
                          );
                        },
                      ),
                    const AliceFloatingWidget(),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  void _handleOtherCommand() {
    final speaker = getIt<AliceSpeakingService>();

    speaker.sayText('Не поняла вас.');
  }

  void _handleTakeOrderCommand() {
    final ordersBloc = context.read<OrdersBloc>();
    final currentState = ordersBloc.state;

    final speaker = getIt<AliceSpeakingService>();

    if (currentState is OfferArrived) {
      speaker.sayText('Приняла.');
      ordersBloc.add(AcceptOfferPressed());
      NavigationManager.pop();

    } else {
      speaker.sayText('У вас нет доступных заказов');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Нет активных предложений заказов'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
