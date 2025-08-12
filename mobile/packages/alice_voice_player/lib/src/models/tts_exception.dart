/// Exception thrown when TTS operations fail
class AliceTtsException implements Exception {
  /// Creates a new TTS exception
  const AliceTtsException({
    required this.message,
    this.type = AliceTtsExceptionType.unknown,
    this.statusCode,
  });

  /// Error message
  final String message;

  /// Type of exception
  final AliceTtsExceptionType type;

  /// HTTP status code if applicable
  final int? statusCode;

  @override
  String toString() {
    final buffer = StringBuffer('AliceTtsException: $message');
    if (type != AliceTtsExceptionType.unknown) {
      buffer.write(' (type: $type)');
    }
    if (statusCode != null) {
      buffer.write(' (status: $statusCode)');
    }
    return buffer.toString();
  }
}

/// Types of TTS exceptions
enum AliceTtsExceptionType {
  /// Network-related errors
  network,
  
  /// Authentication/authorization errors
  auth,
  
  /// Invalid parameters
  invalidParams,
  
  /// Rate limiting
  rateLimit,
  
  /// Timeout errors
  timeout,
  
  /// Unknown errors
  unknown,
}
