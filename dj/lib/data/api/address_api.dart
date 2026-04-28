
/// Adresses de livraison utilisateur : CRUD sur `/addresses`.
library;

import 'package:dj/data/api/api_client.dart';

class AddressApi {
  final _client = ApiClient.instance;

  Future<List<Map<String, dynamic>>> index() async {
    final response = await _client.getJson('/addresses');
    final data = response['data'] as List<dynamic>? ?? const [];
    return data.whereType<Map<String, dynamic>>().toList();
  }

  Future<Map<String, dynamic>> store(Map<String, dynamic> payload) async {
    final response = await _client.postJson('/addresses', body: payload);
    return response['data'] as Map<String, dynamic>? ?? {};
  }

  Future<Map<String, dynamic>> update(int id, Map<String, dynamic> payload) async {
    final response = await _client.putJson('/addresses/$id', body: payload);
    return response['data'] as Map<String, dynamic>? ?? {};
  }

  Future<void> destroy(int id) async {
    await _client.deleteJson('/addresses/$id');
  }
}
