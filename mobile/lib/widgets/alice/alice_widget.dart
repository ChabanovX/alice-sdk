import 'dart:async';

import 'package:alice_voice_player/alice_voice_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';

import 'alice_message_widget.dart';

class AliceWidget extends StatefulWidget {
  const AliceWidget({
    super.key,
    this.size = 72,
    this.iconDefaultAssetPath = 'assets/icons/alice_default.svg',
    this.iconHoverAssetPath = 'assets/icons/alice_hover.svg',
    this.fadeDuration = const Duration(milliseconds: 250),
    required this.messageText,
    this.messageDelay = const Duration(seconds: 2),
    this.messageGap = 12,
    this.onPressed,
    // TTS settings
    this.ttsApiKey,
    this.ttsOauthToken,
    this.ttsFolderId,
    this.ttsVoice = 'alena',
    this.ttsFormat = 'mp3',
    this.ttsSampleRateHz = 48000,
    this.ttsTimeout = const Duration(seconds: 10),
    this.autoSpeak = true,
    this.showPlaybackIndicator = true,
  });

  /// Diameter of the round icon in logical pixels.
  final double size;

  /// Path to the default (idle) Alice SVG asset.
  final String iconDefaultAssetPath;

  /// Path to the hover/active Alice SVG asset.
  final String iconHoverAssetPath;

  /// Duration of fade between default and hover icons.
  final Duration fadeDuration;

  /// Text of the message to appear to the left of the icon.
  final String messageText;

  /// Delay after switching to hover before showing the message.
  final Duration messageDelay;

  /// Constant space between message bubble and the icon.
  final double messageGap;

  /// Optional callback invoked when icon is tapped.
  final VoidCallback? onPressed;

  // TTS Configuration
  /// Yandex SpeechKit API Key
  final String? ttsApiKey;

  /// Yandex SpeechKit OAuth Token
  final String? ttsOauthToken;

  /// Yandex Cloud Folder ID
  final String? ttsFolderId;

  /// Voice for TTS synthesis (default: 'alena')
  final String ttsVoice;

  /// Audio format (default: 'mp3')
  final String ttsFormat;

  /// Sample rate in Hz (default: 48000)
  final int ttsSampleRateHz;

  /// API timeout (default: 10 seconds)
  final Duration ttsTimeout;

  /// Auto-speak message when tapped (default: true)
  final bool autoSpeak;

  /// Show playback indicator (default: true)
  final bool showPlaybackIndicator;

  @override
  State<AliceWidget> createState() => _AliceWidgetState();
}

class _AliceWidgetState extends State<AliceWidget>
    with TickerProviderStateMixin {
  bool _isHover = false;
  bool _isPlaying = false;
  bool _isTtsInitialized = false;

  late final AnimationController _messageController;
  late final AnimationController _scaleController;
  late final Animation<double> _messageFade;
  late final Animation<Offset> _messageSlide;
  late final Animation<double> _scaleAnimation;
  Timer? _messageTimer;
  bool _messageShouldShow = false;

  YandexSpeechKitTts? _ttsService;
  AudioPlayer? _audioPlayer;

  AudioPlayer? _soundPlayer;

  @override
  void initState() {
    super.initState();

    _ttsService = YandexSpeechKitTts();
    _audioPlayer = AudioPlayer();
    _soundPlayer = AudioPlayer();

    _initializeTtsIfPossible();

    _messageController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _messageFade = CurvedAnimation(
      parent: _messageController,
      curve: Curves.easeInOut,
    );

    _messageSlide = Tween<Offset>(
      begin: const Offset(0.15, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _messageController,
      curve: Curves.easeOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.20,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _messageTimer?.cancel();
    _messageController.dispose();
    _scaleController.dispose();
    _ttsService?.dispose();
    _audioPlayer?.dispose();
    _soundPlayer?.dispose();
    super.dispose();
  }

  Future<void> _initializeTtsIfPossible() async {
    if ((widget.ttsApiKey != null && widget.ttsApiKey!.isNotEmpty) ||
        (widget.ttsOauthToken != null && widget.ttsOauthToken!.isNotEmpty)) {
      try {
        final apiKey = widget.ttsApiKey ?? '';
        if (apiKey.isEmpty ||
            apiKey == 'api' ||
            apiKey == 'speech-kit-apik-key') {
          return;
        }

        await _ttsService?.init(
          apiKey: apiKey,
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

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Alice TTS initialized'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('TTS initialization error: $e'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 3),
            ),
          );
        }
      }
    }
  }

  Future<void> _playActivationSound() async {
    try {
      await _soundPlayer?.setAsset('assets/audio/alice_on.mp3');
      await _soundPlayer?.play();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to play activation sound: $e');
      }
    }
  }

  Future<void> _playDeactivationSound() async {
    try {
      await _soundPlayer?.setAsset('assets/audio/alice_off.mp3');
      await _soundPlayer?.play();
    } catch (e) {
      if (kDebugMode) {
        print('Failed to play deactivation sound: $e');
      }
    }
  }

  void _handleTap() async {
    if (!_isHover) {
      setState(() => _isHover = true);
      _scaleController.repeat(reverse: true);
      _messageTimer?.cancel();
      _messageTimer = Timer(widget.messageDelay, () {
        if (mounted) {
          setState(() {
            _messageShouldShow = true;
          });
          _messageController.forward();
        }
      });

      await _playActivationSound();
      if (widget.autoSpeak &&
          _isTtsInitialized &&
          widget.messageText.isNotEmpty) {
        try {
          setState(() => _isPlaying = true);

          final audioBytes =
              await _ttsService?.synthesizeBytes(widget.messageText);
          if (audioBytes != null && _audioPlayer != null) {
            final audioSource = BytesAudioSource(audioBytes);
            await _audioPlayer!.setAudioSource(audioSource);
            await _audioPlayer!.play();

            _audioPlayer!.playerStateStream.listen((state) {
              if (state.processingState == ProcessingState.completed) {
                if (mounted) {
                  setState(() => _isPlaying = false);
                }
              }
            });
          }
        } catch (e) {
          setState(() => _isPlaying = false);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Playback error: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    } else {
      // Stop recording/playback
      setState(() => _isHover = false);
      _scaleController.stop();
      _scaleController.reset();
      _messageTimer?.cancel();
      _messageController.reverse().then((_) {
        if (mounted) {
          setState(() {
            _messageShouldShow = false;
          });
        }
      });

      await _playDeactivationSound();

      if (_isTtsInitialized) {
        try {
          await _audioPlayer?.stop();
          setState(() => _isPlaying = false);
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Stop error: $e'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    }

    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double containerWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : widget.size * 6;

        final double bubbleMaxWidth =
            (containerWidth - widget.size - widget.messageGap)
                .clamp(0, double.infinity);

        return SizedBox(
          height: widget.size,
          width: containerWidth,
          child: Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: _messageShouldShow ? bubbleMaxWidth : 0,
                  child: AnimatedOpacity(
                    opacity: _messageShouldShow ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: FadeTransition(
                      opacity: _messageFade,
                      child: SlideTransition(
                        position: _messageSlide,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: AliceMessageWidget(
                            text: widget.messageText,
                            maxWidth: bubbleMaxWidth,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: _messageShouldShow ? widget.messageGap : 0,
                ),
                GestureDetector(
                  onTap: _handleTap,
                  child: AnimatedBuilder(
                    animation: _scaleAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Stack(
                          children: [
                            AnimatedCrossFade(
                              duration: widget.fadeDuration,
                              crossFadeState: _isHover
                                  ? CrossFadeState.showSecond
                                  : CrossFadeState.showFirst,
                              firstChild:
                                  _buildIcon(widget.iconDefaultAssetPath),
                              secondChild:
                                  _buildIcon(widget.iconHoverAssetPath),
                            ),
                            // Playback indicator
                            if (_isPlaying && widget.showPlaybackIndicator)
                              Positioned(
                                top: 4,
                                right: 4,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.volume_up,
                                    size: 8,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildIcon(String assetPath) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: ClipOval(
        child: SvgPicture.asset(
          assetPath,
          width: widget.size,
          height: widget.size,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

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
