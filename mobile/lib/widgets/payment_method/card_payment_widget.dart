import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CardPaymentWidget extends StatelessWidget {
  const CardPaymentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 90,
      height: 32,
      decoration: BoxDecoration(
        color: const Color(0xff4060E3).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(34),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 12.0,
              top: 8,
              right: 4,
              bottom: 8,
            ),
            child: SvgPicture.asset(
              'assets/icons/bank_card.svg',
              width: 16,
              height: 16,
            ),
          ),
          const Text(
            'Картой',
            style: TextStyle(
              color: Color(0xff4060E3),
              fontWeight: FontWeight.w500,
              fontSize: 13,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}
