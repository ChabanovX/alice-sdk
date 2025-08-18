part of 'presentation.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: const [
            SettingsHeader(title: 'Настройки'),
            TitledSlot(title: 'Общее'),
            SettingsCommon(),
            TitledSlot(title: 'Навигация'),
            SettingsNavigation(),
            TitledSlot(title: 'Настройка звуков'),
            SettingsSounds(),
            TitledSlot(title: 'Другое'),
            SettingsOther(),
            TitledSlot(title: 'Дополнительно'),
            SettingsAdditional(),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
