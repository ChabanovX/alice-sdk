import 'package:flutter/material.dart';

/// Виджет online с градиентной заливкой в стиле Angular
class ControlOnlineWidget extends StatelessWidget {
  const ControlOnlineWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SizedBox(
      width: 56,
      height: 79,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Градиентный круг с border
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const SweepGradient(
                colors: [Colors.transparent, Colors.transparent],
                stops: [0.0, 1.0],
                transform: GradientRotation(0),
              ),
              border: Border.all(color: colorScheme.surface, width: 3),
            ),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(
                  colors: [colorScheme.primary, colorScheme.secondary],
                  stops: const [0.0, 0.5],
                  transform: const GradientRotation(0),
                ),
              ),
              child: Center(
                child: Text(
                  '+52',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          // Прозрачный контейнер с текстом
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: SizedBox(
              width: 56,
              height: 15,
              child: Center(
                child: Text(
                  'занят',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
