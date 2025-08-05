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
    await _audioPlayer.playAudio('assets/audio/1-high_demand.mp3');
  }

  /// Plays the "passenger message" with the given text
  Future<void> playAnswerPassengerMessage(String message) async {
    await _audioPlayer.playAudio('assets/audio/2-passanger_message.mp3');
  }

  /// Plays the "ride wishes" message
  Future<void> playAnswerRideWishes(String wishes) async {
    await _audioPlayer.playAudio('assets/audio/3-wish.mp3');
  }

  /// Plays the "no parking" warning message
  Future<void> playAnswerNoParkingWarning() async {
    await _audioPlayer.playAudio('assets/audio/4-warning.mp3');
  }

  /// Plays the "message sent" confirmation
  Future<void> playAnswerMessageSent() async {
    await _audioPlayer.playAudio('assets/audio/5-message_sent.mp3');
  }

  /// Plays the "connecting to passenger" message
  Future<void> playAnswerConnectingToPassenger() async {
    await _audioPlayer.playAudio('assets/audio/6-connect.mp3');
  }

  /// Plays the "route built" message with time and distance
  Future<void> playAnswerRouteBuilt(String time, String distance) async {
    await _audioPlayer.playAudio('assets/audio/7-path_made.mp3');
  }

  /// Plays the "route rejected" message
  Future<void> playAnswerRouteRejected() async {
    await _audioPlayer.playAudio('assets/audio/8-path_declined .mp3');
  }

  /// Plays the "business mode activated" message with commission
  Future<void> playAnswerBusinessModeActivated(String commission) async {
    await _audioPlayer.playAudio('assets/audio/9-work_mode.mp3');
  }

  /// Plays the "searching orders" message with destination
  Future<void> playAnswerSearchingOrders(String destination) async {
    await _audioPlayer.playAudio('assets/audio/10-available_paths.mp3');
  }

  /// Plays the "going home" message with address
  Future<void> playAnswerGoingHome(String address) async {
    await _audioPlayer.playAudio('assets/audio/11-address.mp3');
  }

  /// Plays the "home mode limit" warning
  Future<void> playAnswerHomeModeLimit() async {
    await _audioPlayer.playAudio('assets/audio/12-work_mode_unavailable.mp3');
  }

  /// Plays the "home address missing" message
  Future<void> playAnswerHomeAddressMissing() async {
    await _audioPlayer.playAudio('assets/audio/13-address-unavailable.mp3');
  }

  /// Plays the "POI found" message
  Future<void> playAnswerPOIFound(String poi, String distance, String direction) async {
    await _audioPlayer.playAudio('assets/audio/14-fuel-station.mp3');
  }

  /// Plays the "tariff changed" message
  Future<void> playAnswerTariffChanged(String tariff, bool isEnabled, List<String> availableTariffs) async {
    await _audioPlayer.playAudio('assets/audio/15-available_tariffs.mp3');
  }

  /// Plays the "command not recognized" message
  Future<void> playAnswerCommandNotRecognized() async {
    await _audioPlayer.playAudio('assets/audio/16-error.mp3');
  }

  /// Plays the "order cancelled" message
  Future<void> playAnswerOrderCancelled() async {
    await _audioPlayer.playAudio('assets/audio/17-order_declined.mp3');
  }

  /// Plays the "order completed" message
  Future<void> playAnswerOrderCompleted() async {
    await _audioPlayer.playAudio('assets/audio/18-order_finished.mp3');
  }

  /// Plays the "new order" message
  Future<void> playAnswerNewOrder() async {
    await _audioPlayer.playAudio('assets/audio/19-new_order.mp3');
  }

  /// Stops all playback
  Future<void> stop() async {
    await _tts.stop();
    await _audioPlayer.dispose();
  }

  /// Releases resources
  Future<void> dispose() async {
    await stop();
    await _audioPlayer.dispose();
  }
}