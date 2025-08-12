part of '../../presentation.dart';

class SettingsSounds extends StatelessWidget {
  const SettingsSounds({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SettingsItem(
          title: 'Звук навигации и приложения',
          icon: AppIcons.sound1Outline,
          type: SettingType.button,
          onTap: () {
            Navigator.pushNamed(
              context,
              Routes.detailedVoiceSettings,
            );
          },
        ),
        const SettingsItem(
          title: 'Отключать звуки Яндекс Навигатора на заказе',
          icon: AppIcons.soundOffOutline,
          type: SettingType.switcher,
        ),
        const SettingsItem(
          title: 'Вибрация',
          description: 'При получении уведомлений',
          icon: AppIcons.signal,
          type: SettingType.switcher,
        ),
        const SettingsItem(
          title: 'Беззвучный режим на заказе',
          icon: AppIcons.soundOffOutline,
          type: SettingType.switcher,
        ),
        const SettingsItem(
          title: 'Беззвучный режим',
          icon: AppIcons.soundOffOutline,
          type: SettingType.button,
        ),
      ],
    );
  }
}
