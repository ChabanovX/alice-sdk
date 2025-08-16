part of 'manager.dart';

class SubNavigator extends StatelessWidget {
  const SubNavigator({
    super.key,
    required this.navigatorKey,
    required this.initialRoute,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      initialRoute: initialRoute,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
