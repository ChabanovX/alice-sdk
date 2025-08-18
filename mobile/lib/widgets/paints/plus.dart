part of 'paints.dart';

class PlusPainter extends CustomPainter {
  PlusPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final cell = size.width / 24;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * cell;

    canvas.drawLine(
      Offset(cell * 12, cell * 3),
      Offset(cell * 12, cell * 21),
      paint,
    );

    canvas.drawLine(
      Offset(cell * 3, cell * 12),
      Offset(cell * 21, cell * 12),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
