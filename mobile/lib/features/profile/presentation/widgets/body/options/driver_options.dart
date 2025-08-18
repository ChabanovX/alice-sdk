part of '../../../presentation.dart';

class DriverOptions extends StatelessWidget {
  const DriverOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedSliver(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
      ),
      sliver: SliverPadding(
        padding: const EdgeInsets.all(12),
        sliver: SliverList(
          delegate: SliverChildListDelegate([
            const ProfileOptionSlot(
              title: 'Диагностика и фотоконтроль',
              icon: AppIcons.cam,
            ),
            const ProfileOptionDivider(),
            const ProfileOptionSlot(
              title: 'Промокоды',
              icon: AppIcons.percentRoundedOutlined,
            ),
            const ProfileOptionDivider(),
            const ProfileOptionSlot(
              title: 'Моя мечта',
              icon: AppIcons.giftOutline,
            ),
            const ProfileOptionDivider(),
            const ProfileOptionSlot(
              title: 'Приведи друзей',
              icon: AppIcons.rubOutline,
            ),
          ]),
        ),
      ),
    );
  }
}
