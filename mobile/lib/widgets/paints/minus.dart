part of 'paints.dart';

class MinusPainter extends CustomPainter {
  MinusPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final cell = size.width / 24;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * cell;

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
