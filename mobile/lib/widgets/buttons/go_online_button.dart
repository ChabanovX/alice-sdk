part of 'buttons.dart';

class GoOnlineButton extends StatelessWidget {
  const GoOnlineButton({
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
        : context.colors.controlMain.withValues(alpha: 0.5);

    final borderRadius = BorderRadius.circular(40);

    final textStyle1 = context.textStyles.regular;
    final textStyle2 = context.textStyles.bold;

    final textColor = context.colors.text;

    final box = Container(
      height: 80,
      margin: margin ?? EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Оффлайн', style: textStyle1.copyWith(color: textColor)),
                Text('Выйти на линию', style: textStyle2.copyWith(color: textColor)),
              ],
            ),
          ),
          if (isActive)
            Positioned(
              left: 6,
              top: 0,
              bottom: 0,
              child: Center(child: SlideButtonDefaultState()),
            ),
        ],
      ),
    );

    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: isActive ? onPressed : null,
      child: box,
    );
  }
}
