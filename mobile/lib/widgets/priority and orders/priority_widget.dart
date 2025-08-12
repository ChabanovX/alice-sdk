import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Виджет для отображения приоритета с иконкой и значением
class PriorityWidget extends StatelessWidget {
  /// Значение приоритета (по умолчанию 52)
  final int priorityValue;

  const PriorityWidget({super.key, this.priorityValue = 52});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 160,
      height: 56,
      child: Row(
        children: [
          // Левый SizedBox с иконкой приоритета
          SizedBox(
            width: 56,
            height: 56,
            child: Center(
              child: SvgPicture.asset(
                'assets/icons/priority.svg',
                width: 32,
                height: 32,
              ),
            ),
          ),
          // Правый SizedBox с текстом и значением
          SizedBox(
            width: 88,
            height: 56,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Верхний Row с текстом "Приоритет" и иконкой
                Row(
                  children: [
                    Text(
                      'Приоритет',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Yandex Sans Text',
                        letterSpacing: 0,
                      ),
                    ),
                    const SizedBox(width: 2),
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: SvgPicture.asset(
                        'assets/icons/chevron_right_rounded.svg',
                        width: 6.5,
                        height: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 1),
                // Нижний Text с значением приоритета
                Text(
                  '$priorityValue / 100',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    fontFamily: 'Yandex Sans Text',
                    letterSpacing: -1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
