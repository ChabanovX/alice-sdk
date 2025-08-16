import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';
import '../../../theme.dart';

class IconSpotWidget extends StatefulWidget {
  const IconSpotWidget({
    super.key,
    required this.icon,
    this.size = 40,
    this.onTap,
    this.showPlus = false,
  });

  final Widget icon;
  final double size;
  final VoidCallback? onTap;
  final bool showPlus;

  @override
  State<IconSpotWidget> createState() => _IconSpotWidgetState();
}

class _IconSpotWidgetState extends State<IconSpotWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 180),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.94,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        _animationController.forward();
        HapticFeedback.mediumImpact();
      },
      onTapUp: (_) {
        _animationController.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () {
        _animationController.reverse();
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                color: context.colors.semanticControlMiror,
                shape: BoxShape.circle,
              ),
              child: Stack(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: widget.icon,
                    ),
                  ),
                  if (widget.showPlus)
                    Positioned(
                      top: 2,
                      right: 2,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            '+',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class IconSpotWidgetSvg extends StatelessWidget {
  const IconSpotWidgetSvg({
    super.key,
    required this.svgPath,
    this.size = 40,
    this.iconSize = 20,
    this.onTap,
    this.showPlus = false,
  });

  final String svgPath;
  final double size;
  final double iconSize;
  final VoidCallback? onTap;
  final bool showPlus;

  @override
  Widget build(BuildContext context) {
    return IconSpotWidget(
      size: size,
      onTap: onTap,
      showPlus: showPlus,
      icon: SvgPicture.asset(
        svgPath,
        width: iconSize,
        height: iconSize,
        colorFilter: const ColorFilter.mode(
          Colors.black,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
