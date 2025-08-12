import 'dart:io';

import 'package:args/args.dart';
import 'package:alice_voice_player/alice_tts.dart';

/// CLI example for TTS synthesis
/// 
/// Usage:
/// dart run examples/echo_cli.dart --text "Hello world" --out "result.mp3"
/// dart run examples/echo_cli.dart --text "Привет мир" --voice "alena" --out "hello.mp3"
void main(List<String> args) async {
  final parser = ArgParser()
    ..addOption('text', abbr: 't', help: 'Text to synthesize', mandatory: true)
    ..addOption('out', abbr: 'o', help: 'Output file path', mandatory: true)
    ..addOption('voice', abbr: 'v', help: 'Voice to use', defaultsTo: 'alena')
    ..addOption('format', abbr: 'f', help: 'Audio format', defaultsTo: 'mp3')
    ..addOption('api-key', help: 'Yandex API Key (or set YANDEX_API_KEY env var)')
    ..addOption('folder-id', help: 'Yandex Folder ID (or set YANDEX_FOLDER_ID env var)')
    ..addFlag('help', abbr: 'h', help: 'Show this help', negatable: false);

  try {
    final results = parser.parse(args);
    
    if (results['help']) {
      print('TTS CLI Example');
      print('');
      print('Usage:');
      print('  dart run examples/echo_cli.dart --text "Hello world" --out "result.mp3"');
      print('');
      print('Options:');
      print(parser.usage);
      return;
    }

    final text = results['text'] as String;
    final outputPath = results['out'] as String;
    final voice = results['voice'] as String;
    final format = results['format'] as String;
    
    // Get API credentials from args or environment
    final apiKey = results['api-key'] as String? ?? 
                   Platform.environment['YANDEX_API_KEY'];
    final folderId = results['folder-id'] as String? ?? 
                     Platform.environment['YANDEX_FOLDER_ID'];

    if (apiKey == null) {
      print('Error: API key is required. Set --api-key or YANDEX_API_KEY environment variable.');
      exit(1);
    }

    print('Initializing TTS...');
    final tts = YandexSpeechKitTts();
    
    await tts.init(
      apiKey: apiKey,
      folderId: folderId,
      voice: voice,
      format: format,
    );

    print('Synthesizing text: "$text"');
    print('Voice: $voice, Format: $format');
    
    final stopwatch = Stopwatch()..start();
    final audioBytes = await tts.synthesizeBytes(text);
    stopwatch.stop();

    print('Synthesis completed in ${stopwatch.elapsedMilliseconds}ms');
    print('Audio size: ${audioBytes.length} bytes');

    // Write to file
    final file = File(outputPath);
    await file.writeAsBytes(audioBytes);
    
    print('Audio saved to: $outputPath');
    
    // Get file size
    final fileSize = await file.length();
    print('File size: $fileSize bytes');

    await tts.dispose();
    
  } on FormatException catch (e) {
    print('Error parsing arguments: ${e.message}');
    print('');
    print('Usage:');
    print(parser.usage);
    exit(1);
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
