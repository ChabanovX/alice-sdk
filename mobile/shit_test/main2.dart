// tts_ws.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';

const wsUrl = 'ws://ws.158.160.191.199.nip.io:30080/text-to-speech';
const authHeader = 'Basic dGVhbTQyOnNlY3JldHBhc3M=';

Future<void> main(List<String> args) async {
  // if (args.isEmpty) {
  //   stderr.writeln('Usage: dart run tts_ws.dart "<text to synthesize>" [out.ogg]');
  //   exit(64);
  // }
  final text = 'Привет';
  final outPath = args.length > 1 ? args[1] : 'tts_output.ogg';

  await synthesizeToOgg(text: text, outPath: outPath);
}

Future<void> synthesizeToOgg(
    {required String text, required String outPath}) async {
  final ws = await WebSocket.connect(
    wsUrl,
    headers: {'Authorization': authHeader},
    compression: CompressionOptions.compressionOff,
  );

  stdout.writeln('🔗 Connected');

  final file = File(outPath);
  final sink = file.openWrite();
  var totalBytes = 0;
  var chunkCount = 0;

  final done = Completer<void>();

  ws.listen(
    (msg) {
      if (msg is List<int>) {
        // Binary audio chunk (Ogg/Opus)
        sink.add(msg);
        totalBytes += msg.length;
        chunkCount++;
      } else if (msg is String) {
        if (msg.trim().toUpperCase() == 'EOS') {
          stdout.writeln('🧵 EOS received, finishing…');
          doneComplete(done);
          ws.close();
        } else {
          // Server might send logs/status as text
          stdout.writeln('ℹ️  Server text: $msg');
        }
      } else {
        stdout.writeln('❓ Unknown frame type: ${msg.runtimeType}');
      }
    },
    onDone: () {
      stdout.writeln(
        '✅ WS closed (code=${ws.closeCode}, reason=${ws.closeReason}).',
      );
      doneComplete(done);
    },
    onError: (e, st) {
      stderr.writeln('💥 WS error: $e');
      doneComplete(done, error: e, st: st);
    },
    cancelOnError: false,
  );

  // Send the single text frame for synthesis (UTF-8)
  ws.add(text);
  stdout.writeln('➡️  Sent text (${utf8.encode(text).length} bytes): "$text"');

  try {
    // Optional: add a timeout if your server always closes or sends EOS.
    await done.future.timeout(const Duration(seconds: 60));
  } on TimeoutException {
    stderr.writeln('⏱️ Timeout waiting for audio/EOS; closing.');
  } finally {
    await ws.close();
    await sink.flush();
    await sink.close();
  }

  stdout.writeln('🎵 Wrote $chunkCount chunks, $totalBytes bytes → $outPath');
}

void doneComplete(Completer<void> c, {Object? error, StackTrace? st}) {
  if (!c.isCompleted) {
    if (error != null) {
      c.completeError(error, st);
    } else {
      c.complete();
    }
  }
}
