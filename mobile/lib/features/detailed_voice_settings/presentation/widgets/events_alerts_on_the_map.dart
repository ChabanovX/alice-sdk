part of '../presentation.dart';

class EventsAlertsOnTheMap extends StatelessWidget {
  const EventsAlertsOnTheMap({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SettingsItem(
          title: 'Озвучивание событий',
          description: 'Можно убрать озвучку некоторых событий',
          type: SettingType.switcher,
        ),
        SettingsItem(
          title: 'Маневры по маршруту',
          type: SettingType.switcher,
        ),
        SettingsItem(
          title: 'Дорожные работы',
          type: SettingType.switcher,
        ),
        SettingsItem(
          title: 'Аварийно-опасные участки',
          type: SettingType.switcher,
        ),
        SettingsItem(
          title: 'Камеры контроля скорости',
          type: SettingType.switcher,
        ),
        SettingsItem(
          title: 'Камеры на полосу',
          type: SettingType.switcher,
        ),
        SettingsItem(
          title: 'Камеры на разметку',
          type: SettingType.switcher,
        ),
        SettingsItem(
          title: 'Камеры контроля перекрестка',
          type: SettingType.switcher,
        ),
        SettingsItem(
          title: 'ДТП',
          type: SettingType.switcher,
        ),
        SettingsItem(
          title: 'Ограничение по времени остановки',
          type: SettingType.switcher,
        ),
      ],
    );
  }
}
