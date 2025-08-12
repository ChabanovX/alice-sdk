part of '../presentation.dart';

class NotificationsSettings extends StatelessWidget {
  const NotificationsSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SettingsItem(
          title: 'Голос озвучки',
          optionalDescriptionBeforeChevron: 'Алиса',
          type: SettingType.button,
        ),
        SettingsItem(
          title: 'Озвучивать чат',
          type: SettingType.switcher,
        ),
        SettingsItem(
          title: 'Потеряна связь со спутником',
          type: SettingType.switcher,
        ),
        SettingsItem(
          title: 'Нет интернета',
          type: SettingType.switcher,
        ),
      ],
    );
  }
}
