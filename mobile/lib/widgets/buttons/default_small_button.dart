part of 'buttons.dart';

class DefaultSmallButton extends StatelessWidget {
  const DefaultSmallButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    const outerPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 2);
    const intrinsicPadding = EdgeInsetsGeometry.symmetric(horizontal: 6.5);
    
    const height = 52.0;

    final color = context.colors.controlMain;
    final textColor = context.colors.text;
    final textStyle = context.textStyles.medium;

    final borderRadius = BorderRadius.circular(40);
    final border = Border.all(color: Colors.white, width: 2.0);

    // `IntrinsicWidth` was used to tight parent widget.
    final box = IntrinsicWidth(
      child: Container(
        padding: outerPadding,
        decoration: BoxDecoration(
          color: color,
          border: border,
          borderRadius: borderRadius,
        ),
        height: height,
        child: Center(
          child: Padding(
            padding: intrinsicPadding,
            child: Text(
              text,
              style: textStyle.copyWith(color: textColor),
            ),
          ),
        ),
      ),
    );

    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: box,
    );
  }
}
