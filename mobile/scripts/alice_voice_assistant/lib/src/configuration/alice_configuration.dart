import 'package:flutter/foundation.dart';

/// Configuration options for the Alice Voice Assistant
@immutable
class AliceConfiguration {
  /// Creates a new configuration instance
  const AliceConfiguration({
    this.enableLogging = kDebugMode,
    this.maxQueueSize = 10,
    this.interruptOnHighPriority = true,
    this.autoPlayQueue = true,
    this.defaultVolume = 1.0,
    this.amplitudeSimulation = const AmplitudeSimulationConfig(),
  });

  /// Whether to enable logging
  final bool enableLogging;

  /// Maximum number of messages that can be queued
  final int maxQueueSize;

  /// Whether high priority messages should interrupt current playback
  final bool interruptOnHighPriority;

  /// Whether to automatically play queued messages
  final bool autoPlayQueue;

  /// Default volume level (0.0 to 1.0)
  final double defaultVolume;

  /// Configuration for amplitude simulation
  final AmplitudeSimulationConfig amplitudeSimulation;

  /// Default configuration
  factory AliceConfiguration.defaultConfig() => const AliceConfiguration();

  /// Configuration for development with extensive logging
  factory AliceConfiguration.development() => const AliceConfiguration(
        enableLogging: true,
        maxQueueSize: 5,
      );

  /// Configuration for production with minimal logging
  factory AliceConfiguration.production() => const AliceConfiguration(
        enableLogging: false,
        maxQueueSize: 20,
      );

  /// Creates a copy of this configuration with some fields replaced
  AliceConfiguration copyWith({
    bool? enableLogging,
    int? maxQueueSize,
    bool? interruptOnHighPriority,
    bool? autoPlayQueue,
    double? defaultVolume,
    AmplitudeSimulationConfig? amplitudeSimulation,
  }) {
    return AliceConfiguration(
      enableLogging: enableLogging ?? this.enableLogging,
      maxQueueSize: maxQueueSize ?? this.maxQueueSize,
      interruptOnHighPriority: interruptOnHighPriority ?? this.interruptOnHighPriority,
      autoPlayQueue: autoPlayQueue ?? this.autoPlayQueue,
      defaultVolume: defaultVolume ?? this.defaultVolume,
      amplitudeSimulation: amplitudeSimulation ?? this.amplitudeSimulation,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AliceConfiguration &&
          runtimeType == other.runtimeType &&
          enableLogging == other.enableLogging &&
          maxQueueSize == other.maxQueueSize &&
          interruptOnHighPriority == other.interruptOnHighPriority &&
          autoPlayQueue == other.autoPlayQueue &&
          defaultVolume == other.defaultVolume &&
          amplitudeSimulation == other.amplitudeSimulation;

  @override
  int get hashCode => Object.hash(
        enableLogging,
        maxQueueSize,
        interruptOnHighPriority,
        autoPlayQueue,
        defaultVolume,
        amplitudeSimulation,
      );
}

/// Configuration for amplitude simulation during playback
@immutable
class AmplitudeSimulationConfig {
  /// Creates a new amplitude simulation configuration
  const AmplitudeSimulationConfig({
    this.enabled = true,
    this.baseAmplitude = 0.5,
    this.variation = 0.3,
    this.speed = 0.7,
    this.updateInterval = const Duration(milliseconds: 50),
  });

  /// Whether amplitude simulation is enabled
  final bool enabled;

  /// Base amplitude level (0.0 to 1.0)
  final double baseAmplitude;

  /// Amplitude variation range (0.0 to 1.0)
  final double variation;

  /// Speed of amplitude changes (0.0 to 1.0)
  final double speed;

  /// How often to update amplitude values
  final Duration updateInterval;

  /// Creates a copy of this configuration with some fields replaced
  AmplitudeSimulationConfig copyWith({
    bool? enabled,
    double? baseAmplitude,
    double? variation,
    double? speed,
    Duration? updateInterval,
  }) {
    return AmplitudeSimulationConfig(
      enabled: enabled ?? this.enabled,
      baseAmplitude: baseAmplitude ?? this.baseAmplitude,
      variation: variation ?? this.variation,
      speed: speed ?? this.speed,
      updateInterval: updateInterval ?? this.updateInterval,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AmplitudeSimulationConfig &&
          runtimeType == other.runtimeType &&
          enabled == other.enabled &&
          baseAmplitude == other.baseAmplitude &&
          variation == other.variation &&
          speed == other.speed &&
          updateInterval == other.updateInterval;

  @override
  int get hashCode => Object.hash(
        enabled,
        baseAmplitude,
        variation,
        speed,
        updateInterval,
      );
}