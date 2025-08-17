import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_observer.dart';
import 'core/navigation/manager.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';
import 'features/navigation/widgets/aspects_widget.dart';
import 'features/navigation/widgets/icon_spot_widget.dart';
import 'features/navigation/widgets/route_card_widget.dart';
import 'features/navigation/widgets/coupon_widget.dart';
import 'features/navigation/widgets/navigation_bottom_sheet_widget.dart';
import 'features/navigation/widgets/bottom_sheet_back_button_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'theme.dart';

// Закомментируйте эту строку, чтобы вернуть исходное приложение
const bool showWidgetsShowcase = true;
const bool showBottomSheet = true;

void main() {
  Bloc.observer = AppBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(const ProfileInitialState()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: AppRouter.onGenerateRoute,
        navigatorKey: NavigationManager.navigatorKey,
        initialRoute: showWidgetsShowcase ? '/showcase' : Routes.main,
        theme: lightTheme,
        routes: showWidgetsShowcase ? {
          '/showcase': (context) => showBottomSheet 
              ? const NavigationBottomSheetShowcase()
              : const NavigatorWidgetsShowcase(),
        } : const {},
      ),
    );
  }
}

class NavigatorWidgetsShowcase extends StatefulWidget {
  const NavigatorWidgetsShowcase({super.key});

  @override
  State<NavigatorWidgetsShowcase> createState() => _NavigatorWidgetsShowcaseState();
}

class _NavigatorWidgetsShowcaseState extends State<NavigatorWidgetsShowcase> {
  bool couponEnabled = true;
  int selectedRouteIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigator Widgets Showcase'),
        backgroundColor: context.colors.semanticBackground,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AspectsWidget',
              style: context.textStyles.title,
            ),
            const SizedBox(height: 16),
            const AspectsWidget(
              aspects: [
                AspectItem(text: 'Комиссия +4%', isCommission: true),
                AspectItem(text: 'Открытая точка Б'),
                AspectItem(text: 'Не действуют бонусы'),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'IconSpotWidget',
              style: context.textStyles.title,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
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
                  onTap: () => print('Нажата кнопка поворота'),
                ),
                const SizedBox(width: 16),
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
                  onTap: () => print('Нажата кнопка закладки'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'RouteCardWidget',
              style: context.textStyles.title,
            ),
            const SizedBox(height: 16),
            RouteCardWidget(
              routes: const [
                RouteOption(duration: '15 мин', distance: '14 км'),
                RouteOption(duration: '17 мин', distance: '12,6 км'),
                RouteOption(duration: '18 мин', distance: '16 км'),
              ],
              selectedIndex: selectedRouteIndex,
              onRouteSelected: (index) => setState(() => selectedRouteIndex = index),
            ),
            const SizedBox(height: 32),
            Text(
              'CouponWidget',
              style: context.textStyles.title,
            ),
            const SizedBox(height: 16),
            CouponWidget(
              title: 'Домой без доп. комиссии',
              description: 'Описание купона',
              isEnabled: couponEnabled,
              onToggle: (value) => setState(() => couponEnabled = value),
              remainingUses: 1,
              totalUses: 2,
              updateFrequency: 'обновляется раз в сутки',
            ),
          ],
        ),
      ),
    );
  }
}

class NavigationBottomSheetShowcase extends StatefulWidget {
  const NavigationBottomSheetShowcase({super.key});

  @override
  State<NavigationBottomSheetShowcase> createState() => _NavigationBottomSheetShowcaseState();
}

class _NavigationBottomSheetShowcaseState extends State<NavigationBottomSheetShowcase> {
  int selectedRouteIndex = 0;
  
  final List<RouteOption> routes = const [
    RouteOption(duration: '15 мин', distance: '14 км'),
    RouteOption(duration: '17 мин', distance: '12,6 км'),
    RouteOption(duration: '18 мин', distance: '16 км'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Navigation Bottom Sheet Demo'),
            const SizedBox(height: 20),
                        ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => NavigationBottomSheetWidget(
                    title: 'Проводник',
                    address: 'проспект Ленина, 51',
                    aspects: const [
                      AspectItem(text: 'Комиссия +4%', isCommission: true),
                      AspectItem(text: 'Открытая точка Б'),
                      AspectItem(text: 'Не действуют бонусы'),
                    ],
                    buttonText: 'Поехать с заказами по пути',
                    onNavigateTap: null,
                    onBookmarkTap: null,
                    onButtonTap: null,
                    routes: routes,
                    selectedRouteIndex: selectedRouteIndex,
                    onRouteSelected: (index) => setState(() => selectedRouteIndex = index),
                  ),
                );
              },
              child: const Text('Показать Bottom Sheet (Состояние 1)'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => NavigationBottomSheetWidget(
                    title: 'Проводник',
                    address: 'проспект Ленина, 51',
                    aspects: const [
                      AspectItem(text: 'Комиссия +4%', isCommission: true),
                      AspectItem(text: 'Открытая точка Б'),
                      AspectItem(text: 'Не действуют бонусы'),
                    ],
                    buttonText: 'Поехали',
                    isSecondState: true,
                    onNavigateTap: null,
                    onBookmarkTap: null,
                    onButtonTap: null,
                    routes: routes,
                    selectedRouteIndex: selectedRouteIndex,
                    onRouteSelected: (index) => setState(() => selectedRouteIndex = index),
                  ),
                );
              },
              child: const Text('Показать Bottom Sheet (Состояние 3)'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => NavigationBottomSheetWidget(
                    title: 'Проводник',
                    address: 'проспект Ленина, 51',
                    aspects: const [
                      AspectItem(text: 'Комиссия +4%', isCommission: true),
                      AspectItem(text: 'Открытая точка Б'),
                      AspectItem(text: 'Не действуют бонусы'),
                    ],
                    buttonText: 'Поехать с заказами по пути',
                    isThirdState: true,
                    onNavigateTap: null,
                    onBookmarkTap: null,
                    onButtonTap: null,
                    routes: routes,
                    selectedRouteIndex: selectedRouteIndex,
                    onRouteSelected: (index) => setState(() => selectedRouteIndex = index),
                  ),
                );
              },
              child: const Text('Показать Bottom Sheet (Состояние 2)'),
            ),
          ],
        ),
      ),
    );
  }
}
