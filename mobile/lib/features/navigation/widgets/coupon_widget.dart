import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../theme.dart';

class CouponWidget extends StatelessWidget {
  const CouponWidget({
    super.key,
    required this.title,
    required this.description,
    required this.isEnabled,
    required this.onToggle,
    this.remainingUses,
    this.totalUses,
    this.updateFrequency,
  });

  final String title;
  final String description;
  final bool isEnabled;
  final ValueChanged<bool> onToggle;
  final int? remainingUses;
  final int? totalUses;
  final String? updateFrequency;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isTablet = constraints.maxWidth > 600;
        
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          decoration: BoxDecoration(
            color: context.colors.semanticControlMiror,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: context.textStyles.regular.copyWith(
                        color: context.colors.text,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  CupertinoSwitch(
                    value: isEnabled,
                    onChanged: onToggle,
                    activeColor: context.colors.controlMain,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Divider(
                color: context.colors.semanticLine,
                thickness: 0.5,
                height: 1,
              ),
              const SizedBox(height: 12),
              Text(
                _buildDescriptionText(),
                style: context.textStyles.caption.copyWith(
                  color: context.colors.textMiror,
                  height: 1.4,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _buildDescriptionText() {
    if (remainingUses != null && totalUses != null) {
      final usesText = 'Осталось $remainingUses из $totalUses применений';
      if (updateFrequency != null) {
        return '$usesText, $updateFrequency';
      }
      return usesText;
    }
    return description;
  }
}
