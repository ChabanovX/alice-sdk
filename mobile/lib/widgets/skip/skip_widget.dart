import 'package:flutter/material.dart';

/// Виджет кнопки "Пропустить"
/// Прямоугольник размером 122x48 с закругленными углами, тенью и текстом
class SkipWidget extends StatelessWidget {
  const SkipWidget({super.key});

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
        child: Text(
          'Пропустить',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w500,
            fontSize: 16,
            letterSpacing: 0,
          ),
        ),
      ),
    );
  }
}
