import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> main() async {
  final url = Uri.parse("http://158.160.191.199:30080/classify-message");

  final body = {
    "text": "123",
    "user_id": "1",
    "voice_start_time": "2025-08-19T23:51:00Z",
    "request_text": "Прими заказ",
  };


  try {
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Basic dGVhbTQyOnNlY3JldHBhc3M=',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print("✅ Success: ${response.body}");
    } else {
      print("❌ Error ${response.statusCode}: ${response.body}");
    }
  } catch (e) {
    print("⚠️ Exception: $e");
  }
}
