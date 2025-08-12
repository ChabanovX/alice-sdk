import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import 'package:alice_voice_player/src/alice_core.dart';
import 'package:alice_voice_player/src/models/tts_config.dart';
import 'package:alice_voice_player/src/models/tts_exception.dart';

/// Yandex SpeechKit TTS implementation
class YandexSpeechKitTts implements AliceTts {
  /// Creates a new Yandex SpeechKit TTS instance
  YandexSpeechKitTts();

  AliceTtsConfig? _config;
  final http.Client _client = http.Client();
  bool _isInitialized = false;

  @override
  Future<void> init({
    required String apiKey,
    String? oauthToken,
    String? folderId,
    String voice = 'alena',
    String format = 'mp3',
    int sampleRateHz = 48000,
    Duration timeout = const Duration(seconds: 10),
  }) async {
    _config = AliceTtsConfig(
      apiKey: apiKey,
      oauthToken: oauthToken,
      folderId: folderId,
      voice: voice,
      format: format,
      sampleRateHz: sampleRateHz,
      timeout: timeout,
    );
    _isInitialized = true;
    developer.log('YandexSpeechKitTts initialized with voice: $voice, format: $format');
  }

  @override
  Future<Uint8List> synthesizeBytes(String text) async {
    _ensureInitialized();
    
    for (int attempt = 0; attempt <= _config!.maxRetries; attempt++) {
      try {
        final response = await _makeRequest(text);
        
        if (response.statusCode == 200) {
          return response.bodyBytes;
        } else {
          throw _handleErrorResponse(response);
        }
      } catch (e) {
        if (attempt == _config!.maxRetries) {
          rethrow;
        }
        
        developer.log('TTS request failed (attempt ${attempt + 1}/${_config!.maxRetries + 1}): $e');
        await Future.delayed(_config!.retryDelay);
      }
    }
    
    throw const AliceTtsException(
      message: 'Max retries exceeded',
      type: AliceTtsExceptionType.network,
    );
  }

  @override
  Stream<List<int>> synthesizeStream(String text) async* {
    _ensureInitialized();
    
    try {
      final request = _buildRequest(text);
      final streamedResponse = await _client.send(request).timeout(_config!.timeout);
      
      if (streamedResponse.statusCode == 200) {
        yield* streamedResponse.stream;
      } else {
        final response = await http.Response.fromStream(streamedResponse);
        throw _handleErrorResponse(response);
      }
    } catch (e) {
      if (e is AliceTtsException) rethrow;
      throw AliceTtsException(
        message: 'Stream synthesis failed: $e',
        type: AliceTtsExceptionType.network,
      );
    }
  }

  @override
  Future<Uint8List> onTextInput(String text) => synthesizeBytes(text);

  @override
  Future<Uint8List> onVoiceInput(String recognizedText) => onTextInput(recognizedText);

  @override
  Future<void> dispose() async {
    _client.close();
    _isInitialized = false;
  }

  void _ensureInitialized() {
    if (!_isInitialized || _config == null) {
      throw const AliceTtsException(
        message: 'TTS not initialized. Call init() first.',
        type: AliceTtsExceptionType.invalidParams,
      );
    }
  }

  Future<http.Response> _makeRequest(String text) async {
    final request = _buildRequest(text);
    return _client.send(request).timeout(_config!.timeout).then(
      (streamedResponse) => http.Response.fromStream(streamedResponse),
    );
  }

  http.Request _buildRequest(String text) {
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
      'text': text,
      'voice': _config!.voice,
      'format': _config!.format,
      'sampleRateHertz': _config!.sampleRateHz.toString(),
      'emotion': 'neutral',
    };
    
    request.body = body.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
    
    developer.log('TTS request: ${request.url} with voice: ${_config!.voice}');
    return request;
  }

  AliceTtsException _handleErrorResponse(http.Response response) {
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
    
    developer.log('TTS error: $message');
    return AliceTtsException(
      message: message,
      type: type,
      statusCode: response.statusCode,
    );
  }
}
