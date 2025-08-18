import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Виджет иконки поворота направо
/// Круг цвета surfaceDim размером 40x40 с иконкой turn_right.svg размером 24x24 в центре
class BookmarkIconWidget extends StatelessWidget {
  const BookmarkIconWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceDim,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: SvgPicture.asset(
          'assets/icons/bookmark_add_outlined.svg',
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(
            Theme.of(context).colorScheme.onSurface,
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
