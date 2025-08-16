import 'dart:io';
import 'dart:typed_data';

import 'package:alice_voice_player/alice_tts.dart';

/// Example demonstrating voice assistant functionality
/// 
/// This example shows how to use both TTS and STT together
/// for a complete voice assistant experience.
/// 
/// Note: This example requires audio files for demonstration.
/// In a real application, you would record audio from microphone.
void main(List<String> args) async {
  if (args.length < 2) {
    print('Usage: dart run examples/voice_assistant_example.dart <api-key> <audio-file>');
    print('Example: dart run examples/voice_assistant_example.dart your-api-key input.ogg');
    exit(1);
  }

  final apiKey = args[0];
  final audioFilePath = args[1];

  try {
    print('Initializing Voice Assistant...');
    
    // Initialize TTS
    final tts = YandexSpeechKitTts();
    await tts.init(
      apiKey: apiKey,
      voice: 'alena',
      format: 'mp3',
    );

    // Initialize STT
    final stt = YandexSpeechKitStt();
    await stt.init(
      apiKey: apiKey,
      language: 'ru-RU',
      model: 'general',
    );

    // Create voice assistant
    final assistant = AliceVoiceAssistant(tts: tts, stt: stt);

    print('Voice Assistant initialized successfully!');
    print('Processing audio file: $audioFilePath');

    // Read input audio file
    final audioFile = File(audioFilePath);
    if (!await audioFile.exists()) {
      print('Error: Audio file not found: $audioFilePath');
      print('Please provide a valid audio file (OGG, WAV, MP3)');
      exit(1);
    }

    final audioBytes = await audioFile.readAsBytes();
    print('Audio file loaded: ${audioBytes.length} bytes');

    // Process voice input
    print('Recognizing speech...');
    final stopwatch = Stopwatch()..start();
    
    final responseAudio = await assistant.processVoiceInput(audioBytes);
    
    stopwatch.stop();
    print('Processing completed in ${stopwatch.elapsedMilliseconds}ms');

    // Save response
    final outputPath = 'response_${DateTime.now().millisecondsSinceEpoch}.mp3';
    await File(outputPath).writeAsBytes(responseAudio);
    
    print('Response saved to: $outputPath');
    print('Response size: ${responseAudio.length} bytes');

    // Cleanup
    await tts.dispose();
    await stt.dispose();
    
    print('Voice Assistant example completed successfully!');
    
  } on AliceTtsException catch (e) {
    print('Voice Assistant Error: ${e.message}');
    if (e.statusCode != null) {
      print('Status code: ${e.statusCode}');
    }
    exit(1);
  } catch (e) {
    print('Unexpected error: $e');
    exit(1);
  }
}

/// Example of using individual TTS and STT services
Future<void> individualServicesExample(String apiKey) async {
  print('\n=== Individual Services Example ===');
  
  // TTS Example
  final tts = YandexSpeechKitTts();
  await tts.init(apiKey: apiKey);
  
  final text = 'Привет! Это пример синтеза речи.';
  final audioBytes = await tts.synthesizeBytes(text);
  print('TTS: Synthesized "${text}" -> ${audioBytes.length} bytes');
  
  // STT Example (using the synthesized audio)
  final stt = YandexSpeechKitStt();
  await stt.init(apiKey: apiKey);
  
  final recognizedText = await stt.recognizeAudio(audioBytes);
  print('STT: Recognized "${recognizedText}" from audio');
  
  await tts.dispose();
  await stt.dispose();
}

/// Example of streaming processing
Future<void> streamingExample(String apiKey) async {
  print('\n=== Streaming Example ===');
  
  final tts = YandexSpeechKitTts();
  await tts.init(apiKey: apiKey);
  
  final text = 'Это пример стриминга синтеза речи.';
  final audioStream = tts.synthesizeStream(text);
  
  int totalBytes = 0;
  await for (final chunk in audioStream) {
    totalBytes += chunk.length;
    print('Received audio chunk: ${chunk.length} bytes (total: $totalBytes)');
  }
  
  print('Streaming TTS completed: $totalBytes total bytes');
  await tts.dispose();
}
