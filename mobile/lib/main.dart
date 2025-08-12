import 'package:flutter/material.dart';
import 'package:voice_assistant/widgets/icons/turn_right_icon_widget.dart';
import 'package:voice_assistant/widgets/orders/order_button.dart';
import 'package:voice_assistant/widgets/priority%20and%20orders/orders_widget.dart';
import 'package:voice_assistant/widgets/widgets.dart';
import 'widgets/action_buttons/slide_action_button_stateless.dart';
import 'widgets/orders/order_badge.dart';
import 'widgets/priority and orders/priority_widget.dart';
import 'widgets/priority and orders/priority_and_orders_widget.dart';
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
      backgroundColor: Colors.white,
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
            Center(
              child: Transform.scale(
                scale: 2,
                child: SkipActivityWidget(activityValue: 6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
