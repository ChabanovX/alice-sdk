import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'alice_message_widget.dart';
import 'bloc/alice_bloc.dart';
import 'bloc/alice_event.dart';
import 'bloc/alice_state.dart';

class AliceWidget extends StatelessWidget {
  const AliceWidget({
    super.key,
    this.size = 72,
    this.iconDefaultAssetPath = 'assets/icons/alice_default.svg',
    this.iconHoverAssetPath = 'assets/icons/alice_hover.svg',
    this.fadeDuration = const Duration(milliseconds: 250),
    this.messageText = 'Слушаю команды...',
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
  Widget build(BuildContext context) {
    return BlocBuilder<AliceBloc, AliceState>(
      builder: (context, state) {
        return _buildAliceUI(context, state);
      },
    );
  }

  Widget _buildAliceUI(BuildContext context, AliceState state) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double containerWidth =
            constraints.maxWidth.isFinite ? constraints.maxWidth : size * 6;

        final double bubbleMaxWidth =
            (containerWidth - size - messageGap).clamp(0, double.infinity);

        final bool showMessage = _shouldShowMessage(state);
        final bool isActive = _isActiveState(state);
        final bool isScaling = _shouldScale(state);
        final String displayText = _getDisplayText(state);

        return SizedBox(
          height: size,
          width: containerWidth,
          child: Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Message bubble
                SizedBox(
                  width: showMessage ? bubbleMaxWidth : 0,
                  child: AnimatedOpacity(
                    opacity: showMessage ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: showMessage
                        ? Align(
                            alignment: Alignment.centerRight,
                            child: AliceMessageWidget(
                              text: displayText,
                              maxWidth: bubbleMaxWidth,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
                SizedBox(
                  width: showMessage ? messageGap : 0,
                ),
                // Alice icon
                GestureDetector(
                  onTap: () {
                    onPressed?.call();
                  },
                  child: AnimatedScale(
                    scale: isScaling ? 1.2 : 1.0,
                    duration: const Duration(milliseconds: 300),
                    child: Stack(
                      children: [
                        AnimatedCrossFade(
                          duration: fadeDuration,
                          crossFadeState: isActive
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          firstChild: _buildIcon(iconDefaultAssetPath),
                          secondChild: _buildIcon(iconHoverAssetPath),
                        ),
                      ],
                    ),
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
      width: size,
      height: size,
      child: ClipOval(
        child: SvgPicture.asset(
          assetPath,
          width: size,
          height: size,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  bool _shouldShowMessage(AliceState state) {
    return state is AliceActive;
  }

  bool _isActiveState(AliceState state) {
    return state is AliceActive;
  }

  bool _shouldScale(AliceState state) {
    return state is AliceActive;
  }

  String _getDisplayText(AliceState state) {
    return switch (state) {
      AliceActive() => 'Записываю команду...',
      AliceSleeping() => 'Скажите "Алиса"',
      _ => messageText,
    };
  }
}
