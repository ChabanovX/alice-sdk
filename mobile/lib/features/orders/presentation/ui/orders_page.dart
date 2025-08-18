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
          case AliceCommand.takeOrder:
            _handleTakeOrderCommand();
            break;
          case AliceCommand.declineOrder:
          case AliceCommand.none:
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
                InRouteToPickup() => const SheetToPickupV2(),
                AtPickup() => const SheetAtPickup(),
                OrdersError() => SheetOffline(),
                _ => SizedBox(),
              },
            ),
            body: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    const YandexMap(),
                    Positioned(
                      left: 14,
                      top: 46,
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

  void _handleTakeOrderCommand() {
    final ordersBloc = context.read<OrdersBloc>();
    final currentState = ordersBloc.state;

    if (currentState is OfferArrived) {
      ordersBloc.add(AcceptOfferPressed());
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Заказ принят по голосовой команде'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Нет активных предложений заказов'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
