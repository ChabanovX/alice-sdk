import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CloseServeStarTag extends StatelessWidget {
  const CloseServeStarTag({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      width: 157,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceDim,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/icons/star_filled.svg',
              height: 16,
              width: 16,
            ),
            const SizedBox(
              width: 4,
            ),
            Text(
              'Ближняя подача',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w400,
                fontSize: 16,
                letterSpacing: 0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
