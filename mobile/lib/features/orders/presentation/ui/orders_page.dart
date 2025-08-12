part of 'ui.dart';


class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => OrdersBloc()),
      ],
      child: Scaffold(
        bottomNavigationBar: _AppBottomNavBar(),
        body: Stack(
          children: [
            BlocBuilder<OrdersBloc, OrdersState>(
              builder: (context, state) {
                if (state is Offline) {
                  return const MapOffline();
                }
                if (state is OnlineIdle) {
                  return const MapOnline();
                }
                return const MapOffline();
              },
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: BlocBuilder<OrdersBloc, OrdersState>(
                builder: (context, state) {
                  final bloc = context.read<OrdersBloc>();
                  print(state);

                  final sheet = switch (state) {
                    Offline() => SheetOffline(bloc: bloc),
                    OnlineIdle() => const SheetOnlineIdle(),
                    OfferArrived() => const SheetOffer(),
                    InRouteToPickup() => const SheetToPickup(),
                    AtPickup() => const SheetAtPickup(),
                    OrdersError() => const SheetError(),
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

class _AppBottomNavBar extends StatelessWidget {
  const _AppBottomNavBar({super.key});

  static const _orders = 'assets/images/icon.png';
  static const _money = 'assets/images/icon2.png';
  static const _chat = 'assets/images/icon3.png';
  static const _profile = 'assets/images/icon4.png';

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: 0, // ← first item looks selected
      onTap: (_) {}, // no real navigation
      backgroundColor: context.colors.semanticBackground,
      showUnselectedLabels: true,
      selectedLabelStyle: context.textStyles.caption,
      selectedItemColor: context.colors.text,
      unselectedItemColor: Theme.of(
        context,
      ).colorScheme.onSurface.withValues(alpha: .5),
      items: [
        _item(label: 'Заказы', asset: _orders),
        _item(label: 'Деньги', asset: _money),
        _item(label: 'Общение', asset: _chat),
        _item(label: 'Профиль', asset: _profile),
      ],
    );
  }

  BottomNavigationBarItem _item({
    required String label,
    required String asset,
  }) {
    return BottomNavigationBarItem(
      label: label,
      // Unselected
      icon: Opacity(
        opacity: 0.5,
        child: Image.asset(asset, width: 24, height: 24),
      ),
      // Selected
      activeIcon: Image.asset(asset, width: 24, height: 24),
    );
  }
}
