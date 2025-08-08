import 'dart:developer' as developer;

/// Logger utility for Alice Voice Assistant
class AliceLogger {
  /// Creates a new logger instance
  const AliceLogger();

  /// Log level enumeration
  static const String _prefix = '[AliceVoiceAssistant]';

  /// Logs an info message
  void info(String message) {
    developer.log(
      message,
      name: _prefix,
      level: 800, // Info level
    );
  }

  /// Logs a warning message
  void warning(String message) {
    developer.log(
      message,
      name: _prefix,
      level: 900, // Warning level
    );
  }

  /// Logs an error message with optional error object and stack trace
  void error(String message, [Object? error, StackTrace? stackTrace]) {
    developer.log(
      message,
      name: _prefix,
      level: 1000, // Error level
      error: error,
      stackTrace: stackTrace,
    );
  }

  /// Logs a debug message (only in debug mode)
  void debug(String message) {
    developer.log(
      message,
      name: _prefix,
      level: 700, // Debug level
    );
  }
}