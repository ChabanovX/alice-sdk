part of 'manager.dart';

/// Перечисления для способов анимации при открытии страницы
enum DirectionOpeningPage {
  vertically(Offset(0.0, 1.0), Offset.zero),
  horizontally(Offset(1.0, 0.0), Offset.zero);

  final Offset begin;
  final Offset end;

  const DirectionOpeningPage(this.begin, this.end);
}

class StoriesArgs {
  StoriesArgs({required this.startIndex});
  final int startIndex;
}

class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    /// Страница, которую требуется открыть
    Widget widget;
    const isVerticalDirectionOpeningPage = true;

    /// Открыть страницу с помощью [CupertinoPageRoute]
    const isCupertinoPageRoute = true;

    switch (settings.name) {
      case Routes.main:
        widget = const MainScreen();
        break;
      case Routes.profile:
        widget = const ProfilePage();
        break;
      case Routes.settings:
        widget = const SettingsPage();
        break;
      case Routes.detailedVoiceSettings:
        widget = const DetailedVoiceSettingsPage();
        break;
      case Routes.stories:
        final arg = settings.arguments as StoriesArgs?;
        widget = StoriesPage(slideCount: 4, startIndex: arg?.startIndex ?? 0,);
        break;
      case Routes.orders:
        widget = BlocProvider(
            create: (context) => OrdersBloc(const Offline()),
            child: const OrdersPage(),
          );
        break;
      /// Ошибка
      default:
        widget = Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Text('Ошибка ${settings.name}'),
          ),
        );
        break;
    }

    if (Platform.isIOS && isCupertinoPageRoute) {
      return CupertinoPageRoute(
        builder: (BuildContext context) {
          return widget;
        },
        settings: settings,
      );
    } else {
      return PageRouteBuilder<Widget>(
        pageBuilder: (context, animation, secondaryAnimation) {
          return widget;
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const physic = isVerticalDirectionOpeningPage
              ? DirectionOpeningPage.vertically
              // ignore: dead_code
              : DirectionOpeningPage.horizontally;
          final tween = Tween(begin: physic.begin, end: physic.end);
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        settings: settings,
      );
    }
  }
}
