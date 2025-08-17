import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../theme.dart';
import 'icon_spot_widget.dart';
import 'aspects_widget.dart';
import 'control_button_widget.dart';
import 'route_card_widget.dart';
import 'coupon_widget.dart';

class NavigationBottomSheetWidget extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    if (isSecondState) {
      return SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
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
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/IconSpot.svg',
                      width: 32,
                      height: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        address,
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
                    aspects: aspects,
                    showDivider: false,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: RouteCardWidget(
                  routes: const [
                    RouteOption(duration: '15 мин', distance: '14 км'),
                    RouteOption(duration: '17 мин', distance: '12,6 км'),
                    RouteOption(duration: '18 мин', distance: '16 км'),
                  ],
                  selectedIndex: 0,
                  onRouteSelected: (index) => print('Выбран маршрут $index'),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Container(
                  width: double.infinity,
                  child: ControlButtonWidget(
                    text: buttonText,
                    onTap: onButtonTap,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (isThirdState) {
      return SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
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
                                title,
                                style: context.textStyles.boldMedium.copyWith(
                                  color: context.colors.text,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                address,
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
                          onTap: onNavigateTap,
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
                          onTap: onBookmarkTap,
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
                    aspects: aspects,
                    showDivider: false,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 16, left: 12, right: 12),
                child: CouponWidget(
                  title: 'Домой без доп. комиссии',
                  description: 'Осталось 1 из 2 применений, обновляется раз в сутки',
                  isEnabled: false,
                  onToggle: (value) => print('Купон ${value ? 'включен' : 'выключен'}'),
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
                    text: buttonText,
                    onTap: onButtonTap,
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
              color: Colors.black.withOpacity(0.12),
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
                                title,
                                style: context.textStyles.boldMedium.copyWith(
                                  color: context.colors.text,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                address,
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
                          onTap: onNavigateTap,
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
                          onTap: onBookmarkTap,
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
                  aspects: aspects,
                  showDivider: false,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Container(
                width: double.infinity,
                child: ControlButtonWidget(
                  text: buttonText,
                  onTap: onButtonTap,
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}
