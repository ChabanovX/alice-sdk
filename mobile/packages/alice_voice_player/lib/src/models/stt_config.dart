/// Configuration for STT (Speech-to-Text) operations
class AliceSttConfig {
  /// Creates a new STT configuration
  const AliceSttConfig({
    required this.apiKey,
    this.oauthToken,
    this.folderId,
    this.language = 'ru-RU',
    this.model = 'general',
    this.audioFormat = 'oggopus',
    this.sampleRateHz = 48000,
    this.timeout = const Duration(seconds: 30),
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
    this.apiUrl = 'https://stt.api.cloud.yandex.net/speech/v1/stt:recognize',
    this.recordConfig = const RecordConfig(),
  });

  /// Yandex Cloud API Key
  final String apiKey;

  /// OAuth token (alternative to API Key)
  final String? oauthToken;

  /// Yandex Cloud Folder ID
  final String? folderId;

  /// Language for speech recognition
  final String language;

  /// Recognition model
  final String model;

  /// Audio format for recording
  final String audioFormat;

  /// Sample rate in Hz
  final int sampleRateHz;

  /// Request timeout
  final Duration timeout;

  /// Maximum number of retries
  final int maxRetries;

  /// Delay between retries
  final Duration retryDelay;

  /// Yandex SpeechKit STT API URL
  final String apiUrl;

  /// Recording configuration
  final RecordConfig recordConfig;

  /// Creates a copy with updated values
  AliceSttConfig copyWith({
    String? apiKey,
    String? oauthToken,
    String? folderId,
    String? language,
    String? model,
    String? audioFormat,
    int? sampleRateHz,
    Duration? timeout,
    int? maxRetries,
    Duration? retryDelay,
    String? apiUrl,
    RecordConfig? recordConfig,
  }) => AliceSttConfig(
        apiKey: apiKey ?? this.apiKey,
        oauthToken: oauthToken ?? this.oauthToken,
        folderId: folderId ?? this.folderId,
        language: language ?? this.language,
        model: model ?? this.model,
        audioFormat: audioFormat ?? this.audioFormat,
        sampleRateHz: sampleRateHz ?? this.sampleRateHz,
        timeout: timeout ?? this.timeout,
        maxRetries: maxRetries ?? this.maxRetries,
        retryDelay: retryDelay ?? this.retryDelay,
        apiUrl: apiUrl ?? this.apiUrl,
        recordConfig: recordConfig ?? this.recordConfig,
      );

  @override
  String toString() => 'AliceSttConfig(language: $language, model: $model, audioFormat: $audioFormat)';
}

/// Configuration for audio recording
class RecordConfig {
  /// Creates a new recording configuration
  const RecordConfig({
    this.encoder = AudioEncoder.opus,
    this.bitRate = 128000,
    this.sampleRate = 48000,
    this.numChannels = 1,
    this.maxDuration = const Duration(seconds: 30),
    this.autoGain = true,
    this.noiseSuppress = true,
    this.echoCancel = true,
  });

  /// Audio encoder
  final AudioEncoder encoder;

  /// Bit rate in bits per second
  final int bitRate;

  /// Sample rate in Hz
  final int sampleRate;

  /// Number of audio channels
  final int numChannels;

  /// Maximum recording duration
  final Duration maxDuration;

  /// Enable automatic gain control
  final bool autoGain;

  /// Enable noise suppression
  final bool noiseSuppress;

  /// Enable echo cancellation
  final bool echoCancel;

  @override
  String toString() => 'RecordConfig(encoder: $encoder, sampleRate: $sampleRate, maxDuration: $maxDuration)';
}

/// Audio encoder types
enum AudioEncoder {
  /// Opus encoder (recommended for speech)
  opus,
  
  /// AAC encoder
  aac,
  
  /// PCM encoder
  pcm,
}
