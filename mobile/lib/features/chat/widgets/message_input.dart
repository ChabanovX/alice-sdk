import 'package:flutter/material.dart';
import '../../../theme.dart';
import 'alice_avatar.dart';

class MessageInput extends StatefulWidget {
  final Function(String) onSend;

  const MessageInput({
    super.key,
    required this.onSend,
  });

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final _controller = TextEditingController();
  bool _isAliceAnimating = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSend(text);
      _controller.clear();
    }
  }

  void _handleAliceTap() {
    setState(() {
      _isAliceAnimating = !_isAliceAnimating;
    });
    
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        color: context.colors.semanticBackground,
        border: Border(
          top: BorderSide(
            color: context.colors.semanticLine,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          AliceAvatar(
            onTap: _handleAliceTap,
            size: 48,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Сообщение...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: context.colors.semanticControlMiror,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              ),
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: context.colors.controlMain,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: _handleSend,
              icon: Icon(
                Icons.send,
                size: 24,
                color: context.colors.semanticText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}