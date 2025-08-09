import 'dart:async';
import 'dart:math' as math;

import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

import '../configuration/alice_configuration.dart';
import '../models/playback_state.dart';
import '../utils/logger.dart';

/// A service that handles audio playback for the voice assistant
class AliceAudioPlayer {
  /// Creates a new audio player instance with optional configuration
  AliceAudioPlayer([AliceConfiguration? config]) 
      : _config = config ?? AliceConfiguration.defaultConfig();

  final AliceConfiguration _config;
  final _logger = AliceLogger();
  final _player = AudioPlayer();
  final _playbackStateController = BehaviorSubject<PlaybackState>.seeded(PlaybackState.initial);
  final _amplitudeController = BehaviorSubject<double>.seeded(0.0);
  
  Timer? _amplitudeTimer;
  bool _isSpeaking = false;
  bool _isInitialized = false;

  /// Stream of playback state changes
  Stream<PlaybackState> get playbackState => Rx.combineLatest2(
        _playbackStateController.stream,
        _amplitudeController.stream,
        (state, amplitude) => state.copyWith(amplitude: amplitude),
      );

  /// Initializes the audio player
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      // Set initial volume
      await _player.setVolume(_config.defaultVolume);
      
      // Listen to player state changes for amplitude simulation
      _player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed) {
          _isSpeaking = false;
          _amplitudeTimer?.cancel();
          _amplitudeController.add(0.0);
          _playbackStateController.add(
            PlaybackState(
              isPlaying: false,
              amplitude: 0.0,
            ),
          );
          _logger.debug('Audio playback completed');
        }
      });
      
      _isInitialized = true;
      _logger.info('AliceAudioPlayer initialized successfully');
    } catch (e) {
      _logger.error('Failed to initialize AliceAudioPlayer', e);
      rethrow;
    }
  }

  void _startAmplitudeSimulation() {
    if (!_config.amplitudeSimulation.enabled) return;
    
    _amplitudeTimer?.cancel();
    _amplitudeTimer = Timer.periodic(
      _config.amplitudeSimulation.updateInterval,
      (timer) {
        if (!_isSpeaking) {
          timer.cancel();
          _amplitudeController.add(0.0);
          return;
        }
        
        final random = math.Random();
        final config = _config.amplitudeSimulation;
        
        final currentAmplitude = _amplitudeController.value;
        final targetAmplitude = config.baseAmplitude + 
            (random.nextDouble() * 2 - 1) * config.variation;
        
        final newAmplitude = currentAmplitude + 
            (targetAmplitude - currentAmplitude) * config.speed;
        
        _amplitudeController.add(newAmplitude.clamp(0.0, 1.0));
      },
    );
  }

  /// Plays an audio file from assets
  Future<void> playAudio(String assetPath) async {
    if (!_isInitialized) {
      await initialize();
    }
    
    try {
      _logger.debug('Starting playback: $assetPath');
      
      _isSpeaking = true;
      _playbackStateController.add(
        PlaybackState(
          isPlaying: true,
          amplitude: _amplitudeController.value,
        ),
      );
      
      _startAmplitudeSimulation();
      
      await _player.setAsset(assetPath);
      await _player.play();
      
      // Wait for completion
      await _player.playerStateStream.firstWhere(
        (state) => state.processingState == ProcessingState.completed
      );
      
      _logger.debug('Playback completed: $assetPath');
      
    } catch (e) {
      _logger.error('Audio playback failed for $assetPath', e);
      
      _isSpeaking = false;
      _amplitudeTimer?.cancel();
      _amplitudeController.add(0.0);
      _playbackStateController.add(
        PlaybackState(
          isPlaying: false,
          amplitude: 0.0,
          error: 'Audio playback error: $e',
        ),
      );
      rethrow;
    }
  }

  /// Stops audio playback
  Future<void> stop() async {
    try {
      _isSpeaking = false;
      _amplitudeTimer?.cancel();
      _amplitudeController.add(0.0);
      await _player.stop();
      _logger.debug('Audio playback stopped');
    } catch (e) {
      _logger.error('Failed to stop audio playback', e);
    }
  }

  /// Sets the volume level (0.0 to 1.0)
  Future<void> setVolume(double volume) async {
    try {
      await _player.setVolume(volume.clamp(0.0, 1.0));
      _logger.debug('Volume set to $volume');
    } catch (e) {
      _logger.error('Failed to set volume', e);
    }
  }

  /// Releases resources
  Future<void> dispose() async {
    try {
      _amplitudeTimer?.cancel();
      await _player.dispose();
      await _playbackStateController.close();
      await _amplitudeController.close();
      _logger.debug('AliceAudioPlayer disposed');
    } catch (e) {
      _logger.error('Failed to dispose AliceAudioPlayer', e);
    }
  }
}