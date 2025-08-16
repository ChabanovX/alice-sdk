part of '../../ui.dart';

class SheetEnded extends StatelessWidget {
  const SheetEnded({super.key});

  @override
  Widget build(BuildContext context) {
    // Since we exactly know the height min/max visible.
    const minVisibleHeight = 376.0 + 8.0 + 12;
    const maxVisibleHeight = minVisibleHeight + 24;

    return DraggableWindow(
      overlayWidget: _buildOverlay(context),
      innerWidgetBuilder: _buildInnerWidget,
      minVisibleHeight: minVisibleHeight,
      maxVisibleHeight: maxVisibleHeight,
    );
  }

  Widget _buildOverlay(BuildContext context) {
    const aliceSize = 56.0;
    const alicePadding = EdgeInsets.only(right: 12.0);

    return const Padding(
      padding: alicePadding,
      child: AliceWidget(messageText: 'Говорите!', size: aliceSize),
    );
  }

  Widget _buildInnerWidget(BuildContext context, ScrollController sc) {
    final textStyle1 = context.textStyles.boldBig;
    final textColor = context.colors.text;

    final endTextBox = Container(
      height: 56,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsetsGeometry.only(left: 12.0),
      child: Text(
        'Заказ завершён',
        style: textStyle1.copyWith(color: textColor),
      ),
    );

    const statsBox = EndOrderWidget(
      roadCost: '60420',
      bonus: '450',
      income: '43420',
      currency: 'AED',
    );

    final button = DefaultBigButton(
      isActive: true,
      onPressed: () {},
      margin: const EdgeInsets.all(8),
      text: 'Готово',
    );

    return Column(
      children: [
        endTextBox,
        statsBox,
        // Approximately (in Figma no borders).
        const SizedBox(height: 12),
        button,
      ],
    );
  }
}
