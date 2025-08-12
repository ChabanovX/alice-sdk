part of 'paints.dart';

class MapButton extends StatelessWidget {
  const MapButton({super.key, required this.size, this.color});

  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CommonRoundBlurButton(
      size: size,
      child: CustomPaint(
        painter: MapButtonPainter(color: color ?? Colors.black),
      ),
    );
  }
}

class MapButtonPainter extends CustomPainter {
  MapButtonPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final cell = size.width / 24;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5 * cell;

    final path1 = Path();
    path1.moveTo(cell * 4.5, cell * 9);
    path1.lineTo(size.width / 2, cell * 4.5);
    path1.lineTo(size.width - cell * 4.5, cell * 9);
    path1.lineTo(size.width / 2, cell * 14.5);
    path1.close();

    final path2 = Path();
    path2.moveTo(cell * 4.5, cell * 14);
    path2.lineTo(size.width / 2, size.height - cell * 4.5);
    path2.lineTo(size.width - cell * 4.5, cell * 14);

    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
