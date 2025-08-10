part of 'paints.dart';

class MapArrowLeft extends StatelessWidget {
  const MapArrowLeft({super.key, required this.size, this.color});

  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CommonRoundBlurButton(
      size: size,
      child: CustomPaint(
        painter: ArrowBackPainter(color: color ?? Colors.black),
      ),
    );
  }
}

class ArrowBackPainter extends CustomPainter {
  ArrowBackPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final cell = size.width / 24;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * cell;

    canvas.drawLine(
      Offset(cell * 4.2, cell * 12.8),
      Offset(cell * 12, cell * 5),
      paint,
    );

    canvas.drawLine(
      Offset(cell * 4.8, cell * 12),
      Offset(cell * 12, cell * 19),
      paint,
    );

    canvas.drawLine(
      Offset(cell * 5, cell * 12),
      Offset(cell * 20, cell * 12),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
