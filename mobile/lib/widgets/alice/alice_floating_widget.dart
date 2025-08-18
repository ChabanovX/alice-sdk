import 'package:flutter/material.dart';
import '../../core/navigation/bottom_sheet_manager.dart';
import 'alice_widget.dart';

/// Виджет Алисы, который автоматически поднимается при открытии BottomSheet
/// Всегда позиционируется на 16px выше любого BottomSheet
class AliceFloatingWidget extends StatelessWidget {
  const AliceFloatingWidget({
    super.key,
    this.messageText = 'Говорите!',
    this.size = 56.0,
    this.right = 28.0,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  final String messageText;
  final double size;
  final double right;
  final Duration animationDuration;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: BottomSheetManager().scaffoldBottomSheetHeight,
      builder: (context, scaffoldHeight, child) {
        return ValueListenableBuilder<double>(
          valueListenable: BottomSheetManager().modalBottomSheetHeight,
          builder: (context, modalHeight, child) {
            return ValueListenableBuilder<bool>(
              valueListenable: BottomSheetManager().isModalFullscreen,
              builder: (context, isModalFullscreen, child) {
                late final double totalBottom;

                final bottom = MediaQuery.of(context).padding.bottom;
                if (modalHeight == 0) {
                  // Нет модального BottomSheet - Алиса на 16px выше обычного bottomSheet
                  totalBottom = scaffoldHeight + 16;
                } else {
                  if (isModalFullscreen) {
                    // Модальный BottomSheet на весь экран - Алиса на 16px выше видимого края
                    totalBottom = modalHeight - 16 - bottom;
                  } else {
                    // Модальный BottomSheet над navigation bar
                    const bottomNavigationHeight = 82.0;
                    totalBottom = bottomNavigationHeight + modalHeight - 16;
                  }
                }

                return AnimatedPositioned(
                  duration: animationDuration,
                  curve: Curves.easeOut,
                  right: right,
                  bottom: totalBottom,
                  child: SizedBox(
                    width: size,
                    height: size,
                    child: AliceWidget(
                      messageText: messageText,
                      size: size,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
