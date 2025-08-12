part of 'paints.dart';

class MapLocationFilled extends StatelessWidget {
  const MapLocationFilled({super.key, required this.size, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return CommonRoundBlurButton(
      size: size,
      child: CustomPaint(
        painter: LocationFilledPainter(color: color ?? Colors.black),
      ),
    );
  }
}

class LocationFilledPainter extends CustomPainter {
  LocationFilledPainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final cell = size.width / 24;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(cell * 3, size.height / 2);
    path.lineTo(cell * 3, cell * 11.3);
    path.lineTo(cell * 18.4, cell * 5);
    path.lineTo(cell * 19, cell * 5.7);
    path.lineTo(cell * 12.8, cell * 21);
    path.lineTo(cell * 11.9, cell * 21);
    path.lineTo(cell * 9.5, cell * 14.5);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
