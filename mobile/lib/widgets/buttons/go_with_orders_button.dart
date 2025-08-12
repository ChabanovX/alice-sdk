part of 'buttons.dart';

class GoWithOrdersButton extends StatelessWidget {
  const GoWithOrdersButton({
    super.key,
    required this.isActive,
    required this.onPressed,
    this.margin,
  });

  final bool isActive;
  final EdgeInsetsGeometry? margin;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isActive
        ? context.colors.controlMain
        : context.colors.semanticControlMiror;

    final textStyle = context.textStyles.medium;
    final borderRadius = BorderRadius.circular(16);

    final box = Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      height: 56,
      margin: margin ?? EdgeInsets.symmetric(horizontal: 16),
      child: Center(
        child: Text(
          'Поехать с заказами по пути',
          // Pass color since CupertinoButton overrides it.
          style: textStyle.copyWith(color: context.colors.text),
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
