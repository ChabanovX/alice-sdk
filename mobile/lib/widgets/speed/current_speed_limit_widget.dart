import 'package:flutter/material.dart';

import '../../theme.dart';

/// Виджет отображения текущего лимита скорости
class CurrentSpeedLimitWidget extends StatelessWidget {
  final int currentSpeedLimit;
  final bool isShown;

  const CurrentSpeedLimitWidget({
    super.key,
    required this.currentSpeedLimit,
    this.isShown = true,
  });

  @override
  Widget build(BuildContext context) {
    // Если виджет не должен показываться, возвращаем пустой контейнер
    if (!isShown) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors().badge, width: 3),
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
          currentSpeedLimit.toString(),
          style: theme.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
