import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme.dart';
import 'order_badge.dart';

enum OrderButtonState { active, inactive, withBadge }

class OrderButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 48,
        child: Stack(
          children: [
            // Основной контент
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
                  const SizedBox(height: 4),
                  Text(
                    'Заказы',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _getTextColor(context),
                      fontSize: 9.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            // Badge (если нужно)
            if (state == OrderButtonState.withBadge)
              Positioned(
                right: 8,
                top: 4,
                child: OrderBadge(count: countBadge),
              ),
          ],
        ),
      ),
    );
  }

  Color _getIconColor(BuildContext context) {
    switch (state) {
      case OrderButtonState.active:
        return context.colors.text;
      case OrderButtonState.inactive:
      case OrderButtonState.withBadge:
        return context.colors.text.withValues(alpha: 0.3);
    }
  }

  Color _getTextColor(BuildContext context) {
    switch (state) {
      case OrderButtonState.active:
        return context.colors.text;
      case OrderButtonState.inactive:
      case OrderButtonState.withBadge:
        return context.colors.text.withValues(alpha: 0.3);
    }
  }
}
