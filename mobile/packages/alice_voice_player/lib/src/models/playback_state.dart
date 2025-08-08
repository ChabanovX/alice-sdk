import 'package:flutter/foundation.dart';

/// Represents the current state of audio playback
@immutable
class PlaybackState {
  /// Creates a new playback state
  const PlaybackState({
    required this.isPlaying,
    required this.amplitude,
    this.error,
  });

  /// Whether audio is currently playing
  final bool isPlaying;

  /// Current amplitude value (0.0 to 1.0)
  final double amplitude;

  /// Error message if playback failed
  final String? error;

  /// Initial state with no playback
  static const initial = PlaybackState(
    isPlaying: false,
    amplitude: 0.0,
  );

  /// Creates a copy of this state with some fields replaced
  PlaybackState copyWith({
    bool? isPlaying,
    double? amplitude,
    String? error,
  }) {
    return PlaybackState(
      isPlaying: isPlaying ?? this.isPlaying,
      amplitude: amplitude ?? this.amplitude,
      error: error ?? this.error,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaybackState &&
          runtimeType == other.runtimeType &&
          isPlaying == other.isPlaying &&
          amplitude == other.amplitude &&
          error == other.error;

  @override
  int get hashCode => Object.hash(isPlaying, amplitude, error);
}