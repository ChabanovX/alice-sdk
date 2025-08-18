import 'dart:async';
import 'dart:typed_data';
import 'package:alice_voice_player/alice_voice_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_audio/just_audio.dart';
// import '../../features/new_alice/bloc/alice_bloc.dart';
import 'alice_message_widget.dart';

/// это тоже
class AliceButton extends StatefulWidget {
  const AliceButton({
    super.key,
    this.size = 72,
    this.iconDefaultAssetPath = 'assets/icons/alice_default.svg',
    this.iconHoverAssetPath = 'assets/icons/alice_hover.svg',
    this.fadeDuration = const Duration(milliseconds: 250),
    this.messageText = 'Говорите!',
    this.messageDelay = const Duration(seconds: 2),
    this.messageGap = 12,
    this.onPressed,
    this.autoSpeak = true,
    this.showPlaybackIndicator = true,
    // required this.bloc,
  });

  // final NewAliceBloc bloc;

  final double size;
  final String iconDefaultAssetPath;
  final String iconHoverAssetPath;
  final Duration fadeDuration;

  final String messageText;
  final Duration messageDelay;
  final double messageGap;

  final VoidCallback? onPressed;

  final bool autoSpeak;
  final bool showPlaybackIndicator;

  @override
  State<AliceButton> createState() => _AliceButtonState();
}

class _AliceButtonState extends State<AliceButton>
    with TickerProviderStateMixin {
  bool _isHover = false;
  bool _isPlaying = false;

  late final AnimationController _messageController;
  late final AnimationController _scaleController;
  late final Animation<double> _messageFade;
  late final Animation<Offset> _messageSlide;
  late final Animation<double> _scaleAnimation;
  Timer? _messageTimer;
  bool _messageShouldShow = false;

  AudioPlayer? _audioPlayer;
  AudioPlayer? _soundPlayer;
  StreamSubscription<PlayerState>? _playerStateSub;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _soundPlayer = AudioPlayer();

    _playerStateSub = _audioPlayer!.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (mounted) setState(() => _isPlaying = false);
      }
    });

    _messageController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _scaleController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));

    _messageFade =
        CurvedAnimation(parent: _messageController, curve: Curves.easeInOut);
    _messageSlide =
        Tween<Offset>(begin: const Offset(0.15, 0), end: Offset.zero).animate(
            CurvedAnimation(
                parent: _messageController, curve: Curves.easeOutCubic));

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.20).animate(
        CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _messageTimer?.cancel();
    _messageController.dispose();
    _scaleController.dispose();
    _playerStateSub?.cancel();
    _audioPlayer?.dispose();
    _soundPlayer?.dispose();
    super.dispose();
  }

  Future<void> _playActivationSound() async {
    try {
      await _soundPlayer?.setAsset('assets/audio/alice_on.mp3');
      await _soundPlayer?.play();
    } catch (e) {
      if (kDebugMode) print('Failed to play activation sound: $e');
    }
  }

  Future<void> _playDeactivationSound() async {
    try {
      await _soundPlayer?.setAsset('assets/audio/alice_off.mp3');
      await _soundPlayer?.play();
    } catch (e) {
      if (kDebugMode) print('Failed to play deactivation sound: $e');
    }
  }

  Future<void> _handleTap() async {
    if (!_isHover) {
      setState(() => _isHover = true);
      _scaleController.repeat(reverse: true);

      _messageTimer?.cancel();
      _messageTimer = Timer(widget.messageDelay, () {
        if (!mounted) return;
        setState(() => _messageShouldShow = true);
        _messageController.forward();
      });

      await _playActivationSound();
      // widget.bloc.add(AliceStartListening());
    } else {
      setState(() => _isHover = false);
      _scaleController.stop();
      _scaleController.reset();
      _messageTimer?.cancel();
      _messageController.reverse().then((_) {
        if (mounted) setState(() => _messageShouldShow = false);
      });

      await _playDeactivationSound();
    }

    widget.onPressed?.call();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final containerWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : widget.size * 6;
        final bubbleMaxWidth =
            (containerWidth - widget.size - widget.messageGap)
                .clamp(0, double.infinity)
                .toDouble();

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
                    opacity: _messageShouldShow ? 1 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: FadeTransition(
                      opacity: _messageFade,
                      child: SlideTransition(
                        position: _messageSlide,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: AliceMessageWidget(
                              text: widget.messageText,
                              maxWidth: bubbleMaxWidth),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: _messageShouldShow ? widget.messageGap : 0),
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
                            if (_isPlaying && widget.showPlaybackIndicator)
                              Positioned(
                                top: 4,
                                right: 4,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: const BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle),
                                  child: const Icon(Icons.volume_up,
                                      size: 8, color: Colors.white),
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
          child: SvgPicture.asset(assetPath,
              width: widget.size, height: widget.size, fit: BoxFit.contain)),
    );
  }
}
