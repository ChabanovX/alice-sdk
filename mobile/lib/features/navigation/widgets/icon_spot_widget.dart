import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../theme.dart';

class IconSpotWidget extends StatelessWidget {
  const IconSpotWidget({
    super.key,
    required this.icon,
    this.size = 40,
    this.onTap,
    this.showPlus = false,
  });

  final Widget icon;
  final double size;
  final VoidCallback? onTap;
  final bool showPlus;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: context.colors.semanticControlMiror,
          shape: BoxShape.circle,
        ),
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: icon,
              ),
            ),
            if (showPlus)
              Positioned(
                top: 2,
                right: 2,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '+',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class IconSpotWidgetSvg extends StatelessWidget {
  const IconSpotWidgetSvg({
    super.key,
    required this.svgPath,
    this.size = 40,
    this.iconSize = 20,
    this.onTap,
    this.showPlus = false,
  });

  final String svgPath;
  final double size;
  final double iconSize;
  final VoidCallback? onTap;
  final bool showPlus;

  @override
  Widget build(BuildContext context) {
    return IconSpotWidget(
      size: size,
      onTap: onTap,
      showPlus: showPlus,
      icon: SvgPicture.asset(
        svgPath,
        width: iconSize,
        height: iconSize,
        colorFilter: const ColorFilter.mode(
          Colors.black,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
