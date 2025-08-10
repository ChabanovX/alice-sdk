import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme.dart';

/// Виджет остановки пассажира с желтым фоном и информацией об остановке
class PassengerStopWidget2 extends StatelessWidget {
  const PassengerStopWidget2({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);

    return Container(
      width: 186,
      height: 72,
      decoration: const BoxDecoration(),
      child: Stack(
        children: [
          // Основной контейнер с тенью
          Container(
            width: 186,
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
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  // Иконка остановки
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: SvgPicture.asset(
                      'assets/icons/passenger_stop_yellow_back.svg',
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
                          'Льва Толстого, 16',
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        // Время подачи обычным шрифтом
                        Text(
                          'Подача от 7 мин',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Иконка chevron без отступа
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 12.0,
                      bottom: 12.0,
                      right: 5,
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/chevron_right.svg',
                      width: 24,
                      height: 24,
                      colorFilter: ColorFilter.mode(
                        theme.colorScheme.onSurface,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Хвост с тенью
          Positioned(
            top: 47.5,
            left: 81,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow,
                    offset: const Offset(0, 8),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: CustomPaint(
                size: const Size(24, 8),
                painter: _TailPainter(color: theme.colorScheme.surface),
              ),
            ),
          ),
          // Точка внизу
          Positioned(
            top: 58,
            left: 86,
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

/// Painter для создания треугольного хвоста указателя с вогнутыми сторонами
class _TailPainter extends CustomPainter {
  const _TailPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.quadraticBezierTo(
      size.width * 0.6,
      size.height * 0.1,
      size.width / 2,
      size.height,
    );
    path.quadraticBezierTo(size.width * 0.4, size.height * 0.1, 0, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
