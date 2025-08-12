part of '../presentation.dart';

class AliceSettings extends StatelessWidget {
  const AliceSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SettingsItem(
          title: 'Умный асистент',
          type: SettingType.switcher,
        ),
         SettingsItem(
          title: 'Голосовая активация',
          type: SettingType.switcher,
        ),
         SettingsItem(
          title: 'Озвучка деталей заказа',
          type: SettingType.switcher,
        ),
         SettingsItem(
          title: 'Ограничения по времени остановки',
          type: SettingType.switcher,
        ),
      ],
    );
  }
}
