enum DeliveryType {close, mid, far}

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
}
