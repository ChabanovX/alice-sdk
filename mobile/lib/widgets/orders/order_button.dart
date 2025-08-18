import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme.dart';
import 'order_badge.dart';

enum OrderButtonState { active, inactive, withBadge }

class OrderButton extends StatefulWidget {
  final OrderButtonState state;
  final int countBadge;
  final VoidCallback? onTap;

  const OrderButton({
    super.key,
    this.state = OrderButtonState.active,
    this.countBadge = 0,
    this.onTap,
  });

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.88,
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

  void _handleTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    _animationController.reverse();
    widget.onTap?.call();
  }

  void _handleTapCancel() {
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              height: 46,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/icons/location_fill.svg',
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(
                            _getIconColor(context),
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Заказы',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: _getTextColor(context),
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.state == OrderButtonState.withBadge)
                    Positioned(
                      right: 8,
                      top: 4,
                      child: OrderBadge(count: widget.countBadge),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getIconColor(BuildContext context) {
    switch (widget.state) {
      case OrderButtonState.active:
        return context.colors.text;
      case OrderButtonState.inactive:
      case OrderButtonState.withBadge:
        return context.colors.text.withValues(alpha: 0.3);
    }
  }

  Color _getTextColor(BuildContext context) {
    switch (widget.state) {
      case OrderButtonState.active:
        return context.colors.text;
      case OrderButtonState.inactive:
      case OrderButtonState.withBadge:
        return context.colors.text.withValues(alpha: 0.3);
    }
  }
}
