import 'package:flutter/material.dart';
import '../../../theme.dart';
import '../models/message.dart';
import '../widgets/message_bubble.dart';
import '../widgets/message_input.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late List<Message> _messages;
  final ScrollController _scrollController = ScrollController();
  final Set<int> _newMessageIndices = {};

  @override
  void initState() {
    super.initState();
    _messages = [
      Message(
        text: 'Стою у Макдональдса',
        timestamp: DateTime(2024, 1, 1, 12, 30),
        isMe: false,
        hasAction: true,
        actionText: 'Озвучить',
        isPaused: false,
        onActionStateChanged: _handleActionStateChanged,
      ),
      Message(
        text: 'Здравствуйте, хорошо',
        timestamp: DateTime(2024, 1, 1, 12, 30),
        isMe: true,
      ),
    ];
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _handleActionStateChanged(bool isPaused) {
    setState(() {
      final index = _messages.indexWhere((msg) => msg.hasAction);
      if (index != -1) {
        _messages[index] = _messages[index].copyWith(
          isPaused: isPaused,
          onActionStateChanged: _handleActionStateChanged,
        );
      }
    });
  }

  void _handleSend(String text) {
    setState(() {
      final newIndex = _messages.length;
      _messages.add(
        Message(
          text: text,
          timestamp: DateTime.now(),
          isMe: true,
        ),
      );
      _newMessageIndices.add(newIndex);
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        setState(() {
          _newMessageIndices.remove(_messages.length - 1);
        });
      }
    });

    // Scroll to bottom after message is added
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Time indicator
        Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Center(
            child: Text(
              '12:29',
              style: context.textStyles.caption.copyWith(
                color: context.colors.textMiror,
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.only(top: 16, bottom: 16),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              return MessageBubble(
                message: _messages[index],
                isNewMessage: _newMessageIndices.contains(index),
              );
            },
          ),
        ),
        MessageInput(onSend: _handleSend),
      ],
    );
  }
}