part of '../navigation.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Экран Общение',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Icon(Icons.chat_bubble, size: 64, color: Colors.blue),
        ],
      ),
    );
  }
}
