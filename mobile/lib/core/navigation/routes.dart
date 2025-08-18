part of 'manager.dart';

class Routes {
  static const String profile = '$main/profile';
  static const String settings = '$profile/settings';
  static const String detailedVoiceSettings =
      '$settings/detailed-voice-settings';
  static const String main = '/';
  static const String communication = '$main/communication';
  static const String orders = '$main/orders';
  static const String stories = '$communication/stories'; // TODO поправить навигацию

}
