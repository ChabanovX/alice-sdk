class AliceTtsConfig {
  const AliceTtsConfig({
    required this.apiKey,
    this.oauthToken,
    this.folderId,
    this.voice = 'alena',
    this.format = 'mp3',
    this.sampleRateHz = 48000,
    this.timeout = const Duration(seconds: 10),
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
    this.apiUrl = 'https://tts.api.cloud.yandex.net/speech/v1/tts:synthesize',
  });

  /// Yandex Cloud API Key
  final String apiKey;

  /// OAuth token (alternative to API Key)
  final String? oauthToken;

  /// Yandex Cloud Folder ID
  final String? folderId;

  /// Voice to use for synthesis
  final String voice;

  /// Audio format
  final String format;

  /// Sample rate in Hz
  final int sampleRateHz;

  /// Request timeout
  final Duration timeout;

  /// Maximum number of retries
  final int maxRetries;

  /// Delay between retries
  final Duration retryDelay;

  /// Yandex SpeechKit API URL
  final String apiUrl;

  /// Creates a copy with updated values
  AliceTtsConfig copyWith({
    String? apiKey,
    String? oauthToken,
    String? folderId,
    String? voice,
    String? format,
    int? sampleRateHz,
    Duration? timeout,
    int? maxRetries,
    Duration? retryDelay,
    String? apiUrl,
  }) => AliceTtsConfig(
        apiKey: apiKey ?? this.apiKey,
        oauthToken: oauthToken ?? this.oauthToken,
        folderId: folderId ?? this.folderId,
        voice: voice ?? this.voice,
        format: format ?? this.format,
        sampleRateHz: sampleRateHz ?? this.sampleRateHz,
        timeout: timeout ?? this.timeout,
        maxRetries: maxRetries ?? this.maxRetries,
        retryDelay: retryDelay ?? this.retryDelay,
        apiUrl: apiUrl ?? this.apiUrl,
      );

  @override
  String toString() => 'AliceTtsConfig(voice: $voice, format: $format, sampleRateHz: $sampleRateHz)';
}
