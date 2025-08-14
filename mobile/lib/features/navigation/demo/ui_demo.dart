
import 'package:flutter/material.dart';

import '../../../core/services/alice_command_recognize_service.dart';
import '../../../widgets/buttons/buttons.dart';
import '../../../widgets/message_notification/message_notification.dart';
import '../../../widgets/road_tracker/road_tracker.dart';

/// Для демонстрации компонентов
class UiComponentsDemo extends StatefulWidget {
  const UiComponentsDemo({super.key});

  @override
  State<UiComponentsDemo> createState() => _UiComponentsDemoState();
}

class _UiComponentsDemoState extends State<UiComponentsDemo> {
  final AliceCommandRecognizeService _aliceService =
      AliceCommandRecognizeService();
  bool _isListening = false;
  String _status = 'Остановлен';

  @override
  void initState() {
    super.initState();
    _initAlice();
  }

  Future<void> _initAlice() async {
    await _aliceService.init();
    _aliceService.testStream.listen((command) {
      setState(() {
        _status = 'Отправлено: ${command.length} символов';
      });
    });
  }

  void _toggleListening() {
    if (_isListening) {
      _aliceService.stopListening();
      setState(() {
        _isListening = false;
        _status = 'Остановлен';
      });
    } else {
      _aliceService.startListening();
      setState(() {
        _isListening = true;
        _status = 'Слушаю...';
      });
    }
  }

  @override
  void dispose() {
    _aliceService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text('Alice Voice Demo',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Статус: $_status'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _toggleListening,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isListening ? Colors.red : Colors.green,
                    ),
                    child: Text(_isListening ? 'Остановить' : 'Начать слушать'),
                  ),
                ],
              ),
            ),
            MessageNotification(
                message: 'Message Notification pressed', onTap: () {}),
            EndTaxiRideButton(
              onSlideComplete: () {
                print('SlideAnim completed');
              },
            ),
            const SizedBox(
              height: 20,
            ),
            EndTaxiRideButtonWithoutAnim(
              onSlideComplete: () {
                print('SlideNoAnim completed');
              },
            ),
            const SizedBox(
              height: 20,
            ),
            const RoadTracker(
              timeWhenEnd: '17:12',
              timeRemain: '12 мин',
              roadLength: '1,5 км',
            ),
          ],
        ),
      ),
    );
  }
}