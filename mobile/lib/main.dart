import 'package:flutter/material.dart';
import 'widgets/widgets.dart';
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
      home: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text('Passenger Stop Widget Demo'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.scale(scale: 1.0, child: const PassengerStopWidget1()),
              const SizedBox(height: 50),
              Transform.scale(
                scale: 1.0,
                child: const PassengerStopWidget2(
                  pointAdress: 'Льва Толстого, 16',
                  timeOfSubmission: '7 мин',
                ),
              ),
              const SizedBox(height: 100),
              Transform.scale(
                scale: 2.0,
                child: const PassengerStopWidget3(
                  pointDistance: '1,2 км',
                  timeOnWay: '5 мин',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
