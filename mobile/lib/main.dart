import 'package:flutter/material.dart';
import 'widgets/action_buttons/slide_action_button.dart';
import 'widgets/orders/order_badge.dart';
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
  final GlobalKey _slideButtonKey = GlobalKey();

  void _resetSlideButton() {
    SlideActionButton.reset(_slideButtonKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Slide Action Button Demo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 16),

            // OrderBadge с масштабом 5
            Center(
              child: Transform.scale(
                scale: 7.0,
                child: const OrderBadge(count: 1),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
