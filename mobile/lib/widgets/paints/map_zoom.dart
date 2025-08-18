part of 'paints.dart';

class MapZoom extends StatelessWidget {
  const MapZoom({super.key, required this.size, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size * 2 + 1,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(size / 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomPaint(
                painter: PlusPainter(color: color ?? Colors.black),
              ),
            ),
          ),
          Divider(color: Colors.grey, thickness: 0.5, height: 0.5),
          SizedBox(
            width: size,
            height: size,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: CustomPaint(
                painter: MinusPainter(color: color ?? Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
