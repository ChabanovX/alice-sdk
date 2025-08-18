import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../theme.dart';

enum Sender { passenger, support, system }

class MessageNotification extends StatelessWidget {
  final String message;
  final VoidCallback? onTap;
  final Sender sender;

  const MessageNotification({
    super.key,
    this.sender = Sender.passenger,
    required this.message,
    required this.onTap,
  });

  String _getSenderText() {
    switch (sender) {
      case Sender.passenger:
        return 'От пасажира';
      case Sender.support:
        return 'От поддержки';
      case Sender.system:
        return 'От системы';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7.5, vertical: 8),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.08,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsetsGeometry.all(8),
            backgroundColor: context.colors.effectsNotification,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            shadowColor: theme.colorScheme.shadow,
            elevation: 10,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                      top: 7.5,
                      left: 6.1,
                      right: 6.25,
                      bottom: 6.11,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: theme.colorScheme.primary,
                    ),
                    child: SvgPicture.asset(
                      'assets/icons/chat_bubble_outlined.svg',
                      width: 40,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _getSenderText(),
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          message,
                          style: context.textStyles.caption.copyWith(
                            color: context.colors.textMiror,
                          ),
                          /*style: theme.textTheme.bodySmall?.copyWith(
                        color: context.colors.textMiror,
                      ),*/
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SvgPicture.asset(
                'assets/icons/chevron_right.svg',
                width: 35,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
