import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 7.5),
      child: Container(
        height: 56,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsetsGeometry.all(8),
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
                  (isActive)
                    ? SvgPicture.asset('assets/icons/alice_online.svg')
                    : SvgPicture.asset('assets/icons/alice_offline.svg'),
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
                  colorFilter: ColorFilter.mode(context.colors.textMiror, BlendMode.srcIn),
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