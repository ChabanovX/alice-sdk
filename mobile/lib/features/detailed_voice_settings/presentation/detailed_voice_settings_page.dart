part of 'presentation.dart';

class DetailedVoiceSettingsPage extends StatelessWidget {
  const DetailedVoiceSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: [
            const SettingsHeader(title: 'Звук навигации и приложения'),
            const CommonSettings(),
            TitledSlot(
              title: 'Алиса',
              prefix: SvgPicture.asset(
                AppIcons.aliceSmall,
              ),
            ),
            const AliceSettings(),
            const TitledSlot(title: 'Оповещения'),
            const NotificationsSettings(),
            const TitledSlot(title: 'Оповещение событий на карте'),
            const EventsAlertsOnTheMap(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
