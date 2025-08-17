import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../theme.dart';
import 'icon_spot_widget.dart';
import 'aspects_widget.dart';
import 'control_button_widget.dart';
import 'route_card_widget.dart';
import 'coupon_widget.dart';

class NavigationBottomSheetWidget extends StatefulWidget {
  const NavigationBottomSheetWidget({
    super.key,
    required this.title,
    required this.address,
    required this.aspects,
    required this.buttonText,
    this.onNavigateTap,
    this.onBookmarkTap,
    this.onButtonTap,
    this.isSecondState = false,
    this.isThirdState = false,
    this.routes,
    this.selectedRouteIndex,
    this.onRouteSelected,
    this.onCouponSelected,
  });

  final String title;
  final String address;
  final List<AspectItem> aspects;
  final String buttonText;
  final VoidCallback? onNavigateTap;
  final VoidCallback? onBookmarkTap;
  final VoidCallback? onButtonTap;
  final bool isSecondState;
  final bool isThirdState;
  final List<RouteOption>? routes;
  final int? selectedRouteIndex;
  final Function(int)? onRouteSelected;
  final Function(bool)? onCouponSelected;

  @override
  State<NavigationBottomSheetWidget> createState() => _NavigationBottomSheetWidgetState();
}

class _NavigationBottomSheetWidgetState extends State<NavigationBottomSheetWidget> {
  int _selectedRouteIndex = 0;
  bool _couponEnabled = false;

  @override
  void initState() {
    super.initState();
    _selectedRouteIndex = widget.selectedRouteIndex ?? 0;
  }

  @override
  void didUpdateWidget(NavigationBottomSheetWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedRouteIndex != oldWidget.selectedRouteIndex) {
      setState(() {
        _selectedRouteIndex = widget.selectedRouteIndex ?? 0;
      });
    }
  }

  void _onRouteSelected(int index) {
    setState(() {
      _selectedRouteIndex = index;
    });
    widget.onRouteSelected?.call(index);
  }

  void _onCouponToggle(bool value) {
    setState(() {
      _couponEnabled = value;
    });
    widget.onCouponSelected?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isSecondState) {
      return SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                offset: const Offset(0, -4),
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/IconSpot.svg',
                      width: 32,
                      height: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child:                         Text(
                          widget.address,
                          style: context.textStyles.medium.copyWith(
                            color: context.colors.text,
                          ),
                        ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 16, left: 12, right: 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AspectsWidget(
                    aspects: widget.aspects,
                    showDivider: false,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: RouteCardWidget(
                  routes: widget.routes ?? const [
                    RouteOption(duration: '15 мин', distance: '14 км'),
                    RouteOption(duration: '17 мин', distance: '12,6 км'),
                    RouteOption(duration: '18 мин', distance: '16 км'),
                  ],
                  selectedIndex: _selectedRouteIndex,
                  onRouteSelected: _onRouteSelected,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Container(
                  width: double.infinity,
                  child: ControlButtonWidget(
                    text: widget.buttonText,
                    onTap: widget.onButtonTap,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (widget.isThirdState) {
      return SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.12),
                offset: const Offset(0, -4),
                blurRadius: 20,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.title,
                                style: context.textStyles.boldMedium.copyWith(
                                  color: context.colors.text,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.address,
                                style: context.textStyles.regular.copyWith(
                                  color: context.colors.text,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        IconSpotWidget(
                          icon: SvgPicture.asset(
                            'assets/icons/ExternalNavigator.svg',
                            width: 24,
                            height: 24,
                            colorFilter: const ColorFilter.mode(
                              Colors.black,
                              BlendMode.srcIn,
                            ),
                          ),
                          onTap: widget.onNavigateTap,
                        ),
                        const SizedBox(width: 8),
                        IconSpotWidget(
                          icon: SvgPicture.asset(
                            'assets/icons/bookmark_add_outlined.svg',
                            width: 24,
                            height: 24,
                            colorFilter: const ColorFilter.mode(
                              Colors.black,
                              BlendMode.srcIn,
                            ),
                          ),
                          onTap: widget.onBookmarkTap,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Divider(
                      color: context.colors.semanticLine,
                      thickness: 0.5,
                      height: 1,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 16, left: 24, right: 24),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AspectsWidget(
                    aspects: widget.aspects,
                    showDivider: false,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 16, left: 12, right: 12),
                child: CouponWidget(
                  title: 'Домой без доп. комиссии',
                  description: 'Осталось 1 из 2 применений, обновляется раз в сутки',
                  isEnabled: _couponEnabled,
                  onToggle: _onCouponToggle,
                  remainingUses: 1,
                  totalUses: 2,
                  updateFrequency: 'обновляется раз в сутки',
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Container(
                  width: double.infinity,
                  child: ControlButtonWidget(
                    text: widget.buttonText,
                    onTap: widget.onButtonTap,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              offset: const Offset(0, -4),
              blurRadius: 20,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
                          Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.title,
                                style: context.textStyles.boldMedium.copyWith(
                                  color: context.colors.text,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.address,
                                style: context.textStyles.regular.copyWith(
                                  color: context.colors.text,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        IconSpotWidget(
                          icon: SvgPicture.asset(
                            'assets/icons/ExternalNavigator.svg',
                            width: 24,
                            height: 24,
                            colorFilter: const ColorFilter.mode(
                              Colors.black,
                              BlendMode.srcIn,
                            ),
                          ),
                          onTap: widget.onNavigateTap,
                        ),
                        const SizedBox(width: 8),
                        IconSpotWidget(
                          icon: SvgPicture.asset(
                            'assets/icons/bookmark_add_outlined.svg',
                            width: 24,
                            height: 24,
                            colorFilter: const ColorFilter.mode(
                              Colors.black,
                              BlendMode.srcIn,
                            ),
                          ),
                          onTap: widget.onBookmarkTap,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Divider(
                      color: context.colors.semanticLine,
                      thickness: 0.5,
                      height: 1,
                    ),
                  ],
                ),
              ),
            Container(
              padding: const EdgeInsets.only(bottom: 16, left: 24, right: 24),
              child: Align(
                alignment: Alignment.centerLeft,
                                  child: AspectsWidget(
                    aspects: widget.aspects,
                    showDivider: false,
                  ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Container(
                width: double.infinity,
                                  child: ControlButtonWidget(
                    text: widget.buttonText,
                    onTap: widget.onButtonTap,
                  ),
              ),
            ),
          ],
        )
      ),
    );
  }
}
