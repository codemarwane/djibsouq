import 'package:dj/data/api/api_client.dart';

class OrderApi {
  final _client = ApiClient.instance;

  Future<List<Map<String, dynamic>>> index() async {
    final response = await _client.getJson('/orders');
    final data = response['data'] as List<dynamic>? ?? const [];
    return data.whereType<Map<String, dynamic>>().toList();
  }

  Future<Map<String, dynamic>> show(int id) async {
    final response = await _client.getJson('/orders/$id');
    return response['data'] as Map<String, dynamic>? ?? {};
  }

  Future<Map<String, dynamic>> store({
    required int addressId,
    String? paymentMethod,
    String? notes,
  }) async {
    final response = await _client.postJson(
      '/orders',
      body: {
        'address_id': addressId,
        if (paymentMethod != null) 'payment_method': paymentMethod,
        if (notes != null) 'notes': notes,
      },
    );
    return response['data'] as Map<String, dynamic>? ?? {};
  }
}
