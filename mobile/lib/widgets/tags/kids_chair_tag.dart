import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class KidsChairTag extends StatelessWidget {
  const KidsChairTag({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      height: 32,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceDim,
        borderRadius: BorderRadius.circular(34),
      ),
      child: Center(
        child: Text(
          'Детское кресло,  от 9 мес',
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w500,
            fontSize: 13,
            letterSpacing: 0,
          ),
        ),
      ),
    );
  }
}
