import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CloseServeTag extends StatelessWidget {
  const CloseServeTag({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: 139,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceDim,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          'Ближняя подача',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w400,
            fontSize: 16,
            letterSpacing: 0,
          ),
        ),
      ),
    );
  }
}
