part of '../../presentation.dart';

class SettingsNavigation extends StatelessWidget {
  const SettingsNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SettingsItem(
          title: 'Тип навигации',
          description: 'Внутренняя  ',
          icon: AppIcons.externalNavigatorOutline,
          type: SettingType.button,
        ),
        SettingsItem(
          title: 'Карта',
          icon: AppIcons.mapOutline,
          type: SettingType.button,
        ),
        SettingsItem(
          title: 'Настройка курсора',
          icon: AppIcons.brush,
          type: SettingType.button,
        ),
        SettingsItem(
          title: 'Сохраненные маршруты',
          icon: AppIcons.poiPinOutline,
          type: SettingType.button,
        ),
        SettingsItem(
          title: 'Подключение к ELM',
          icon: AppIcons.bluetooth,
          type: SettingType.button,
        ),
        SettingsItem(
          title: 'Открывать Яндекс Навигатор на заказе',
          icon: AppIcons.locationOutline,
          type: SettingType.switcher,
        ),
        SettingsItem(
          title: 'Выделенные полосы',
          description: 'Учитывать при построении маршрута',
          icon: AppIcons.route,
          type: SettingType.switcher,
        ),
        SettingsItem(
          title: 'Правила проезда по выделенным полосам',
          icon: AppIcons.bookOutline,
          type: SettingType.button,
        ),
      ],
    );
  }
}
