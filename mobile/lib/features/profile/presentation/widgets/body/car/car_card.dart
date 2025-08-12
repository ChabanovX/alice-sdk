part of '../../../presentation.dart';

class CarCard extends StatelessWidget {
  const CarCard({
    super.key,
    required this.number,
    required this.carModel,
    required this.description,
  });

  final String number;
  final String carModel;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      padding: const EdgeInsets.only(
        left: 16,
        top: 16,
        bottom: 16,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFFF5F4F2),
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                carModel,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 25),
              CarNumber(number: number),
            ],
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 268.61,
              maxHeight: 95.75,
            ),
            child: Image.asset(
              AppImages.carExample,
            ),
          ),
        ],
      ),
    );
  }
}
