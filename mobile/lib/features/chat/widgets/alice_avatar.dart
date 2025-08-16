import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../theme.dart';

class AliceAvatar extends StatefulWidget {
  final VoidCallback onTap;
  final double size;

  const AliceAvatar({
    super.key,
    required this.onTap,
    this.size = 40,
  });

  @override
  State<AliceAvatar> createState() => _AliceAvatarState();
}

class _AliceAvatarState extends State<AliceAvatar>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  
  bool _isHovered = false;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (_isAnimating) {
      _stopAnimation();
    } else {
      _startAnimation();
    }
    
    // Вызываем callback
    widget.onTap();
  }

  void _startAnimation() {
    setState(() {
      _isAnimating = true;
      _isHovered = true;
    });
    
    _scaleController.repeat(reverse: true);
  }

  void _stopAnimation() {
    setState(() {
      _isAnimating = false;
      _isHovered = false;
    });
    
    _scaleController.stop();
    
    _scaleController.animateTo(0.0, duration: const Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _scaleController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: widget.size,
              height: widget.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colors.controlMain,
              ),
              child: ClipOval(
                child: SvgPicture.asset(
                  _isHovered 
                      ? 'assets/icons/alice_hover.svg'
                      : 'assets/icons/alice_default.svg',
                  fit: BoxFit.cover,
                  width: widget.size,
                  height: widget.size,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}