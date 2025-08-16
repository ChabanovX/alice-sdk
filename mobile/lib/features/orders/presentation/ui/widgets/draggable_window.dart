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
    this.snap = true,
    this.paintGrabber = true,
    this.childPinned,
    this.overlayWidget,
    this.shitWidget,
  });

  final Widget Function(BuildContext, ScrollController) innerWidgetBuilder;

  /// Widget pinned at the bottom.
  final Widget? childPinned;

  /// Widget that renders above the window.
  final Widget? overlayWidget;

  /// Widget that hides in expanded state.
  final Widget? shitWidget;

  /// Whether to snap instantly after dragging.
  final bool snap;

  /// Whether to paint [GrabHandle].
  final bool paintGrabber;

  /// Gap between overlay and panel top.
  final double overlayGap;

  /// Specify minExpansion beforehand if minHeight in pixels is known.
  final double minVisibleHeight;

  /// Specify maxExpansion beforehand if maxHeight in pixels is known.
  final double maxVisibleHeight;

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

  double? collapsedH;
  double? expandedH;

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

  Widget _buildScrollableSheet(
    ScrollController controller,
  ) {
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
          if (widget.paintGrabber)
            const GrabHandle()
          else
            const SizedBox(height: 10),
          widget.innerWidgetBuilder(context, controller),
        ],
      ),
    );

    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            controller: controller,
            physics: const ClampingScrollPhysics(),
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: box,
              ),
            ],
          ),
        ),
        if (widget.childPinned != null)
          SafeArea(
            top: false,
            child: widget.childPinned!,
          ),
      ],
    );
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
          fit: StackFit.expand,
          clipBehavior: Clip.none,
          children: [
            DraggableScrollableSheet(
              controller: _dss,
              initialChildSize: _currentSizeFraction,
              minChildSize: min,
              maxChildSize: max,
              snap: widget.snap,
              snapSizes: _snapSizes,
              builder: (ctx, scrollController) {
                return _buildScrollableSheet(scrollController);
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

typedef SizeChanged = void Function(Size size);

class MeasureSize extends SingleChildRenderObjectWidget {
  const MeasureSize({super.key, required this.onChange, required super.child});
  final SizeChanged onChange;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderMeasureSize(onChange);

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderMeasureSize renderObject,
  ) {
    renderObject.onChange = onChange;
  }
}

class _RenderMeasureSize extends RenderProxyBox {
  _RenderMeasureSize(this.onChange);
  SizeChanged onChange;
  Size? _oldSize;

  @override
  void performLayout() {
    super.performLayout();
    if (size != _oldSize) {
      _oldSize = size;
      WidgetsBinding.instance.addPostFrameCallback((_) => onChange(size));
    }
  }
}
