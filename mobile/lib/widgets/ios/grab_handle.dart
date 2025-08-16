part of 'ios.dart';

class GrabHandle extends StatelessWidget {
  const GrabHandle({super.key, this.margin});

  static const _width = 34.0;
  static const _height = 4.0;
  static const _defaultMargin = EdgeInsets.symmetric(vertical: 5);

  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final color = context.colors.textMiror;
    final borderRadius = BorderRadius.circular(999);

    return Center(
      child: Container(
        width: _width,
        height: _height,
        margin: margin ?? _defaultMargin,
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
        ),
      ),
    );
  }
}
