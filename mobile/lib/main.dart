import 'package:flutter/material.dart';
import 'widgets/widgets.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text('Passenger Stop Widget Demo'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: Transform.scale(
            scale: 3.0,
            child: const PassengerStopWidget1(),
          ),
        ),
      ),
    );
  }
}
