// lib/alice_speaking_service.dart
import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

const _auth = 'Basic dGVhbTQyOnNlY3JldHBhc3M=';
const _url  = 'ws://158.160.191.199:30080/text-to-speech';

class AliceSpeakingService {
  AliceSpeakingService({
    String? authorization = _auth,
    this.connectTimeout = const Duration(seconds: 10),
    this.totalTimeout = const Duration(seconds: 60),
    this.duckWhileSfx = true,
    this.duckVolume = 0.5, // 50% while SFX plays
  }) : _authorization = authorization {
    _initPlayers();
  }

  // Two independent audio “waves”
  final AudioPlayer _ttsPlayer = AudioPlayer(); // speech
  final AudioPlayer _sfxPlayer = AudioPlayer(); // activation/deactivation

  // Preloaded SFX
  static const String _sfxOn  = 'assets/audio/alice_on.mp3';
  static const String _sfxOff = 'assets/audio/alice_off.mp3';

  final Uri _wsUrl = Uri.parse(_url);
  final String? _authorization;

  final Duration connectTimeout;
  final Duration totalTimeout;

  final bool duckWhileSfx;
  final double duckVolume;

  Future<void> _initPlayers() async {
    // Preload SFX so play() is instant
    await _sfxPlayer.setAudioSource(AudioSource.asset(_sfxOn));
    await _sfxPlayer.load();
  }

  Future<void> dispose() async {
    await _sfxPlayer.dispose();
    await _ttsPlayer.dispose();
  }

  /// Speak phrase via TTS WS, save ogg, then play on _ttsPlayer
  Future<void> sayText(String phrase) async {
    try {
      final oggFile = await _synthesizeToTempFile(phrase);
      await _ttsPlayer.setFilePath(oggFile.path);
      await _ttsPlayer.play();
    } catch (e) {
      // log or surface
      rethrow;
    }
  }

  Future<void> playActivationSound() async {
    // Ensure correct source loaded
    await _sfxPlayer.setAudioSource(AudioSource.asset(_sfxOn));
    await _playSfxWithOptionalDucking();
  }

  Future<void> playDeactivationSound() async {
    await _sfxPlayer.setAudioSource(AudioSource.asset(_sfxOff));
    await _playSfxWithOptionalDucking();
  }

  Future<void> _playSfxWithOptionalDucking() async {
    double? originalVol;
    if (duckWhileSfx && _ttsPlayer.playing) {
      originalVol = _ttsPlayer.volume;
      await _ttsPlayer.setVolume(duckVolume);
    }
    try {
      await _sfxPlayer.seek(Duration.zero);
      await _sfxPlayer.play();
    } finally {
      if (originalVol != null) {
        // give a tiny delay to avoid clicks
        await Future.delayed(const Duration(milliseconds: 50));
        await _ttsPlayer.setVolume(originalVol);
      }
    }
  }

  /// Connects, sends [text], writes Ogg/Opus chunks to a temp file, returns that file.
  Future<File> _synthesizeToTempFile(String text) async {
    final tmpDir = await getTemporaryDirectory();
    final out = File('${tmpDir.path}/tts_${DateTime.now().millisecondsSinceEpoch}.ogg');
    final sink = out.openWrite();

    WebSocket ws;
    try {
      ws = await WebSocket.connect(
        _wsUrl.toString(),
        headers: { if (_authorization != null) 'Authorization': _authorization! },
        compression: CompressionOptions.compressionOff,
      ).timeout(connectTimeout);
    } catch (e) {
      await sink.close();
      rethrow;
    }

    final completer = Completer<void>();
    Timer? watchdog;

    void armWatchdog() {
      watchdog?.cancel();
      watchdog = Timer(totalTimeout, () {
        if (!completer.isCompleted) {
          completer.completeError(TimeoutException('TTS stream timeout'));
        }
        ws.close(WebSocketStatus.goingAway);
      });
    }

    armWatchdog();
    ws.add(text);

    ws.listen(
      (dynamic frame) {
        armWatchdog();
        if (frame is List<int>) {
          sink.add(frame);
        } else if (frame is String && frame.trim().toUpperCase() == 'EOS') {
          if (!completer.isCompleted) completer.complete();
          ws.close(WebSocketStatus.normalClosure);
        }
      },
      onDone: () {
        if (!completer.isCompleted) completer.complete();
      },
      onError: (e, st) {
        if (!completer.isCompleted) completer.completeError(e, st);
      },
      cancelOnError: true,
    );

    try {
      await completer.future;
    } finally {
      watchdog?.cancel();
      await sink.close();
      try { await ws.close(); } catch (_) {}
    }

    if (await out.length() == 0) {
      throw StateError('Empty TTS file — server sent no audio.');
    }
    return out;
  }
}
