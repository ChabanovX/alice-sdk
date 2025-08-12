part of '../../presentation.dart';

class SettingsOther extends StatelessWidget {
  const SettingsOther({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SettingsItem(
          title: 'Специальные возможности',
          description: 'Слабослышащие водители, мерцание и тд',
          icon: AppIcons.accessibilityOutline,
          type: SettingType.button,
        ),
        SettingsItem(
          title: 'Скрыть доход',
          description: 'При навигации',
          icon: AppIcons.eyeOffOutline,
          type: SettingType.switcher,
        ),
        SettingsItem(
          title: 'Скрыть доход',
          description: 'На главном экране',
          icon: AppIcons.eyeOffOutline,
          type: SettingType.switcher,
        ),
        SettingsItem(
          title: 'Виджет во время заказа',
          description: 'Показывать',
          icon: AppIcons.mobileOutline,
          type: SettingType.switcher,
        ),
        SettingsItem(
          title: 'Автопереключение статуса "На месте"',
          icon: AppIcons.humanSurgeIndicatorPhone,
          type: SettingType.switcher,
        ),
        SettingsItem(
          title: 'Автопереключение статуса "В пути"',
          icon: AppIcons.humanSeat,
          type: SettingType.switcher,
        ),
        SettingsItem(
          title: 'Автоотметка попутной точки',
          icon: AppIcons.crossL,
          type: SettingType.switcher,
        ),
        SettingsItem(
          title: 'Мусульманский режим',
          icon: AppIcons.timeMOutline,
          type: SettingType.switcher,
        ),
        SettingsItem(
          title: 'Беззвучный режим на молитве',
          description: 'На время намаза',
          icon: AppIcons.soundOffOutline,
          type: SettingType.switcher,
        ),
        SettingsItem(
          title: 'Напоминание о молитве',
          description: 'Предложим выйти с линии за 200 мин',
          icon: AppIcons.bellAlertOutline,
          type: SettingType.switcher,
        ),
        SettingsItem(
          title: 'Рассчет расписания намаза',
          description: 'Предложим выйти с линии за 200 мин',
          icon: AppIcons.list,
          type: SettingType.switcher,
        ),
      ],
    );
  }
}
