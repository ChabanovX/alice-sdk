part of '../../../ui.dart';

class SheetOfflineV2 extends StatelessWidget {
  const SheetOfflineV2({super.key});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 4),
          const GrabHandle(),
          const SizedBox(height: 16),
          const PriorityAndOrdersWidget(),
          const SizedBox(height: 8),
          AliceNeedToKnowWidget(isActive: true, onTap: () {}),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
