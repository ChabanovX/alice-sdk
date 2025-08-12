import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import 'package:alice_voice_player/src/alice_core.dart';
import 'package:alice_voice_player/src/models/stt_config.dart';
import 'package:alice_voice_player/src/models/tts_exception.dart';

/// Yandex SpeechKit STT implementation
/// 
/// Provides speech-to-text recognition for audio data.
/// Note: This implementation only handles recognition of provided audio bytes.
/// For microphone recording, use platform-specific audio recording libraries.
class YandexSpeechKitStt implements AliceStt {
  /// Creates a new Yandex SpeechKit STT instance
  YandexSpeechKitStt();

  AliceSttConfig? _config;
  final http.Client _client = http.Client();
  bool _isInitialized = false;

  @override
  /// Initializes the STT service with configuration
  Future<void> init({
    required String apiKey,
    String? oauthToken,
    String? folderId,
    String language = 'ru-RU',
    String model = 'general',
    String audioFormat = 'oggopus',
    int sampleRateHz = 48000,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    _config = AliceSttConfig(
      apiKey: apiKey,
      oauthToken: oauthToken,
      folderId: folderId,
      language: language,
      model: model,
      audioFormat: audioFormat,
      sampleRateHz: sampleRateHz,
      timeout: timeout,
    );
    
    _isInitialized = true;
    developer.log('YandexSpeechKitStt initialized with language: $language, model: $model');
  }

  @override
  /// Recognizes speech from audio bytes
  Future<String> recognizeAudio(Uint8List audioBytes) async {
    _ensureInitialized();
    return _recognizeAudio(audioBytes);
  }

  @override
  /// Recognizes speech from audio stream
  Stream<String> recognizeAudioStream(Stream<List<int>> audioStream) async* {
    _ensureInitialized();
    
    try {
      // Collect audio chunks
      final chunks = <List<int>>[];
      await for (final chunk in audioStream) {
        chunks.add(chunk);
      }
      
      // Combine chunks and recognize
      final audioBytes = Uint8List.fromList(
        chunks.expand((chunk) => chunk).toList(),
      );
      
      final recognizedText = await _recognizeAudio(audioBytes);
      yield recognizedText;
    } catch (e) {
      developer.log('STT streaming recognition failed: $e');
      rethrow;
    }
  }

  /// Recognizes speech from audio bytes (internal method)
  Future<String> _recognizeAudio(Uint8List audioBytes) async {
    for (int attempt = 0; attempt <= _config!.maxRetries; attempt++) {
      try {
        final response = await _makeSttRequest(audioBytes);
        
        if (response.statusCode == 200) {
          final result = jsonDecode(response.body);
          final recognizedText = result['result'] as String? ?? '';
          
          developer.log('Speech recognition completed: "$recognizedText"');
          return recognizedText;
        } else {
          throw _handleSttErrorResponse(response);
        }
      } catch (e) {
        if (attempt == _config!.maxRetries) {
          rethrow;
        }
        
        developer.log('STT request failed (attempt ${attempt + 1}/${_config!.maxRetries + 1}): $e');
        await Future.delayed(_config!.retryDelay);
      }
    }
    
    throw const AliceTtsException(
      message: 'Max retries exceeded for speech recognition',
      type: AliceTtsExceptionType.network,
    );
  }

  /// Makes STT request to Yandex SpeechKit
  Future<http.Response> _makeSttRequest(Uint8List audioBytes) async {
    final uri = Uri.parse(_config!.apiUrl);
    final request = http.Request('POST', uri);
    
    // Set headers
    request.headers['Content-Type'] = 'application/x-www-form-urlencoded';
    request.headers['Authorization'] = 'Api-Key ${_config!.apiKey}';
    
    if (_config!.folderId != null) {
      request.headers['X-Folder-Id'] = _config!.folderId!;
    }
    
    // Build form data
    final body = {
      'audio': base64Encode(audioBytes),
      'lang': _config!.language,
      'model': _config!.model,
      'format': _config!.audioFormat,
      'sampleRateHertz': _config!.sampleRateHz.toString(),
    };
    
    request.body = body.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
    
    developer.log('STT request: ${request.url} with language: ${_config!.language}');
    return _client.send(request).timeout(_config!.timeout).then(
      (streamedResponse) => http.Response.fromStream(streamedResponse),
    );
  }

  /// Handles STT error responses
  AliceTtsException _handleSttErrorResponse(http.Response response) {
    String message;
    AliceTtsExceptionType type;
    
    switch (response.statusCode) {
      case 401:
        message = 'Authentication failed. Check your API key.';
        type = AliceTtsExceptionType.auth;
        break;
      case 403:
        message = 'Access denied. Check your permissions.';
        type = AliceTtsExceptionType.auth;
        break;
      case 429:
        message = 'Rate limit exceeded. Try again later.';
        type = AliceTtsExceptionType.rateLimit;
        break;
      case 400:
        message = 'Invalid request parameters.';
        type = AliceTtsExceptionType.invalidParams;
        break;
      default:
        message = 'HTTP ${response.statusCode}: ${response.body}';
        type = AliceTtsExceptionType.network;
    }
    
    developer.log('STT error: $message');
    return AliceTtsException(
      message: message,
      type: type,
      statusCode: response.statusCode,
    );
  }

  /// Ensures STT is initialized
  void _ensureInitialized() {
    if (!_isInitialized || _config == null) {
      throw const AliceTtsException(
        message: 'STT not initialized. Call init() first.',
        type: AliceTtsExceptionType.invalidParams,
      );
    }
  }

  @override
  /// Disposes resources
  Future<void> dispose() async {
    _client.close();
    _isInitialized = false;
  }
}
