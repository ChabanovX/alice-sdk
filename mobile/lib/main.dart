import 'package:flutter/material.dart';
import 'package:voice_assistant/widgets/orders/order_button.dart';
import 'package:voice_assistant/widgets/priority%20and%20orders/orders_widget.dart';
import 'widgets/action_buttons/slide_action_button_stateless.dart';
import 'widgets/orders/order_badge.dart';
import 'widgets/priority and orders/priority_widget.dart';
import 'theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Демонстрация виджетов'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Демонстрация PriorityWidget',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            // Демонстрация с дефолтным значением (52)
            Transform.scale(scale: 2, child: const PriorityWidget()),
            const SizedBox(height: 40),
            Transform.scale(
              scale: 2,
              child: const OrdersWidget(ordersValue: 2, ordersAmount: 150),
            ),
          ],
        ),
      ),
    );
  }
}
