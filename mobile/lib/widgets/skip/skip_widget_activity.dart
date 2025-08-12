import 'package:flutter/material.dart';

/// Виджет кнопки "Пропустить" с отображением активности
/// Прямоугольник размером 122x48 с закругленными углами, тенью и текстом
class SkipActivityWidget extends StatelessWidget {
  /// Значение активности для отображения
  final int activityValue;

  const SkipActivityWidget({super.key, required this.activityValue});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 122,
      height: 48,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(34),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow,
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Center(
        child: Column(
          spacing: -2,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Пропустить',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w500,
                fontSize: 16,
                letterSpacing: 0,
              ),
            ),
            Text(
              'Активность -$activityValue',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w400,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
