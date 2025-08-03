import 'package:flutter_tts/flutter_tts.dart';

import 'audio/audio_player.dart';
import 'models/playback_state.dart';

/// Main class for the Yandex Alice voice assistant
class AliceVoiceAssistant {
  /// Creates a new instance of the voice assistant
  factory AliceVoiceAssistant() => _instance;
  AliceVoiceAssistant._internal() {
    _init();
  }

  static final AliceVoiceAssistant _instance = AliceVoiceAssistant._internal();

  final _audioPlayer = AliceAudioPlayer();
  final _tts = FlutterTts();
  bool _isInitialized = false;

  /// Stream of playback state changes
  Stream<PlaybackState> get playbackState => _audioPlayer.playbackState;

  Future<void> _init() async {
    if (_isInitialized) return;

    await _tts.setLanguage('ru-RU');
   
    await _tts.setSpeechRate(0.45);

    await _tts.setPitch(0.9);

    await _tts.setVolume(1.0);

    _tts.setStartHandler(() {
      _audioPlayer.setTTSSpeaking(true);
    });

    _tts.setCompletionHandler(() {
      _audioPlayer.setTTSSpeaking(false);
    });

    _tts.setCancelHandler(() {
      _audioPlayer.setTTSSpeaking(false);
    });

    _tts.setErrorHandler((_) {
      _audioPlayer.setTTSSpeaking(false);
    });

    _isInitialized = true;
  }

  /// Plays the "increased demand" message
  Future<void> playAnswerIncreasedDemand(double coefficient) async {
    await _tts.speak('Повышенный спрос, стоимость заказа увеличена в $coefficient раз');
  }

  /// Plays the "passenger message" with the given text
  Future<void> playAnswerPassengerMessage(String message) async {
    await _tts.speak('Пассажир написал: $message');
  }

  /// Plays the "ride wishes" message
  Future<void> playAnswerRideWishes(String wishes) async {
    await _tts.speak('Пожелания к поездке: $wishes');
  }

  /// Plays the "no parking" warning message
  Future<void> playAnswerNoParkingWarning() async {
    await _tts.speak('Внимание, остановка запрещена. Камера. У вас 10 секунд, чтобы покинуть зону');
  }

  /// Plays the "message sent" confirmation
  Future<void> playAnswerMessageSent() async {
    await _tts.speak('Сообщение отправлено');
  }

  /// Plays the "connecting to passenger" message
  Future<void> playAnswerConnectingToPassenger() async {
    await _tts.speak('Соединяю с пассажиром');
  }

  /// Plays the "route built" message with time and distance
  Future<void> playAnswerRouteBuilt(String time, String distance) async {
    await _tts.speak('Маршрут построен. Время в пути $time, расстояние $distance');
  }

  /// Plays the "route rejected" message
  Future<void> playAnswerRouteRejected() async {
    await _tts.speak('Маршрут отклонён. Выберите другой вариант или постройте новый');
  }

  /// Plays the "business mode activated" message with commission
  Future<void> playAnswerBusinessModeActivated(String commission) async {
    await _tts.speak('Режим "По делам" включён. Дополнительная комиссия $commission рублей за заказ');
  }

  /// Plays the "searching orders" message with destination
  Future<void> playAnswerSearchingOrders(String destination) async {
    await _tts.speak('Ищу попутные заказы по пути на $destination');
  }

  /// Plays the "going home" message with address
  Future<void> playAnswerGoingHome(String address) async {
    await _tts.speak('Едем домой: $address. Буду подбирать заказы по пути');
  }

  /// Plays the "home mode limit" warning
  Future<void> playAnswerHomeModeLimit() async {
    await _tts.speak('Вы уже активировали режим "Домой" дважды сегодня. Повторное использование недоступно');
  }

  /// Plays the "home address missing" message
  Future<void> playAnswerHomeAddressMissing() async {
    await _tts.speak('Адрес дома не указан. Назовите адрес, чтобы сохранить его');
  }

  /// Plays the "POI found" message
  Future<void> playAnswerPOIFound(String poi, String distance, String direction) async {
    await _tts.speak('$poi через $distance по $direction. Добавляю в маршрут?');
  }

  /// Plays the "tariff changed" message
  Future<void> playAnswerTariffChanged(String tariff, bool isEnabled, List<String> availableTariffs) async {
    final status = isEnabled ? 'включён' : 'отключён';
    await _tts.speak('Тариф "$tariff" $status. Доступные тарифы: ${availableTariffs.join(", ")}');
  }

  /// Plays the "command not recognized" message
  Future<void> playAnswerCommandNotRecognized() async {
    await _tts.speak('Извините, не расслышала. Повторите команду');
  }

  /// Stops all playback
  Future<void> stop() async {
    await _tts.stop();
  }

  /// Releases resources
  Future<void> dispose() async {
    await stop();
    await _audioPlayer.dispose();
  }
}