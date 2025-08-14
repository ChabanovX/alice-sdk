part of '../ui.dart';

/// Window at the bottom of the screen.
///
/// Can contain widgets inside and outside (above the window).
/// You can control maxHeight/minHeight by specifying [minVisibleHeight] and
/// [maxVisibleHeight].
class DraggableWindow extends StatefulWidget {
  const DraggableWindow({
    super.key,
    required this.innerWidgetBuilder,
    this.minVisibleHeight = 100,
    this.maxVisibleHeight = 200,
    this.overlayGap = 14,
    this.overlayWidget,
  });

  /// Gap between overlay and panel top.
  final double overlayGap;

  /// Builder for widget inside the window.
  final Widget Function(BuildContext, ScrollController) innerWidgetBuilder;

  /// Specify minExpansion beforehand if minHeight in pixels is known.
  final double minVisibleHeight;

  /// Specify maxExpansion beforehand if maxHeight in pixels is known.
  final double maxVisibleHeight;

  /// Widget that renders above the window.
  final Widget? overlayWidget;

  @override
  State<StatefulWidget> createState() => _DraggableWindowState();
}

class _DraggableWindowState extends State<DraggableWindow> {
  late final DraggableScrollableController _dss;

  /// Tracks fraction of screen that sheet occupies at the moment.
  ///
  /// Will be calculated in build method.
  double _currentSizeFraction = 0;

  /// Cash [min, max] sizes during build method and cache them.
  ///
  /// Only on build stage we might calculate height fractions.
  /// `0` - means uninitialized, which is logical, since snap could not be `0`.
  final List<double> _snapSizes = [0, 0];

  @override
  void initState() {
    super.initState();
    _dss = DraggableScrollableController();

    _dss.addListener(() {
      final s = _dss.size;
      if (s != _currentSizeFraction && mounted) {
        setState(() => _currentSizeFraction = s);
      }
    });
  }

  @override
  void dispose() {
    _dss.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final parentH = c.maxHeight;

        // Compute min based on layout.
        final min = widget.minVisibleHeight / parentH;
        final max = widget.maxVisibleHeight / parentH;

        // Check whether to update cache.
        final isMinNeedsChange = _snapSizes[0] == 0 || (_snapSizes[0] != min);
        final isMaxNeedsChanged = _snapSizes[1] == 0 || (_snapSizes[1] != max);

        // Update cache.
        if (isMinNeedsChange || isMaxNeedsChanged) {
          _snapSizes[0] = min;
          _snapSizes[1] = max;

          final clamped = _currentSizeFraction.clamp(min, max);
          if (clamped != _currentSizeFraction) {
            _currentSizeFraction = clamped;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _dss.jumpTo(clamped);
            });
          }
        }

        final panelH = parentH * _currentSizeFraction;

        return Stack(
          // Allows registering clicks outside non-positioned.
          fit: StackFit.expand,
          clipBehavior: Clip.none, // Shows positioned outside.
          children: [
            DraggableScrollableSheet(
              controller: _dss,
              initialChildSize: _currentSizeFraction,
              minChildSize: min,
              maxChildSize: max,
              snap: true,
              snapSizes: _snapSizes,
              builder: (ctx, scrollController) {
                return _ScrollableSheet(
                  controller: scrollController,
                  child: widget.innerWidgetBuilder(ctx, scrollController),
                );
              },
            ),
            if (widget.overlayWidget != null)
              Positioned(
                left: 0,
                right: 0,
                bottom: panelH + widget.overlayGap,
                child: widget.overlayWidget!,
              ),
          ],
        );
      },
    );
  }
}

class _ScrollableSheet extends StatelessWidget {
  const _ScrollableSheet({required this.child, required this.controller});

  /// Widget to render below grabber.
  final Widget child;

  /// Allows to sync inner and outer scrolls.
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadiusDirectional.vertical(
      top: Radius.circular(24),
    );

    final box = DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: borderRadius,
      ),
      child: Column(
        children: [
          const SizedBox(height: 4),
          const GrabHandle(),
          child,
        ],
      ),
    );

    return CustomScrollView(
      controller: controller,
      physics: const ClampingScrollPhysics(),
      slivers: [
        SliverFillRemaining(hasScrollBody: false, child: box),
      ],
    );
  }
}
