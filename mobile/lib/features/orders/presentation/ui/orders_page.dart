part of 'ui.dart';

/// This page is still trash. Should be refactored later.
class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => OrdersBloc()),
      ],
      child: Scaffold(
        body: Stack(
          children: [
            BlocBuilder<OrdersBloc, OrdersState>(
              builder: (context, state) {
                final map = switch (state) {
                  // Offline() => const MapOffline(),
                  // OnlineIdle() => const MapOnline(),
                  _ => const YandexMap()
                  // OfferArrived() => const SheetOffer(),
                  // InRouteToPickup() => const SheetToPickup(),
                  // AtPickup() => const SheetAtPickup(),
                  // OrdersError() => const SheetError(),
                };
                
                return map;
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: BlocBuilder<OrdersBloc, OrdersState>(
                builder: (context, state) {
                  final bloc = context.read<OrdersBloc>();
                  final sheet = switch (state) {
                    _ => SheetAtPickup()
                    // Offline() => SheetOffline(bloc: bloc),
                    // OnlineIdle() => const SheetOnlineIdle(),
                    // OfferArrived() => const SheetOffer(),
                    // InRouteToPickup() => const SheetToPickup(),
                    // AtPickup() => const SheetAtPickup(),
                    // OrdersError() => const SheetError(),
                  };

                  return sheet;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
