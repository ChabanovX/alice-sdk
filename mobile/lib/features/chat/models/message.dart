class Message {
  final String text;
  final DateTime timestamp;
  final bool isMe;
  final bool hasAction;
  final String? actionText;
  final bool isPaused;
  final Function(bool)? onActionStateChanged;

  const Message({
    required this.text,
    required this.timestamp,
    required this.isMe,
    this.hasAction = false,
    this.actionText,
    this.isPaused = true,
    this.onActionStateChanged,
  });

  Message copyWith({
    String? text,
    DateTime? timestamp,
    bool? isMe,
    bool? hasAction,
    String? actionText,
    bool? isPaused,
    Function(bool)? onActionStateChanged,
  }) {
    return Message(
      text: text ?? this.text,
      timestamp: timestamp ?? this.timestamp,
      isMe: isMe ?? this.isMe,
      hasAction: hasAction ?? this.hasAction,
      actionText: actionText ?? this.actionText,
      isPaused: isPaused ?? this.isPaused,
      onActionStateChanged: onActionStateChanged ?? this.onActionStateChanged,
    );
  }
}