import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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

  @override
  State<AliceWidget> createState() => _AliceWidgetState();
}

class _AliceWidgetState extends State<AliceWidget> with TickerProviderStateMixin {
  bool _isHover = false;
  late final AnimationController _messageController;
  late final AnimationController _scaleController;
  late final Animation<double> _messageFade;
  late final Animation<Offset> _messageSlide;
  late final Animation<double> _scaleAnimation;
  Timer? _messageTimer;
  bool _messageShouldShow = false;

  @override
  void initState() {
    super.initState();

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
    super.dispose();
  }

  void _handleTap() {
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
    } else {
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

        final double bubbleMaxWidth = (containerWidth - widget.size - widget.messageGap)
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
                        child: AnimatedCrossFade(
                          duration: widget.fadeDuration,
                          crossFadeState: _isHover
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          firstChild: _buildIcon(widget.iconDefaultAssetPath),
                          secondChild: _buildIcon(widget.iconHoverAssetPath),
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


