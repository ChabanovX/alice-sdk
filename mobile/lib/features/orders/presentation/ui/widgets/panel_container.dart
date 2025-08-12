part of '../ui.dart';

// import 'package:flutter_bloc/flutter_bloc.dart';

// enum PanelMode { collapsed, expanded }

// class PanelCubit extends Cubit<PanelMode> {
//   PanelCubit() : super(PanelMode.collapsed);
//   void toggle() => emit(
//     state == PanelMode.collapsed ? PanelMode.expanded : PanelMode.collapsed,
//   );
//   void collapse() => emit(PanelMode.collapsed);
//   void expand() => emit(PanelMode.expanded);
// }

class PanelContainer extends StatefulWidget {
  final Widget Function(BuildContext, ScrollController) builder;
  final double collapsedFraction; // 0..1 от доступной высоты
  final double expandedFraction; // 0..1 от доступной высоты

  final Widget? overlay;

  /// Gap between overlay and panel top.
  final double overlayGap;

  const PanelContainer({
    super.key,
    required this.builder,
    this.collapsedFraction = 0.22,
    this.expandedFraction = 0.86,
    this.overlay,
    this.overlayGap = 14,
  }) : assert(
          collapsedFraction > 0 &&
              expandedFraction <= 1 &&
              collapsedFraction < expandedFraction,
          'collapsedFraction < expandedFraction',
        );

  @override
  State<StatefulWidget> createState() => _PanelContainerState();
}

class _PanelContainerState extends State<PanelContainer> {
  final _dss = DraggableScrollableController();
  double _size = 0;

  @override
  void initState() {
    super.initState();
    _size = widget.collapsedFraction;
    _dss.addListener(() {
      final s = _dss.size;
      if (s != _size && mounted) setState(() => _size = s);
    });
  }

  @override
  Widget build(BuildContext context) {
    final min = widget.collapsedFraction;
    final max = widget.expandedFraction;

    // return BlocListener<PanelCubit, PanelMode>(
    //   listenWhen: (p, c) => p != c,
    //   listener: (context, mode) {
    //     _dss.animateTo(
    //       mode == PanelMode.expanded ? max : min,
    //       duration: const Duration(milliseconds: 200),
    //       curve: Curves.easeOut,
    //     );
    //   },
    //   child: DraggableScrollableSheet(
    return LayoutBuilder(
      builder: (context, c) {
        final parentH = c.maxHeight;
        final panelH = parentH * _size; // current height of the sheet

        return Stack(
          fit: StackFit.expand,
          clipBehavior: Clip.none,
          children: [
            DraggableScrollableSheet(
              controller: _dss,
              initialChildSize: min,
              minChildSize: min,
              maxChildSize: max,
              expand: false,
              snap: true,
              snapSizes: [min, max],
              builder: (ctx, scrollController) {
                return _PanelChrome(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      children: [widget.builder(ctx, scrollController)],
                    ),
                  ),
                );
              },
            ),
            if (widget.overlay != null)
              Positioned(
                left: 0,
                right: 0,
                bottom: panelH + widget.overlayGap,
                child: widget.overlay!,
              ),
          ],
        );
      },
    );
    //   ),
    // );
  }
}

class _PanelChrome extends StatelessWidget {
  final Widget child;
  const _PanelChrome({required this.child});

  @override
  Widget build(BuildContext context) {
    final bottom = math.max(12.0, MediaQuery.viewPaddingOf(context).bottom + 8);
    return SafeArea(
      top: false,
      child: Material(
        elevation: 20,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        clipBehavior: Clip.antiAlias,
        child: Container(
          padding: EdgeInsets.fromLTRB(0, 4, 0, bottom),
          decoration: BoxDecoration(color: context.colors.semanticBackground),
          child: Column(
            children: [
              const _GrabHandle(),
              const SizedBox(height: 8),
              Expanded(child: child),
            ],
          ),
        ),
      ),
    );
  }
}

class _GrabHandle extends StatelessWidget {
  const _GrabHandle();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 34,
        height: 4,
        margin: const EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.outlineVariant,
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}
