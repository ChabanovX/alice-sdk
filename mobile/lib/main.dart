import 'package:flutter/material.dart';
import 'package:voice_assistant/widgets/orders/order_button.dart';
import 'widgets/action_buttons/slide_action_button_stateless.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text('Slide Action Button States Demo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Заголовок для состояний слайд-кнопки
            const Text(
              'Состояния слайд-кнопки:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            // DefaultStateButton - дефолтное состояние
            const SlideButtonDefaultState(),

            const SizedBox(height: 16),

            // PressedStateButton - состояние при зажатии
            const SlideButtonPressedState(),

            const SizedBox(height: 16),

            // StretchedStateButton - растянутое состояние
            Center(child: const SlideButtonStretchedState()),
          ],
        ),
      ),
    );
  }
}
