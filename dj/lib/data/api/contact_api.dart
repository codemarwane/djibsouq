import 'package:dj/data/api/api_client.dart';

class ContactApi {
  final _client = ApiClient.instance;

  Future<void> sendMessage({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) async {
    await _client.postJson(
      '/contact',
      body: {
        'name': name,
        'email': email,
        'subject': subject,
        'message': message,
      },
    );
  }
}
