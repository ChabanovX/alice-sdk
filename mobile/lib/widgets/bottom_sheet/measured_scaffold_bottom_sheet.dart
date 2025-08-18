import 'package:flutter/material.dart';
import '../../core/navigation/bottom_sheet_manager.dart';

/// Виджет-обёртка для обычного bottomSheet в Scaffold, измеряющий его высоту
class MeasuredScaffoldBottomSheet extends StatefulWidget {
  const MeasuredScaffoldBottomSheet({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<MeasuredScaffoldBottomSheet> createState() =>
      _MeasuredScaffoldBottomSheetState();
}

class _MeasuredScaffoldBottomSheetState
    extends State<MeasuredScaffoldBottomSheet> {
  final GlobalKey _childKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // Измеряем высоту после построения виджета
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measureHeight();
    });
  }

  void _measureHeight() {
    final renderBox =
        _childKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final height = renderBox.size.height;
      BottomSheetManager().setScaffoldBottomSheetHeight(height);
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
