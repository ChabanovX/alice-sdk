part of '../presentation.dart';

class CommonSettings extends StatelessWidget {
  const CommonSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        SettingsItem(
          title: 'Общее',
          type: SettingType.switcher,
        ),
        SettingsItem(
          title: 'Максимальная громкость',
          description: 'Настройки звука на устройстве не влияют',
          type: SettingType.switcher,
        ),
      ],
    );
  }
}
