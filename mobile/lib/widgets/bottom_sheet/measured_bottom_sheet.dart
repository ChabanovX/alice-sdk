import 'package:flutter/material.dart';
import '../../core/navigation/bottom_sheet_manager.dart';

/// Виджет-обёртка для BottomSheet, который измеряет его высоту
class MeasuredBottomSheet extends StatefulWidget {
  const MeasuredBottomSheet({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<MeasuredBottomSheet> createState() => _MeasuredBottomSheetState();
}

class _MeasuredBottomSheetState extends State<MeasuredBottomSheet> {
  final GlobalKey _childKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Измеряем высоту после построения виджета
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measureHeight();
    });
  }

  @override
  void dispose() {
    // Сбрасываем высоту при закрытии модального BottomSheet
    BottomSheetManager().resetModalBottomSheetHeight();
    super.dispose();
  }

  void _measureHeight() {
    final renderBox =
        _childKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final height = renderBox.size.height;
      BottomSheetManager().setModalBottomSheetHeight(height);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _childKey,
      child: widget.child,
    );
  }
}
