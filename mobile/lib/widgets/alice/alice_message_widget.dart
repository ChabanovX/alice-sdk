import 'package:flutter/material.dart';

class AliceMessageWidget extends StatelessWidget {
  const AliceMessageWidget({
    super.key,
    required this.text,
    this.maxWidth = 320,
  });

  final String text;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final textStyle = const TextStyle(
      fontFamily: 'YandexSansText',
      fontWeight: FontWeight.w500,
      fontSize: 20,
      height: 1.2,
      color: Colors.black,
      letterSpacing: 0.0,
    );

    return Align(
      alignment: Alignment.centerRight,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: maxWidth,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(8),
              bottomLeft: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                offset: const Offset(0, 8),
                blurRadius: 20,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 18,
            ),
            child: Text(
              text,
              style: textStyle,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.left,
            ),
          ),
        ),
      ),
    );
  }
}


