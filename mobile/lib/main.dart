import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:voice_assistant/widgets/buttons/buttons.dart';
import 'package:voice_assistant/widgets/message_notification/message_notification.dart';
import 'package:voice_assistant/widgets/orders/order_button.dart';
import 'package:voice_assistant/widgets/road_tracker/road_tracker.dart';
import 'widgets/action_buttons/slide_action_button.dart';
import 'package:voice_assistant/widgets/widgets.dart';
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
        title: const Text('Slide Action Button Demo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          MessageNotification(message: 'Message Notification pressed', onTap: () {}),
          EndTaxiRideButton(onSlideComplete: () {print('SlideAnim completed');},),
          SizedBox(height: 20,),
          EndTaxiRideButtonWithoutAnim(onSlideComplete: (){print('SlideNoAnim completed');},),
          SizedBox(height: 20,),
          RoadTracker(timeWhenEnd: '17:12', timeRemain: '12 мин', roadLength: '1,5 км',),
        ],
      ),
    );
  }
}
