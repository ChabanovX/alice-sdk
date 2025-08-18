import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../theme.dart';

class ControlButtonWidget extends StatefulWidget {
  const ControlButtonWidget({
    super.key,
    required this.text,
    this.onTap,
    this.isEnabled = true,
  });

  final String text;
  final VoidCallback? onTap;
  final bool isEnabled;

  @override
  State<ControlButtonWidget> createState() => _ControlButtonWidgetState();
}

class _ControlButtonWidgetState extends State<ControlButtonWidget>
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
        if (widget.isEnabled) {
          _animationController.forward();
          HapticFeedback.mediumImpact();
        }
      },
      onTapUp: (_) {
        if (widget.isEnabled) {
          _animationController.reverse();
          widget.onTap?.call();
        }
      },
      onTapCancel: () {
        if (widget.isEnabled) {
          _animationController.reverse();
        }
      },
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              height: 56,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7.5),
              decoration: BoxDecoration(
                color: widget.isEnabled 
                    ? context.colors.controlMain
                    : context.colors.controlMain.withOpacity(0.5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  widget.text,
                  style: context.textStyles.medium.copyWith(
                    color: const Color(0xFF21201F),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
