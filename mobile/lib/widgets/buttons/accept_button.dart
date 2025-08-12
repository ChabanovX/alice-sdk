part of 'buttons.dart';

enum AcceptButtonStyle { regular, highlighted, nonActive }

class AcceptButton extends StatelessWidget {
  const AcceptButton({
    super.key,
    required this.buttonStyle,
    required this.onPressed,
    this.margin,
  });

  final AcceptButtonStyle buttonStyle;
  final EdgeInsetsGeometry? margin;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = switch (buttonStyle) {
      AcceptButtonStyle.regular => context.colors.controlMain,
      AcceptButtonStyle.highlighted => context.colors.cash,
      AcceptButtonStyle.nonActive => context.colors.semanticControlMiror,
    };

    final String rate = switch (buttonStyle) {
      AcceptButtonStyle.regular => 'x1.00',
      AcceptButtonStyle.highlighted => 'x1.85',
      AcceptButtonStyle.nonActive => 'x1.85',
    };

    final Color textColor = switch (buttonStyle) {
      AcceptButtonStyle.regular => context.colors.text,
      // TODO: add to context.colors
      AcceptButtonStyle.highlighted => Colors.white,
      AcceptButtonStyle.nonActive => context.colors.text,
    };

    final borderRadius = BorderRadius.circular(40);
    final textStyle = context.textStyles.mediumBig;

    final box = Container(
      height: 80,
      margin: margin ?? EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: DefaultTextStyle(
        style: textStyle.copyWith(color: textColor),
        child: Row(
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 16),
                    SvgPicture.asset(
                      'assets/icons/new_order_icon.svg',
                      colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
                    ),
                    SizedBox(width: 3.5),
                    Text('+1'),
                  ],
                ),
              ),
            ),
            Expanded(child: Center(child: Text('Принять'))),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(rate, style: textStyle),
                    SizedBox(width: 3.5),
                    SvgPicture.asset(
                      'assets/icons/coefficient_icon.svg',
                      colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
                    ),
                    SizedBox(width: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return CupertinoButton(
      onPressed: buttonStyle != AcceptButtonStyle.nonActive ? onPressed : null,
      padding: EdgeInsets.zero,
      child: box,
    );
  }
}
