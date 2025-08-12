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

  Widget _buildCurrentScreen() {
    switch (_selectedItem) {
      case BottomNavigationItem.orders:
        return const OrdersPage();
      case BottomNavigationItem.money:
        return const MoneyPage();
      case BottomNavigationItem.chat:
        return const ChatPage();
      case BottomNavigationItem.profile:
        return const _ProfileTabNavigator();
    }
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
      body: _buildCurrentScreen(),
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
    return SubNavigator(
      navigatorKey: NavigationManager.navigatorKeyProfilePage,
      initialRoute: Routes.profile,
    );
  }
}
