import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_observer.dart';
import 'features/orders/presentation/ui/ui.dart';

void main() {
  Bloc.observer = AppBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      themeMode: ThemeMode.system,
      home: const MainScreen(),
    );
  }
}

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
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Экран Заказы',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 50),
              Center(
                child: Image.asset(
                  'assets/icons/user_avatar.png',
                  width: 24,
                  height: 24,
                ),
              ),
            ],
          ),
        );
      case BottomNavigationItem.money:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Экран Деньги',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Icon(
                Icons.account_balance_wallet,
                size: 64,
                color: Colors.green,
              ),
            ],
          ),
        );
      case BottomNavigationItem.chat:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Экран Общение',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Icon(Icons.chat_bubble, size: 64, color: Colors.blue),
            ],
          ),
        );
      case BottomNavigationItem.profile:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Экран Профиль',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const Icon(Icons.person, size: 64, color: Colors.orange),
            ],
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(_getAppBarTitle()),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _buildCurrentScreen(),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedItem: _selectedItem,
        onItemSelected: _onItemSelected,
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_selectedItem) {
      case BottomNavigationItem.orders:
        return 'Заказы';
      case BottomNavigationItem.money:
        return 'Деньги';
      case BottomNavigationItem.chat:
        return 'Общение';
      case BottomNavigationItem.profile:
        return 'Профиль';
    }
  }
}
