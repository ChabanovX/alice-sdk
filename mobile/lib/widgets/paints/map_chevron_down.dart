part of 'paints.dart';

class MapChevronDown extends StatelessWidget {
  const MapChevronDown({super.key, required this.size, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return CommonRoundBlurButton(
      size: size,
      child: CustomPaint(
        painter: ChevronDownPainter(color: color ?? Colors.black),
      ),
    );
  }
}

class ChevronDownPainter extends CustomPainter {
  ChevronDownPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final cell = size.width / 24;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * cell;

    final path = Path();
    path.moveTo(cell * 4.5, cell * 10.5);
    path.lineTo(cell * 12, cell * 18);
    path.lineTo(cell * 19.5, cell * 10.5);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
