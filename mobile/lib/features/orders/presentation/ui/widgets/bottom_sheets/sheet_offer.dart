part of '../../ui.dart';

class SheetOffer extends StatelessWidget {
  const SheetOffer({super.key, required this.state});

  final OfferArrived state;

  @override
  Widget build(BuildContext context) {
    final textStyle1 = context.textStyles.boldBig;
    final textColor = context.colors.text;
    final offer = state.orderOffer;

    final deliveryType = switch (offer.deliveryType) {
      DeliveryType.far => 'Дальняя подача',
      DeliveryType.mid => 'Средняя подача',
      DeliveryType.close => 'Ближняя подача',
    };

    const divider = Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Divider(),
    );

    final distanceTextBox = DefaultTextStyle(
      style: textStyle1.copyWith(color: textColor),
      child: Row(
        children: [
          Text(offer.roadDistance),
          const SizedBox(width: 4.0),
          const Text('·'),
          const SizedBox(width: 4.0),
          Text(offer.roadTime),
        ],
      ),
    );

    final routeTimeInfoBox = Padding(
      padding: const EdgeInsetsGeometry.only(left: 12.0),
      child: Column(
        children: [
          distanceTextBox,
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: ServeTag(
              text: deliveryType,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );

    final addressBox = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.5, horizontal: 12.0),
      child: PointAWidget(pointAddress: offer.address),
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
                offer.passengerRating.toString(),
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

    final hardOptinsImages = [
      'assets/icons/coins_outlined.svg',
      'assets/icons/child_chair_outlined.svg'
    ];

    final optionsBox = Column(
      children: List.generate(
        offer.options.length,
        (index) => Row(
          children: [
            Padding(
              padding: const EdgeInsetsGeometry.fromLTRB(24, 4, 12, 4),
              child: SvgPicture.asset(hardOptinsImages[index]),
            ),
            Text(offer.options[index], style: context.textStyles.regular),
          ],
        ),
      ),
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
          onPressed: () {
            final ordersBloc = context.read<OrdersBloc>();
            ordersBloc.add(AcceptOfferPressed());
            Navigator.of(context).pop();
          },
          margin: const EdgeInsets.symmetric(horizontal: 8),
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          routeTimeInfoBox,
          divider,
          addressBox,
          divider,
          passengerInfoBox,
          acceptButton,
        ],
      ),
    );
  }
}
