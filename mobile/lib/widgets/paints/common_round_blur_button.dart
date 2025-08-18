part of 'paints.dart';

class CommonRoundBlurButton extends StatelessWidget {
  const CommonRoundBlurButton({
    super.key,
    required this.child,
    required this.size,
  });

  final Widget child;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 0),
            ),
          ],
          shape: BoxShape.circle,
        ),
        child: Padding(padding: const EdgeInsets.all(16), child: child),
      ),
    );
  }
}
