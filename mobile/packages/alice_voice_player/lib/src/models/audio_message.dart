import 'package:flutter/foundation.dart';

/// Represents a message that can be played by the voice assistant
@immutable
class AudioMessage {
  /// Creates a new audio message
  const AudioMessage({
    required this.assetPath,
    this.text,
    this.priority = MessagePriority.normal,
  });

  /// Path to the audio file in assets
  final String assetPath;

  /// Text representation of the message (optional)
  final String? text;

  /// Priority of the message
  final MessagePriority priority;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AudioMessage &&
          runtimeType == other.runtimeType &&
          assetPath == other.assetPath &&
          text == other.text &&
          priority == other.priority;

  @override
  int get hashCode => Object.hash(assetPath, text, priority);
}

/// Priority levels for audio messages
enum MessagePriority {
  /// High priority messages interrupt current playback
  high,

  /// Normal priority messages are queued if something is playing
  normal,

  /// Low priority messages are dropped if something is playing
  low,
}