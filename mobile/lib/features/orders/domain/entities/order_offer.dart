enum DeliveryType { close, mid, far }

class OrderOffer {
  OrderOffer({
    required this.roadDistance,
    required this.roadTime,
    required this.deliveryType,
    required this.address,
    required this.passengerRating,
    required this.options,
    required this.coefficient,
  });

  String roadDistance;
  String roadTime;
  DeliveryType deliveryType;
  String address;
  double passengerRating;
  List options;
  double coefficient;

  static OrderOffer defaultOffer() {
    return OrderOffer(
      roadDistance: '1,2 км',
      roadTime: '13 мин',
      deliveryType: DeliveryType.close,
      address: 'улица Покровка, 45с1',
      passengerRating: 4.92,
      options: ['Платная подача', 'Детское кресло, от 9 мес'],
      coefficient: 1.85,
    );
  }
}
