import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Виджет остановки пассажира с желтым фоном и информацией об остановке
class TurnWithDistanceWidget extends StatelessWidget {
  const TurnWithDistanceWidget({super.key, required this.turnDistance});

  /// Расстояние до точки
  final int turnDistance;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 175,
      height: 64,
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow,
            offset: Offset.zero,
            blurRadius: 10,
          ),
          BoxShadow(
            color: theme.colorScheme.shadow,
            offset: Offset(0, 8),
            blurRadius: 20,
          ),
        ],
      ),
      child: Row(
        children: [
          // Иконка поворота
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 14),
            child: SvgPicture.asset(
              'assets/icons/turn_left_sign_without_back.svg',
              width: 36,
              height: 54,
            ),
          ),
          // Колонка с текстом
          Text(
            "$turnDistance м",
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: theme.colorScheme.surface,
            ),
          ),
        ],
      ),
    );
  }
}
