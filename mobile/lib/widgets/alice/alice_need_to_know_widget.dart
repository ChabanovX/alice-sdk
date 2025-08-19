import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme.dart';

/// this is sdhit.
class AliceNeedToKnowWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final bool isActive;

  const AliceNeedToKnowWidget({
    super.key,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        height: 56,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsetsGeometry.all(6),
            backgroundColor: context.colors.semanticControlMiror,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: context.colors.greenMinor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/icons/hand_icon.svg',
                        width: 28,
                        height: 28,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        (isActive)
                            ? Text(
                                'Важно знать',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            : Text(
                                'Важно знать...',
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                        if (isActive)
                          Text(
                            'Голосовой ассистент Алиса',
                            style: context.textStyles.caption,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              if (!isActive)
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: SvgPicture.asset(
                    'assets/icons/refresh.svg',
                    colorFilter: ColorFilter.mode(
                        context.colors.textMiror, BlendMode.srcIn),
                    width: 25,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
