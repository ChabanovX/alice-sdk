import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Виджет остановки пассажира с желтым фоном и иконкой человека
class PassengerStopWidget1 extends StatelessWidget {
  const PassengerStopWidget1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 72,
      decoration: const BoxDecoration(),
      child: Stack(
        children: [
          // Основной контейнер с тенью
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  offset: Offset.zero,
                  blurRadius: 10,
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCE000),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/passenger_stop_yellow_back.svg',
                    width: 32,
                    height: 32,
                  ),
                ),
              ),
            ),
          ),
          // Хвост с тенью
          Positioned(
            top: 47.5,
            left: 12,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    offset: const Offset(0, 8),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: CustomPaint(
                size: const Size(24, 8),
                painter: _TailPainter(),
              ),
            ),
          ),
          // Точка внизу
          Positioned(
            top: 58,
            left: 17,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: const Color(0xFF21201F),
                shape: BoxShape.circle,
              ),
              child: Container(
                margin: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: Colors.white,
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
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final Path path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.3,
      size.width / 2,
      size.height,
    );
    path.quadraticBezierTo(size.width * 0.25, size.height * 0.3, 0, 0);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
