part of '../../../ui.dart';

class SheetToPickupV2 extends StatelessWidget {
  const SheetToPickupV2({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CurrentStreetTag(currentStreet: 'ул. Маросейка'),
        SizedBox(height: 8),
        RoadTracker(),
        SizedBox(height: 8),
        ColoredBox(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 8.5, horizontal: 12.0),
            child: PointAWidget(pointAddress: 'улица Покровка, 45с1'),
          ),
        ),
      ],
    );
  }
}
