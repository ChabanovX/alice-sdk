import 'package:flutter/material.dart';

/// Кнопка в дефолтном состоянии - круг с обычными тенями
class SlideButtonDefaultState extends StatelessWidget {
  const SlideButtonDefaultState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SizedBox(
      width: 347,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: 68.0,
          height: 68.0,
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(34.0),
            boxShadow: [
              BoxShadow(
                color: colors.shadow,
                offset: const Offset(0, 8),
                blurRadius: 20,
              ),
            ],
          ),
          child: const Center(
            child: Icon(Icons.arrow_forward, size: 40, color: Colors.black),
          ),
        ),
      ),
    );
  }
}

/// Кнопка в состоянии при зажатии - круг с primary цветом
class SlideButtonPressedState extends StatelessWidget {
  const SlideButtonPressedState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SizedBox(
      width: 347,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: 68.0,
          height: 68.0,
          decoration: BoxDecoration(
            color: colors.primary,
            borderRadius: BorderRadius.circular(34.0),
            boxShadow: [
              BoxShadow(
                color: colors.shadow,
                offset: const Offset(0, 8),
                blurRadius: 20,
              ),
            ],
          ),
          child: Center(
            child: Icon(Icons.arrow_forward, size: 40, color: colors.onPrimary),
          ),
        ),
      ),
    );
  }
}

/// Кнопка в состоянии при растягивании - прямоугольник
class SlideButtonStretchedState extends StatelessWidget {
  const SlideButtonStretchedState({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SizedBox(
      width: 347,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          width: 347.0,
          height: 68.0,
          decoration: BoxDecoration(
            color: colors.primary,
            borderRadius: BorderRadius.circular(34.0),
            boxShadow: [
              BoxShadow(
                color: colors.shadow,
                offset: const Offset(0, 8),
                blurRadius: 20,
              ),
            ],
          ),
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 14.0),
              child: Icon(
                Icons.arrow_forward,
                size: 40,
                color: colors.onPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
