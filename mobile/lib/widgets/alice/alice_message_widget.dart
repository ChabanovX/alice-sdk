import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:alice_voice_player/alice_voice_player.dart';

class AliceMessageWidget extends StatefulWidget {
  const AliceMessageWidget({
    super.key,
    required this.text,
    this.maxWidth = 320,
    this.autoSpeak = true,
    // TTS settings
    this.ttsApiKey,
    this.ttsOauthToken,
    this.ttsFolderId,
    this.ttsVoice = 'alena',
    this.ttsFormat = 'mp3',
    this.ttsSampleRateHz = 48000,
    this.ttsTimeout = const Duration(seconds: 10),
  });

  final String text;
  final double maxWidth;
  final bool autoSpeak;
  
  // TTS Configuration
  final String? ttsApiKey;
  final String? ttsOauthToken;
  final String? ttsFolderId;
  final String ttsVoice;
  final String ttsFormat;
  final int ttsSampleRateHz;
  final Duration ttsTimeout;

  @override
  State<AliceMessageWidget> createState() => _AliceMessageWidgetState();
}

class _AliceMessageWidgetState extends State<AliceMessageWidget> {
  String? _previousText;
  bool _isTtsInitialized = false;
  late final YandexSpeechKitTts _ttsService;
  AudioPlayer? _audioPlayer;

  @override
  void initState() {
    super.initState();
    _previousText = widget.text;
    
    // Initialize built-in TTS service
    _ttsService = YandexSpeechKitTts();
    _audioPlayer = AudioPlayer();
    _initializeTtsIfPossible();
  }

  @override
  void didUpdateWidget(AliceMessageWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // If text changed and auto-speak is enabled, synthesize speech
    if (widget.autoSpeak && 
        widget.text != _previousText && 
        widget.text.isNotEmpty) {
      _previousText = widget.text;
      _speakText();
    }
  }

  Future<void> _initializeTtsIfPossible() async {
    // Check if we have data to initialize TTS
    if (widget.ttsApiKey != null || widget.ttsOauthToken != null) {
      try {
        await _ttsService.init(
          apiKey: widget.ttsApiKey ?? '',
          oauthToken: widget.ttsOauthToken,
          folderId: widget.ttsFolderId,
          voice: widget.ttsVoice,
          format: widget.ttsFormat,
          sampleRateHz: widget.ttsSampleRateHz,
          timeout: widget.ttsTimeout,
        );
        
        setState(() {
          _isTtsInitialized = true;
        });
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('TTS initialization error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _speakText() async {
    if (!_isTtsInitialized) return;
    
    try {
      // Synthesize speech
      final audioBytes = await _ttsService.synthesizeBytes(widget.text);
      if (_audioPlayer != null) {
        // Play audio using just_audio
        final audioSource = BytesAudioSource(audioBytes);
        await _audioPlayer!.setAudioSource(audioSource);
        await _audioPlayer!.play();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Speech synthesis error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _ttsService.dispose();
    _audioPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = const TextStyle(
      fontFamily: 'YandexSansText',
      fontWeight: FontWeight.w500,
      fontSize: 20,
      height: 1.2,
      color: Colors.black,
      letterSpacing: 0.0,
    );

    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: widget.maxWidth,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(8),
              bottomLeft: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                offset: const Offset(0, 8),
                blurRadius: 20,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 18,
            ),
            child: Text(
              widget.text,
              style: textStyle,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.left,
            ),
          ),
        ),
      ),
    );
  }
}

/// Audio source from bytes for just_audio
class BytesAudioSource extends StreamAudioSource {
  BytesAudioSource(this._audioBytes);

  final Uint8List _audioBytes;

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start ??= 0;
    end ??= _audioBytes.length;
    
    return StreamAudioResponse(
      sourceLength: _audioBytes.length,
      contentLength: end - start,
      offset: start,
      stream: Stream.value(_audioBytes.sublist(start, end)),
      contentType: 'audio/mpeg',
    );
  }
}


