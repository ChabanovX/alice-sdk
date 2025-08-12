import 'package:flutter/material.dart';

/// Виджет online с градиентной заливкой в стиле Angular
class ControlOnlineWidget extends StatelessWidget {
  final int employment;

  const ControlOnlineWidget({super.key, required this.employment});

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
          // Градиентный круг с border и незаконченной окружностью
          Stack(
            alignment: Alignment.center,
            children: [
              // Основной круг с border
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: SweepGradient(
                    colors: [colorScheme.primary, colorScheme.secondary],
                    stops: const [0.0, 0.5],
                    transform: const GradientRotation(0),
                  ),
                  border: Border.all(color: colorScheme.surface, width: 3),
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
                    '+$employment',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              // Незаконченная окружность поверх border
              Center(
                child: CustomPaint(
                  size: const Size(53, 53),
                  painter: ArcPainter(
                    color: colorScheme.onSurface,
                    strokeWidth: 3,
                    startAngle: -1.75, // Начальный угол в радианах
                    sweepAngle: 3.6, // Длина дуги в радианах
                  ),
                ),
              ),
            ],
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

/// CustomPainter для отрисовки незаконченной окружности
class ArcPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double startAngle;
  final double sweepAngle;

  const ArcPainter({
    required this.color,
    required this.strokeWidth,
    required this.startAngle,
    required this.sweepAngle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
