part of '../../ui.dart';

class SheetAtArriving extends StatelessWidget {
  const SheetAtArriving({super.key});

  @override
  Widget build(BuildContext context) {
    const minVisibleHeight = 80.0 + 56 + 80;
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

    return const Column(
      children: [
        Padding(
          padding: alicePadding,
          child: AliceWidget(
            messageText: 'Расскажу про детали поездки',
            size: aliceSize,
          ),
        ),
        SizedBox(height: 8),
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

    final payBox = SizedBox(
      height: 56,
      child: Row(
        children: [
          Container(
            width: 56,
            alignment: Alignment.center,
            child: SvgPicture.asset('assets/icons/cash_outlined.svg',),
          ),
          Expanded(
            child: Text(
              'Заказ будет оплачен картой',
              style: context.textStyles.regular,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '1000₽',
            style: context.textStyles.medium,
          ),
          const SizedBox(width: 12.0),
        ],
      ),
    );

    final button = DefaultSwipeButton(
      isActive: true,
      onPressed: () {},
      margin: const EdgeInsets.symmetric(horizontal: 12.0),
      innerBuilder: (context) => Text(
        'Завершить',
        style: context.textStyles.mediumBig.copyWith(
          color: context.colors.text,
        ),
      ),
    );

    return Column(
      children: [addressBox, payBox, button],
    );
  }
}
