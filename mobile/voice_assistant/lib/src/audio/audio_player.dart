import 'dart:async';
import 'dart:math' as math;

import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

import '../models/playback_state.dart';

/// A service that handles audio playback for the voice assistant
class AliceAudioPlayer {
  /// Creates a new audio player instance
  AliceAudioPlayer() {
    _init();
  }

  final _player = AudioPlayer();
  final _playbackStateController = BehaviorSubject<PlaybackState>.seeded(PlaybackState.initial);
  final _amplitudeController = BehaviorSubject<double>.seeded(0.0);
  Timer? _amplitudeTimer;
  bool _isSpeaking = false;

  /// Stream of playback state changes
  Stream<PlaybackState> get playbackState => Rx.combineLatest2(
        _playbackStateController.stream,
        _amplitudeController.stream,
        (state, amplitude) => state.copyWith(amplitude: amplitude),
      );

  void _init() {
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
      }
    });
  }

  void _startAmplitudeSimulation() {
    _amplitudeTimer?.cancel();
    _amplitudeTimer = Timer.periodic(
      const Duration(milliseconds: 50),
      (timer) {
        if (!_isSpeaking) {
          timer.cancel();
          _amplitudeController.add(0.0);
          return;
        }
        
        final random = math.Random();
        final baseAmplitude = 0.5; 
        final variation = 0.3;
        final speed = 0.7;
        
        final currentAmplitude = _amplitudeController.value;
        final targetAmplitude = baseAmplitude + (random.nextDouble() * 2 - 1) * variation;
        
      
        final newAmplitude = currentAmplitude + (targetAmplitude - currentAmplitude) * speed;
        _amplitudeController.add(newAmplitude);
      },
    );
  }

  /// Plays an audio file from assets
  Future<void> playAudio(String assetPath) async {
    try {
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
      
    } catch (e) {
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
    }
  }

  void setTTSSpeaking(bool isSpeaking) {
    _isSpeaking = isSpeaking;
    _playbackStateController.add(
      PlaybackState(
        isPlaying: isSpeaking,
        amplitude: _amplitudeController.value,
      ),
    );
    
    if (isSpeaking) {
      _startAmplitudeSimulation();
    }
  }

  /// Releases resources
  Future<void> dispose() async {
    _amplitudeTimer?.cancel();
    await _player.dispose();
    await _playbackStateController.close();
    await _amplitudeController.close();
  }
}