import 'package:flutter/material.dart';
import '../../theme.dart';

class OrderBadge extends StatelessWidget {
  final int count;

  const OrderBadge({super.key, this.count = 1});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: context.colors.badge,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: context.colors.badge.withValues(alpha: 0.3),
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          count.toString(),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.surface,
            fontWeight: FontWeight.w400,
            fontSize: 9.5,
          ),
        ),
      ),
    );
  }
}
