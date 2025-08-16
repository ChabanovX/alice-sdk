import 'package:flutter/material.dart';

/// Виджет offline с концентрическими кругами
class CurrentSpeedWidget extends StatelessWidget {
  final int currentSpeed;

  const CurrentSpeedWidget({super.key, required this.currentSpeed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow,
            offset: Offset(0, 8),
            blurRadius: 20,
          ),
        ],
      ),
      child: Center(
        child: Text(
          currentSpeed.toString(),
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
