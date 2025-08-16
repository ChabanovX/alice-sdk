part of '../presentation.dart';

class ProfileBody extends StatelessWidget {
  const ProfileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedSliver(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(32),
        ),
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          const ProfileTopElements(),
          const ProfileMetrics(),
          const TitledSlot(title: 'Заказы'),
          const OrderSettings(),
          const TitledSlot(title: 'Нужно для работы'),
          const CarCard(
            number: 'x802cc777',
            carModel: 'Toyota Camry',
            description: 'Еще 4 транспортных средства',
          ),
        ]),
      ),
    );
  }
}
