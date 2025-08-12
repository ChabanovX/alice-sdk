import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme.dart';

class RoadTracker extends StatelessWidget {
  final String timeWhenEnd;
  final String timeRemain;
  final String roadLength;

  const RoadTracker({
    super.key,
    this.roadLength = '1,5 км',
    this.timeWhenEnd = '14:19',
    this.timeRemain = '12 мин',
    re,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7.5, vertical: 8),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: context.colors.effectsNotification,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow,
              blurRadius: 6,
              spreadRadius: -3,
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsetsGeometry.only(top: 9.5, left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(roadLength, style: context.textStyles.medium),
                  Text(timeRemain, style: context.textStyles.medium),
                  Text(timeWhenEnd, style: context.textStyles.medium),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsGeometry.only(top: 0, left: 16, right: 16),
              child: SvgPicture.asset('assets/icons/track.svg', height: 30,)
              ),
          ],
        ),
      ),
    );
  }
}