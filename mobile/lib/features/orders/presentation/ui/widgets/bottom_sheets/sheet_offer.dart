part of '../../ui.dart';

class SheetOffer extends StatelessWidget {
  const SheetOffer({super.key});

  @override
  Widget build(BuildContext context) {
    // Since we exactly know the height min/max visible.
    const minVisibleHeight = 376.0 + 8.0;
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

    const divider = Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Divider(),
    );

    final distanceTextBox = DefaultTextStyle(
      style: textStyle1.copyWith(color: textColor),
      child: const Row(
        children: [
          Text('1,2 км'),
          SizedBox(width: 4.0),
          Text('·'),
          SizedBox(width: 4.0),
          Text('13 мин'),
        ],
      ),
    );

    final routeTimeInfoBox = Padding(
      padding: const EdgeInsetsGeometry.only(left: 12.0),
      child: Column(
        children: [
          distanceTextBox,
          const SizedBox(height: 8),
          const Align(
            alignment: Alignment.centerLeft,
            child: CloseServeTag(),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );

    const addressBox = Padding(
      padding: EdgeInsets.symmetric(vertical: 8.5, horizontal: 12.0),
      child: PointAWidget(pointAddress: 'улица Покровка, 45с1'),
    );

    final passengerBox = Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0),
      child: Row(
        children: [
          const SizedBox(width: 4.0),
          SvgPicture.asset('assets/icons/passenger_stop_black_back.svg'),
          const SizedBox(width: 8.0),
          Text('Пассажир', style: context.textStyles.medium),
          const Spacer(),
          Row(
            children: [
              Text(
                '4.92',
                style: context.textStyles.mediumBig.copyWith(
                  color: context.colors.textMiror,
                ),
              ),
              const SizedBox(
                width: 4.0,
              ),
              SvgPicture.asset(
                'assets/icons/star_filled.svg',
                colorFilter: ColorFilter.mode(
                  context.colors.textMiror,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ],
      ),
    );

    final optionsBox = Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsetsGeometry.fromLTRB(24, 4, 12, 4),
              child: SvgPicture.asset('assets/icons/coins_outlined.svg'),
            ),
            Text('Платная подача', style: context.textStyles.regular),
          ],
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Padding(
              padding: const EdgeInsetsGeometry.fromLTRB(24, 4, 12, 4),
              child: SvgPicture.asset('assets/icons/child_chair_outlined.svg'),
            ),
            Text(
              'Детское кресло,  от 9 мес',
              style: context.textStyles.regular,
            ),
          ],
        ),
      ],
    );

    final passengerInfoBox = Column(
      children: [passengerBox, optionsBox],
    );

    final acceptButton = Column(
      children: [
        const SizedBox(
          height: 12.0,
        ),
        AcceptButton(
          buttonStyle: AcceptButtonStyle.highlighted,
          onPressed: () {},
          margin: const EdgeInsets.symmetric(horizontal: 8),
        ),
      ],
    );

    return Column(
      children: [
        routeTimeInfoBox,
        divider,
        addressBox,
        divider,
        passengerInfoBox,
        acceptButton,
      ],
    );
  }
}
