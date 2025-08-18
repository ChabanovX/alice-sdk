import 'package:flutter/material.dart';
import '../../../theme.dart';

class AspectsWidget extends StatelessWidget {
  const AspectsWidget({
    super.key,
    required this.aspects,
    this.showDivider = true,
  });

  final List<AspectItem> aspects;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showDivider) ...[
          Divider(
            color: context.colors.semanticLine,
            thickness: 1,
            height: 1,
          ),
          const SizedBox(height: 12),
        ],
        _buildAspectsGrid(context),
      ],
    );
  }

  Widget _buildAspectsGrid(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: aspects.map((aspect) => _AspectTag(
        aspect: aspect,
      )).toList(),
    );
  }
}

class _AspectTag extends StatelessWidget {
  const _AspectTag({
    required this.aspect,
  });

  final AspectItem aspect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: aspect.isCommission 
            ? const Color(0xFF4060E3).withOpacity(0.1)
            : context.colors.semanticControlMiror,
        borderRadius: BorderRadius.circular(1000),
      ),
      child: Text(
        aspect.text,
        style: TextStyle(
          fontFamily: 'YandexSansText',
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: aspect.isCommission 
              ? const Color(0xFF4060E3)
              : const Color(0xFF21201F),
        ),
      ),
    );
  }
}

class AspectItem {
  const AspectItem({
    required this.text,
    this.isCommission = false,
  });

  final String text;
  final bool isCommission;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AspectItem &&
        other.text == text &&
        other.isCommission == isCommission;
  }

  @override
  int get hashCode => text.hashCode ^ isCommission.hashCode;
}
