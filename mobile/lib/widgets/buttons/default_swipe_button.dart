part of 'buttons.dart';

class DefaultSwipeButton extends StatelessWidget {
  const DefaultSwipeButton({
    super.key,
    required this.isActive,
    required this.onPressed,
    this.innerBuilder,
    this.margin,
  });

  final bool isActive;
  final VoidCallback onPressed;

  /// Usually some text.
  /// 
  /// Put in center.
  final Widget Function(BuildContext)? innerBuilder;
  final EdgeInsetsGeometry? margin;

  Widget _defaultInner(BuildContext context) {
    final textStyle1 = context.textStyles.regular;
    final textStyle2 = context.textStyles.boldSmall;

    final textColor = context.colors.text;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Оффлайн', style: textStyle1.copyWith(color: textColor)),
        Text('Выйти на линию', style: textStyle2.copyWith(color: textColor)),
      ],
    );
  }

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
      child: Stack(
        children: [
          Center(
            child: (innerBuilder != null)
                ? innerBuilder!(context)
                : _defaultInner(context),
          ),
          if (isActive)
            const Positioned(
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
