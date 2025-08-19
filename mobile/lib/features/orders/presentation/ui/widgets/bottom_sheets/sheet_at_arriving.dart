part of '../../ui.dart';

class SheetAtArriving extends StatelessWidget {
  const SheetAtArriving({super.key});

  @override
  Widget build(BuildContext context) {
    const minVisibleHeight = 80.0 + 6.0;
    const maxVisibleHeight = minVisibleHeight + 24;

    return DraggableWindow(
      overlayWidget: _buildOverlay(context),
      innerWidgetBuilder: _buildInnerWidget,
      minVisibleHeight: minVisibleHeight,
      maxVisibleHeight: maxVisibleHeight,
    );
  }

  Widget _buildOverlay(BuildContext context) {
    return const Column(
      children: [
        RoadTracker(
          isEnding: true,
          timeRemain: "1 мин",
        ),
      ],
    );
  }

  Widget _buildInnerWidget(BuildContext context, ScrollController sc) {
    final addressBox = SizedBox(
      height: 48,
      child: Row(
        children: [
          Container(
            width: 56,
            alignment: Alignment.center,
            child: SvgPicture.asset('assets/icons/point_b.svg'),
          ),
          Expanded(
            child: Text(
              'улица Воздвиженка, 10',
              style: context.textStyles.regular,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );

    return Column(
      children: [addressBox],
    );
  }
}
