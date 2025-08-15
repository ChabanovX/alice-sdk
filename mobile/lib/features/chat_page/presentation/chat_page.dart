part of '../../navigation/navigation.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  ChatPageAppBar(title: 'Включите тариф Комфорт+', onTap: () {},),
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsetsGeometry.only(
                  left: 16, top: 20, bottom: 20,),
              child: const Text(
                'Сообщения',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            StoriesSlider(),
            ChatPageItem(
              title: 'Поддержка',
              icon: AppIcons.hello,
              iconColor: context.colors.semanticBackground,
              iconBackgroundColor: const Color(0xFF029154),
            ),
            const ChatPageItem(
              title: 'Качество перевозок',
              icon: AppIcons.taxiChecker,
            ),
            ChatPageItem(
              title: 'Акции и промо',
              icon: AppIcons.promo,
              iconColor: context.colors.semanticBackground,
              iconBackgroundColor: const Color(0xFF4060E3),
            ),
            const ChatPageItem(
              title: 'Новости Pro',
              icon: AppIcons.xStar,
            ),
            ChatPageItem(
              title: 'Новый закон',
              icon: AppIcons.gosuslugi,
              iconColor: context.colors.semanticBackground,
              iconBackgroundColor: const Color(0xFF6587A3),
            ),
          ],
        ),
      ),
    );
  }
}
