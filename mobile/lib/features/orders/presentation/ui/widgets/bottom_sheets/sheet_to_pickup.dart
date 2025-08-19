part of '../../ui.dart';

class SheetToPickup extends StatelessWidget {
  const SheetToPickup({super.key});

  @override
  Widget build(BuildContext context) {
    // Since we exactly know the height min/max visible.
    const minVisibleHeight = 80.0 + 6.0;
    const maxVisibleHeight = minVisibleHeight + 24;

    return DraggableWindow(
      overlayWidget: _buildOverlay(context),
      innerWidgetBuilder: _buildInnerWidget,
      minVisibleHeight: minVisibleHeight,
      maxVisibleHeight: maxVisibleHeight,
      overlayGap: 8.0,
    );
  }

  Widget _buildOverlay(BuildContext context) {
    return const Column(
      children: [
        CurrentStreetTag(currentStreet: 'ул. Маросейка'),
        SizedBox(height: 8),
        RoadTracker(),
      ],
    );
  }

  Widget _buildInnerWidget(BuildContext context, ScrollController sc) {
    return const Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.5, horizontal: 12.0),
          child: PointAWidget(pointAddress: 'улица Покровка, 45с1'),
        ),
        Divider(),
      ],
    );
  }
}
