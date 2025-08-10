import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme.dart';

/// Виджет остановки пассажира с желтым фоном и информацией об остановке
class PassengerStopWidget3 extends StatelessWidget {
  const PassengerStopWidget3({
    super.key,
    required this.pointDistance,
    required this.timeOnWay,
  });

  /// Расстояние до точки
  final String pointDistance;

  /// Время в пути
  final String timeOnWay;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return Container(
      width: 120,
      height: 74,
      decoration: const BoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Основной контейнер с тенью
          Container(
            width: 120,
            height: 48,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.shadow,
                  offset: Offset.zero,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  // Иконка остановки
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SvgPicture.asset(
                      'assets/icons/point_a_no_stroke.svg',
                      width: 40,
                      height: 40,
                    ),
                  ),
                  // Колонка с текстом
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Адрес жирным шрифтом
                        Text(
                          pointDistance,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0,
                            wordSpacing: -2,
                            fontSize: 20,
                            color: theme.colorScheme.surface,
                            height: 1,
                          ),
                        ),
                        // Время подачи обычным шрифтом
                        Text(
                          timeOnWay,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.surface,
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Точка внизу
          Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: colors.text,
                shape: BoxShape.circle,
              ),
              child: Container(
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
