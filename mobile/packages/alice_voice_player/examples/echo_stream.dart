import 'dart:io';
import 'dart:typed_data';

import 'package:alice_voice_player/alice_tts.dart';

/// Stream example for TTS synthesis
/// 
/// Demonstrates how to use the streaming API for long texts
/// or real-time audio processing
void main(List<String> args) async {
  if (args.length < 2) {
    print('Usage: dart run examples/echo_stream.dart <api-key> <output-file>');
    print('Example: dart run examples/echo_stream.dart your-api-key result.mp3');
    exit(1);
  }

  final apiKey = args[0];
  final outputPath = args[1];
  final text = 'Это пример синтеза речи через стриминг. '
               'Длинный текст может быть обработан по частям '
               'для более эффективной работы с памятью.';

  try {
    print('Initializing TTS...');
    final tts = YandexSpeechKitTts();
    
    await tts.init(
      apiKey: apiKey,
      voice: 'alena',
      format: 'mp3',
    );

    print('Synthesizing text via stream: "${text.substring(0, 50)}..."');
    
    final stopwatch = Stopwatch()..start();
    final audioStream = tts.synthesizeStream(text);
    
    // Collect all chunks
    final chunks = <List<int>>[];
    int totalBytes = 0;
    
    await for (final chunk in audioStream) {
      chunks.add(chunk);
      totalBytes += chunk.length;
      print('Received chunk: ${chunk.length} bytes (total: $totalBytes)');
    }
    
    stopwatch.stop();
    
    // Combine all chunks
    final audioBytes = Uint8List.fromList(
      chunks.expand((chunk) => chunk).toList(),
    );

    print('Stream synthesis completed in ${stopwatch.elapsedMilliseconds}ms');
    print('Total audio size: ${audioBytes.length} bytes');

    // Write to file
    final file = File(outputPath);
    await file.writeAsBytes(audioBytes);
    
    print('Audio saved to: $outputPath');
    
    // Get file size
    final fileSize = await file.length();
    print('File size: $fileSize bytes');

    await tts.dispose();
    
  } on AliceTtsException catch (e) {
    print('TTS Error: ${e.message}');
    if (e.statusCode != null) {
      print('Status code: ${e.statusCode}');
    }
    exit(1);
  } catch (e) {
    print('Unexpected error: $e');
    exit(1);
  }
}
