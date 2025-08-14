import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CurrentStreetTag extends StatelessWidget {
  final String currentStreet;

  const CurrentStreetTag({super.key, required this.currentStreet});

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceDim,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 9.5),
          child: Center(
            child: Text(
              currentStreet,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.w500,
                fontSize: 16,
                letterSpacing: 0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
