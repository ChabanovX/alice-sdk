import 'dart:async';

import 'package:get_it/get_it.dart';

import 'core/services/alice_speaker_service.dart';

final getIt = GetIt.instance;

Future<void> initDi() async {
  getIt.registerSingleton<AliceSpeakingService>(
    AliceSpeakingService(),
  );

  final speak = getIt<AliceSpeakingService>();
  unawaited(
    speak.sayText('Алиса тут.'),
  );
}
