import 'dart:async';
import 'dart:collection';

import 'audio/audio_player.dart';
import 'models/audio_message.dart';
import 'models/playback_state.dart';
import 'configuration/alice_configuration.dart';
import 'utils/logger.dart';

/// Main class for the Alice voice assistant
/// 
/// Provides a flexible audio message playback system with queue management,
/// priority handling, and comprehensive state management.
class AliceVoiceAssistant {
  /// Creates a new instance of the voice assistant with optional configuration
  factory AliceVoiceAssistant([AliceConfiguration? config]) {
    _instance ??= AliceVoiceAssistant._internal(config ?? AliceConfiguration.defaultConfig());
    return _instance!;
  }
  
  AliceVoiceAssistant._internal(this._config) {
    _init();
  }

  static AliceVoiceAssistant? _instance;
  
  final AliceConfiguration _config;
  late final AliceAudioPlayer _audioPlayer;
  final _messageQueue = Queue<AudioMessage>();
  final _logger = AliceLogger();
  
  bool _isInitialized = false;
  bool _isProcessingQueue = false;
  AudioMessage? _currentMessage;

  /// Current configuration
  AliceConfiguration get config => _config;
  
  /// Stream of playback state changes
  Stream<PlaybackState> get playbackState => _audioPlayer.playbackState;
  
  /// Current message being played (if any)
  AudioMessage? get currentMessage => _currentMessage;
  
  /// Number of messages in queue
  int get queueLength => _messageQueue.length;
  
  /// Whether the assistant is currently playing audio
  bool get isPlaying => _currentMessage != null;

  Future<void> _init() async {
    if (_isInitialized) return;
    
    try {
      _audioPlayer = AliceAudioPlayer(_config);
      await _audioPlayer.initialize();
      _isInitialized = true;
      _logger.info('AliceVoiceAssistant initialized successfully');
    } catch (e) {
      _logger.error('Failed to initialize AliceVoiceAssistant', e);
      rethrow;
    }
  }

  /// Plays an audio message
  /// 
  /// If [immediate] is true, stops current playback and plays immediately.
  /// Otherwise, adds to queue based on priority.
  Future<void> playMessage(AudioMessage message, {bool immediate = false}) async {
    if (!_isInitialized) {
      await _init();
    }
    
    try {
      if (immediate || message.priority == MessagePriority.high) {
        if (_config.interruptOnHighPriority && _currentMessage != null) {
          _logger.info('Interrupting current message for high priority message');
          await stop();
        }
        await _playMessageNow(message);
      } else {
        _enqueueMessage(message);
        if (_config.autoPlayQueue && !_isProcessingQueue) {
          _processQueue();
        }
      }
    } catch (e) {
      _logger.error('Failed to play message: ${message.assetPath}', e);
      rethrow;
    }
  }

  /// Plays a message from asset path with optional priority
  Future<void> playAudio(String assetPath, {
    MessagePriority priority = MessagePriority.normal,
    String? text,
    bool immediate = false,
  }) async {
    final message = AudioMessage(
      assetPath: assetPath,
      text: text,
      priority: priority,
    );
    await playMessage(message, immediate: immediate);
  }

  void _enqueueMessage(AudioMessage message) {
    if (_messageQueue.length >= _config.maxQueueSize) {
      if (message.priority == MessagePriority.low) {
        _logger.warning('Queue full, dropping low priority message: ${message.assetPath}');
        return;
      }
      // Remove oldest low priority message if possible
      final lowPriorityIndex = _messageQueue.toList().indexWhere(
        (m) => m.priority == MessagePriority.low,
      );
      if (lowPriorityIndex != -1) {
        final removed = _messageQueue.toList()[lowPriorityIndex];
        final queueList = _messageQueue.toList();
        _messageQueue.clear();
        queueList.removeAt(lowPriorityIndex);
        _messageQueue.addAll(queueList);
        _logger.warning('Queue full, removed low priority message: ${removed.assetPath}');
      } else {
        _logger.warning('Queue full, dropping message: ${message.assetPath}');
        return;
      }
    }

    // Insert message based on priority
    final queueList = _messageQueue.toList();
    _messageQueue.clear();
    
    if (message.priority == MessagePriority.high) {
      queueList.insert(0, message);
    } else {
      queueList.add(message);
    }
    
    _messageQueue.addAll(queueList);
    _logger.debug('Message queued: ${message.assetPath} (priority: ${message.priority})');
  }

  Future<void> _processQueue() async {
    if (_isProcessingQueue || _messageQueue.isEmpty) return;
    
    _isProcessingQueue = true;
    
    try {
      while (_messageQueue.isNotEmpty) {
        final message = _messageQueue.removeFirst();
        await _playMessageNow(message);
      }
    } catch (e) {
      _logger.error('Error processing message queue', e);
    } finally {
      _isProcessingQueue = false;
    }
  }

  Future<void> _playMessageNow(AudioMessage message) async {
    try {
      _currentMessage = message;
      _logger.info('Playing message: ${message.assetPath}');
      await _audioPlayer.playAudio(message.assetPath);
      _currentMessage = null;
    } catch (e) {
      _currentMessage = null;
      rethrow;
    }
  }

  /// Sets the volume level (0.0 to 1.0)
  Future<void> setVolume(double volume) async {
    await _audioPlayer.setVolume(volume);
  }

  /// Clears the message queue
  void clearQueue() {
    _messageQueue.clear();
    _logger.info('Message queue cleared');
  }

  /// Stops all playback and clears queue
  Future<void> stop() async {
    await _audioPlayer.stop();
    _currentMessage = null;
    clearQueue();
  }

  /// Resets the singleton instance (useful for testing)
  static void reset() {
    _instance = null;
  }

  /// Releases resources
  Future<void> dispose() async {
    try {
      await stop();
      await _audioPlayer.dispose();
      _logger.info('AliceVoiceAssistant disposed');
    } catch (e) {
      _logger.error('Failed to dispose AliceVoiceAssistant', e);
    }
  }

  // Convenience methods for common taxi app scenarios
  // These maintain backward compatibility while using the new flexible API

  /// Plays the "increased demand" message
  Future<void> playAnswerIncreasedDemand(double coefficient) async {
    await playAudio('assets/audio/1-high_demand.mp3', 
        text: 'High demand (${coefficient}x)');
  }

  /// Plays the "passenger message" with the given text
  Future<void> playAnswerPassengerMessage(String message) async {
    await playAudio('assets/audio/2-passanger_message.mp3', 
        text: 'Passenger message: $message');
  }

  /// Plays the "ride wishes" message
  Future<void> playAnswerRideWishes(String wishes) async {
    await playAudio('assets/audio/3-wish.mp3', 
        text: 'Ride wishes: $wishes');
  }

  /// Plays the "no parking" warning message
  Future<void> playAnswerNoParkingWarning() async {
    await playAudio('assets/audio/4-warning.mp3', 
        priority: MessagePriority.high,
        text: 'No parking warning');
  }

  /// Plays the "message sent" confirmation
  Future<void> playAnswerMessageSent() async {
    await playAudio('assets/audio/5-message_sent.mp3', 
        text: 'Message sent');
  }

  /// Plays the "connecting to passenger" message
  Future<void> playAnswerConnectingToPassenger() async {
    await playAudio('assets/audio/6-connect.mp3', 
        text: 'Connecting to passenger');
  }

  /// Plays the "route built" message with time and distance
  Future<void> playAnswerRouteBuilt(String time, String distance) async {
    await playAudio('assets/audio/7-path_made.mp3', 
        text: 'Route built: $time, $distance');
  }

  /// Plays the "route rejected" message
  Future<void> playAnswerRouteRejected() async {
    await playAudio('assets/audio/8-path_declined .mp3', 
        text: 'Route rejected');
  }

  /// Plays the "business mode activated" message with commission
  Future<void> playAnswerBusinessModeActivated(String commission) async {
    await playAudio('assets/audio/9-work_mode.mp3', 
        text: 'Business mode activated: $commission');
  }

  /// Plays the "searching orders" message with destination
  Future<void> playAnswerSearchingOrders(String destination) async {
    await playAudio('assets/audio/10-available_paths.mp3', 
        text: 'Searching orders to $destination');
  }

  /// Plays the "going home" message with address
  Future<void> playAnswerGoingHome(String address) async {
    await playAudio('assets/audio/11-address.mp3', 
        text: 'Going home: $address');
  }

  /// Plays the "home address missing" message
  Future<void> playAnswerHomeAddressMissing() async {
    await playAudio('assets/audio/12-address-unavailable.mp3', 
        priority: MessagePriority.high,
        text: 'Home address missing');
  }

  /// Plays the "home mode limit" warning
  Future<void> playAnswerHomeModeLimit() async {
    await playAudio('assets/audio/13-work_mode_unavailable.mp3', 
        priority: MessagePriority.high,
        text: 'Home mode limit warning');
  }

  /// Plays the "POI found" message
  Future<void> playAnswerPOIFound(String poi, String distance, String direction) async {
    await playAudio('assets/audio/14-fuel-station.mp3', 
        text: 'POI found: $poi, $distance $direction');
  }

  /// Plays the "tariff changed" message
  Future<void> playAnswerTariffChanged(String tariff, bool isEnabled, List<String> availableTariffs) async {
    await playAudio('assets/audio/15-available_tariffs.mp3', 
        text: 'Tariff changed: $tariff (${isEnabled ? 'enabled' : 'disabled'})');
  }

  /// Plays the "command not recognized" message
  Future<void> playAnswerCommandNotRecognized() async {
    await playAudio('assets/audio/16-error.mp3', 
        priority: MessagePriority.high,
        text: 'Command not recognized');
  }

  /// Plays the "order cancelled" message
  Future<void> playAnswerOrderCancelled() async {
    await playAudio('assets/audio/17-order_declined.mp3', 
        text: 'Order cancelled');
  }

  /// Plays the "order completed" message
  Future<void> playAnswerOrderCompleted() async {
    await playAudio('assets/audio/18-order_finished.mp3', 
        text: 'Order completed');
  }

  /// Plays the "new order" message
  Future<void> playAnswerNewOrder() async {
    await playAudio('assets/audio/19-new_order.mp3', 
        priority: MessagePriority.high,
        text: 'New order');
  }
}