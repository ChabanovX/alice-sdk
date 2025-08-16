part of '../../ui.dart';

class SheetLeaveLine extends StatelessWidget {
  const SheetLeaveLine({super.key});

  @override
  Widget build(BuildContext context) {
    // Since we exactly know the height min/max visible.
    const minVisibleHeight = 268.0;
    // Window is fixed here.
    const maxVisibleHeight = minVisibleHeight + 24.0;

    // Note: [DraggableWindow] forces to use different max/min values.
    // In case we need undraggable fixed window, should use simple column
    // instead.
    return DraggableWindow(
      innerWidgetBuilder: _buildInnerWidget,
      minVisibleHeight: minVisibleHeight,
      maxVisibleHeight: maxVisibleHeight,
    );
  }

  Widget _buildInnerWidget(BuildContext context, ScrollController sc) {
    const padding1 = EdgeInsetsGeometry.fromLTRB(12, 32, 12, 12);
    const padding2 = EdgeInsetsGeometry.fromLTRB(12, 0, 12, 16);
    const padding3 = EdgeInsetsGeometry.all(8.0);

    final textStyle1 = context.textStyles.boldBig;
    final textStyle2 = context.textStyles.regular;

    return Column(
      children: [
        Padding(
          padding: padding1,
          child: Text('Перестать получать заказы?', style: textStyle1),
        ),
        Padding(
          padding: padding2,
          child: Text(
            'Вы получаете заказы. Чтобы перестать, уйдите с линии',
            style: textStyle2,
          ),
        ),
        Padding(
          padding: padding3,
          child: _buildLeaveLineButton(context, onPressed: () {}),
        ),
      ],
    );
  }

  Widget _buildLeaveLineButton(
    BuildContext context, {
    required VoidCallback onPressed,
  }) {
    final textStyle = context.textStyles.mediumBig;
    final color = context.colors.controlMain;
    final textColor = context.colors.text;

    final borderRadius = BorderRadius.circular(40);

    final box = Container(
      height: 80,
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
      ),
      child: Center(
        child: Text(
          'Выйти с линии',
          style: textStyle.copyWith(color: textColor),
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
