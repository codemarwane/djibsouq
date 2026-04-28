
/// Notifications in-app : liste et marquage lu (tout ou une notification).
library;

import 'package:dj/data/api/api_client.dart';

class NotificationApi {
  final _client = ApiClient.instance;

  Future<List<Map<String, dynamic>>> index() async {
    final response = await _client.getJson('/notifications');
    final data = response['data'] as List<dynamic>? ?? const [];
    return data.whereType<Map<String, dynamic>>().toList();
  }

  Future<void> markAllRead() async {
    await _client.postJson('/notifications/read-all');
  }

  Future<void> markRead(int id) async {
    await _client.postJson('/notifications/$id/read');
  }
}
