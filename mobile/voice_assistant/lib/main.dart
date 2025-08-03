import 'package:flutter/material.dart';
import 'package:voice_assistant/alice_voice.dart';

void main() {
  runApp(const VoiceAssistantDemo());
}

class VoiceAssistantDemo extends StatelessWidget {
  const VoiceAssistantDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _alice = AliceVoiceAssistant();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            SizedBox(height: 100,),
              StreamBuilder<PlaybackState>(
                stream: _alice.playbackState,
                builder: (context, snapshot) {
                  final amplitude = snapshot.data?.amplitude ?? 0;
                  final scale = 1.0 + (amplitude * amplitude) * 0.15;
                  return AnimatedScale(
                    scale: scale,
                    duration: const Duration(milliseconds: 50),
                    curve: Curves.easeInOut,
                    child: Image.asset(
                      'assets/images/alice.png',
                      width: 200,
                      height: 200,
                    ),
                  );
                },
              ),
              const SizedBox(height: 100),
              
          
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      ElevatedButton(
                        onPressed: () => _alice.playAnswerIncreasedDemand(1.5),
                        child: const Text('Повышенный спрос (x1.5)'),
                      ),
                      ElevatedButton(
                        onPressed: () => _alice.playAnswerPassengerMessage('Буду через 5 минут'),
                        child: const Text('Сообщение пассажира'),
                      ),
                      ElevatedButton(
                        onPressed: () => _alice.playAnswerRideWishes('Не разговаривать'),
                        child: const Text('Пожелания к поездке'),
                      ),
                      ElevatedButton(
                        onPressed: () => _alice.playAnswerNoParkingWarning(),
                        child: const Text('Предупреждение о парковке'),
                      ),
                      ElevatedButton(
                        onPressed: () => _alice.playAnswerMessageSent(),
                        child: const Text('Сообщение отправлено'),
                      ),
                      ElevatedButton(
                        onPressed: () => _alice.playAnswerConnectingToPassenger(),
                        child: const Text('Соединяю с пассажиром'),
                      ),
                      ElevatedButton(
                        onPressed: () => _alice.playAnswerRouteBuilt('20 минут', '5 километров'),
                        child: const Text('Маршрут построен'),
                      ),
                      ElevatedButton(
                        onPressed: () => _alice.playAnswerRouteRejected(),
                        child: const Text('Маршрут отклонён'),
                      ),
                      ElevatedButton(
                        onPressed: () => _alice.playAnswerBusinessModeActivated('50'),
                        child: const Text('Режим "По делам" включён'),
                      ),
                      ElevatedButton(
                        onPressed: () => _alice.playAnswerSearchingOrders('Проспект Мира'),
                        child: const Text('Поиск заказов'),
                      ),
                      ElevatedButton(
                        onPressed: () => _alice.playAnswerGoingHome('Улица Пушкина, дом Колотушкина'),
                        child: const Text('Едем домой'),
                      ),
                      ElevatedButton(
                        onPressed: () => _alice.playAnswerHomeModeLimit(),
                        child: const Text('Лимит режима "Домой"'),
                      ),
                      ElevatedButton(
                        onPressed: () => _alice.playAnswerHomeAddressMissing(),
                        child: const Text('Адрес дома не указан'),
                      ),
                      ElevatedButton(
                        onPressed: () => _alice.playAnswerPOIFound('Заправка', '500 метров', 'правой стороне'),
                        child: const Text('Найдена точка интереса'),
                      ),
                      ElevatedButton(
                        onPressed: () => _alice.playAnswerTariffChanged(
                          'Эконом',
                          true,
                          ['Эконом', 'Комфорт', 'Бизнес'],
                        ),
                        child: const Text('Смена тарифа'),
                      ),
                      ElevatedButton(
                        onPressed: () => _alice.playAnswerCommandNotRecognized(),
                        child: const Text('Команда не распознана'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _alice.dispose();
    super.dispose();
  }
}