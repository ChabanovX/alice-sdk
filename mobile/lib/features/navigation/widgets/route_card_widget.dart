import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../theme.dart';

class RouteCardWidget extends StatelessWidget {
  const RouteCardWidget({
    super.key,
    required this.routes,
    this.selectedIndex = 0,
    this.onRouteSelected,
  });

  final List<RouteOption> routes;
  final int selectedIndex;
  final ValueChanged<int>? onRouteSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        routes.length,
        (index) => Padding(
          padding: EdgeInsets.only(
            left: index > 0 ? 8 : 0,
          ),
          child: _RouteCard(
            route: routes[index],
            isSelected: index == selectedIndex,
            onTap: () => onRouteSelected?.call(index),
          ),
        ),
      ),
    );
  }
}

class _RouteCard extends StatefulWidget {
  const _RouteCard({
    required this.route,
    required this.isSelected,
    required this.onTap,
  });

  final RouteOption route;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_RouteCard> createState() => _RouteCardState();
}

class _RouteCardState extends State<_RouteCard>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _fadeController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 180),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.94,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        _animationController.forward();
        HapticFeedback.mediumImpact();
      },
      onTapUp: (_) {
        _animationController.reverse();
        if (widget.isSelected) {
          _fadeController.forward();
        } else {
          _fadeController.reverse();
        }
        widget.onTap();
      },
      onTapCancel: () {
        _animationController.reverse();
      },
              child: AnimatedBuilder(
          animation: Listenable.merge([_scaleAnimation, _fadeAnimation]),
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 96,
                height: 62,
                decoration: BoxDecoration(
                  color: widget.isSelected 
                      ? context.colors.semanticControlMiror
                      : context.colors.semanticBackground,
                  borderRadius: BorderRadius.circular(16),
                  border: widget.isSelected 
                      ? null
                      : Border.all(
                          color: context.colors.semanticLine,
                          width: 1,
                        ),
                ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.route.duration,
                    style: context.textStyles.medium.copyWith(
                      color: const Color(0xFF21201F),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.route.distance,
                    style: context.textStyles.medium.copyWith(
                      color: const Color(0x9921201F),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class RouteOption {
  const RouteOption({
    required this.duration,
    required this.distance,
  });

  final String duration;
  final String distance;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RouteOption &&
        other.duration == duration &&
        other.distance == distance;
  }

  @override
  int get hashCode => duration.hashCode ^ distance.hashCode;
}
