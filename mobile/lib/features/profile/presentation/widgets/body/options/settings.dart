part of '../../../presentation.dart';

class AppSettings extends StatelessWidget {
  const AppSettings({super.key});

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
            const ProfileOptionSlot(title: 'Обучение', icon: AppIcons.hello),
            const ProfileOptionDivider(),
            ProfileOptionSlot(
              title: 'Настройки',
              icon: AppIcons.settings2Outline,
              onTap: () {
                Navigator.pushNamed(
                  context,
                  Routes.settings,
                );
              },
            ),
            const ProfileOptionDivider(),
            const ProfileOptionSlot(
              title: 'Выход из приложения',
              icon: AppIcons.logout,
            ),
          ]),
        ),
      ),
    );
  }
}
