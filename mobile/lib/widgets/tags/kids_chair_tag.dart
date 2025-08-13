import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class KidsChairTag extends StatelessWidget {
  const KidsChairTag({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 182,
      height: 32,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceDim,
        borderRadius: BorderRadius.circular(34),
      ),
      child: Center(
        child: Text(
          'Детское кресло,  от 9 мес',
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
