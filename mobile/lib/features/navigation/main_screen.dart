part of 'navigation.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  BottomNavigationItem _selectedItem = BottomNavigationItem.orders;

  void _onItemSelected(BottomNavigationItem item) {
    setState(() {
      _selectedItem = item;
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(const LoadProfileUserEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _selectedItem.index,
        children: const [
          OrdersPage(),
          MoneyPage(),
          ChatPage(),
          _ProfileTabNavigator(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedItem: _selectedItem,
        onItemSelected: _onItemSelected,
      ),
    );
  }
}

class _ProfileTabNavigator extends StatelessWidget {
  const _ProfileTabNavigator();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: NavigationManager.navigatorKeyProfilePage,
      onGenerateInitialRoutes: (navigator, initialRouteName) => [
        AppRouter.onGenerateRoute(const RouteSettings(name: Routes.profile)),
      ],
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
