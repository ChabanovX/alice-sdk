import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alice_voice_assistant/alice_voice_assistant.dart';

void main() {
  group('AliceAnimatedLogo Widget Tests', () {
    setUp(() {
      // Reset singleton before each test
      AliceVoiceAssistant.reset();
    });

    tearDown(() {
      // Clean up after each test
      AliceVoiceAssistant.reset();
    });

    testWidgets('should render with default parameters', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AliceAnimatedLogo(),
          ),
        ),
      );

      // Verify the widget renders
      expect(find.byType(AliceAnimatedLogo), findsOneWidget);
      expect(find.byType(SizedBox), findsAtLeastNWidgets(1));
    });

    testWidgets('should render with custom parameters', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AliceAnimatedLogo(
              logoPath: 'assets/images/custom.png',
              size: 120.0,
              glowColor: Colors.red,
              showGlow: false,
              showRipple: false,
            ),
          ),
        ),
      );

      // Verify the widget renders with custom parameters
      expect(find.byType(AliceAnimatedLogo), findsOneWidget);
      
      // Find the SizedBox that should have our custom size
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
      expect(sizedBox.width, equals(120.0));
      expect(sizedBox.height, equals(120.0));
    });

    testWidgets('should show error icon when image fails to load', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AliceAnimatedLogo(
              logoPath: 'assets/images/nonexistent.png',
            ),
          ),
        ),
      );

      await tester.pump();

      // The error builder should show a mic icon
      expect(find.byIcon(Icons.mic), findsOneWidget);
    });

    testWidgets('should handle different sizes correctly', (WidgetTester tester) async {
      const testSizes = [50.0, 100.0, 150.0];

      for (final size in testSizes) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AliceAnimatedLogo(
                size: size,
              ),
            ),
          ),
        );

        final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox).first);
        expect(sizedBox.width, equals(size));
        expect(sizedBox.height, equals(size));

        await tester.pump();
      }
    });
  });

  group('AliceAnimatedLogoAdvanced Widget Tests', () {
    setUp(() {
      AliceVoiceAssistant.reset();
    });

    tearDown(() {
      AliceVoiceAssistant.reset();
    });

    testWidgets('should render advanced logo with default parameters', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AliceAnimatedLogoAdvanced(),
          ),
        ),
      );

      expect(find.byType(AliceAnimatedLogoAdvanced), findsOneWidget);
      expect(find.byType(SizedBox), findsAtLeastNWidgets(1));
    });

    testWidgets('should render with custom wave count', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AliceAnimatedLogoAdvanced(
              waveCount: 5,
              showSoundWaves: true,
            ),
          ),
        ),
      );

      expect(find.byType(AliceAnimatedLogoAdvanced), findsOneWidget);
    });

    testWidgets('should handle custom colors', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AliceAnimatedLogoAdvanced(
              waveColor: Colors.purple,
              backgroundColor: Colors.white,
            ),
          ),
        ),
      );

      expect(find.byType(AliceAnimatedLogoAdvanced), findsOneWidget);
    });
  });

  group('Widget Animation Tests', () {
    setUp(() {
      AliceVoiceAssistant.reset();
    });

    tearDown(() {
      AliceVoiceAssistant.reset();
    });

    testWidgets('should initialize animation controllers', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AliceAnimatedLogo(),
          ),
        ),
      );

      // Verify that the widget initializes without throwing
      expect(find.byType(AliceAnimatedLogo), findsOneWidget);
      
      // Pump a few frames to ensure animations are set up
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pump(const Duration(milliseconds: 100));
      
      expect(tester.takeException(), isNull);
    });

    testWidgets('should handle rapid widget rebuilds', (WidgetTester tester) async {
      Widget buildWidget(double size) {
        return MaterialApp(
          home: Scaffold(
            body: AliceAnimatedLogo(size: size),
          ),
        );
      }

      await tester.pumpWidget(buildWidget(80.0));
      await tester.pumpWidget(buildWidget(100.0));
      await tester.pumpWidget(buildWidget(120.0));

      expect(find.byType(AliceAnimatedLogo), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('Widget Configuration Tests', () {
    setUp(() {
      AliceVoiceAssistant.reset();
    });

    tearDown(() {
      AliceVoiceAssistant.reset();
    });

    testWidgets('should accept custom alice instance', (WidgetTester tester) async {
      final customConfig = AliceConfiguration(maxQueueSize: 3);
      final customAlice = AliceVoiceAssistant(customConfig);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AliceAnimatedLogo(alice: customAlice),
          ),
        ),
      );

      expect(find.byType(AliceAnimatedLogo), findsOneWidget);
      
      // Clean up
      await customAlice.dispose();
    });

    testWidgets('should handle various animation durations', (WidgetTester tester) async {
      const durations = [
        Duration(milliseconds: 50),
        Duration(milliseconds: 100),
        Duration(milliseconds: 200),
      ];

      for (final duration in durations) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AliceAnimatedLogo(
                animationDuration: duration,
              ),
            ),
          ),
        );

        expect(find.byType(AliceAnimatedLogo), findsOneWidget);
        await tester.pump();
      }
    });

    testWidgets('should handle pulse intensity variations', (WidgetTester tester) async {
      const intensities = [0.0, 0.3, 0.5, 1.0];

      for (final intensity in intensities) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AliceAnimatedLogo(
                pulseIntensity: intensity,
              ),
            ),
          ),
        );

        expect(find.byType(AliceAnimatedLogo), findsOneWidget);
        await tester.pump();
      }
    });
  });
}