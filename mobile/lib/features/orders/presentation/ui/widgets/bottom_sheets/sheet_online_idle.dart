part of '../../ui.dart';

class SheetOnlineIdle extends StatelessWidget {
  const SheetOnlineIdle({super.key});

  @override
  Widget build(BuildContext context) {
    const minVisibleHeight = 146.0;
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
    const isNeedToKnowActive = true;

    return Column(
      children: [
        const PriorityAndOrdersWidget(),
        const SizedBox(height: 8),
        AliceNeedToKnowWidget(isActive: isNeedToKnowActive, onTap: () {}),
      ],
    );
  }
}
