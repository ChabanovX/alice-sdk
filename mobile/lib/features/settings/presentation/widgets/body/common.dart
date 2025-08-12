part of '../../presentation.dart';

class SettingsCommon extends StatelessWidget {
  const SettingsCommon({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SettingsItem(
          title: 'Тема приложения',
          description: 'Автоматически',
          icon: AppIcons.sunOutline,
          type: SettingType.button,
        ),
        SettingsItem(
          title: 'Язык',
          description: 'Русский',
          icon: AppIcons.planetOutline,
          type: SettingType.button,
        ),
        SettingsItem(
          title: 'Размер текста',
          description: 'Как в системе',
          icon: AppIcons.automaticTransmissionOutline,
          type: SettingType.button,
        ),
      ],
    );
  }
}
