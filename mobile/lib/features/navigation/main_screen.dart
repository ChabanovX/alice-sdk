part of 'navigation.dart';

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

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(const LoadProfileUserEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _selectedItem.index,
        children: const [
          UiComponentsDemo(),
          MoneyPage(),
          ChatPage(),
          _ProfileTabNavigator(),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedItem: _selectedItem,
        onItemSelected: _onItemSelected,
      ),
    );
  }
}

class _ProfileTabNavigator extends StatelessWidget {
  const _ProfileTabNavigator();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: NavigationManager.navigatorKeyProfilePage,
      onGenerateInitialRoutes: (navigator, initialRouteName) => [
        AppRouter.onGenerateRoute(const RouteSettings(name: Routes.profile)),
      ],
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}

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
