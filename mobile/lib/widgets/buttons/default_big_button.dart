part of 'buttons.dart';

class DefaultBigButton extends StatelessWidget {
  const DefaultBigButton({
    super.key,
    required this.isActive,
    required this.onPressed,
    required this.text,
    this.margin,
  });

  final bool isActive;
  final VoidCallback onPressed;

  final EdgeInsetsGeometry? margin;
  final String text;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isActive
        ? context.colors.controlMain
        : context.colors.controlMain.withValues(alpha: 0.5);

    final borderRadius = BorderRadius.circular(40);

    final box = Container(
      height: 80,
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: Center(
        child: Text(
          text,
          style: context.textStyles.mediumBig.copyWith(
            color: context.colors.text,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );

    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: isActive ? onPressed : null,
      child: box,
    );
  }
}
