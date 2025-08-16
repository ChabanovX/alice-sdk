part of '../../presentation.dart';

class SettingsAdditional extends StatelessWidget {
  const SettingsAdditional({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SettingsItem(
          title: 'Политика конфиденциальности',
          type: SettingType.button,
        ),
        SettingsItem(
          title: 'Лицензионное соглашение',
          type: SettingType.button,
        ),
        SettingsItem(
          title: 'Правовые документы',
          type: SettingType.button,
        ),
        SettingsItem(
          title: 'Доступы для приложения',
          type: SettingType.button,
        ),
        SettingsItem(
          title: 'Удалить все профили',
          type: SettingType.button,
        ),
      ],
    );
  }
}
