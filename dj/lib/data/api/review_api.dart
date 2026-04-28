import 'package:dj/data/api/api_client.dart';

class ReviewApi {
  final _client = ApiClient.instance;

  Future<List<Map<String, dynamic>>> indexByProduct(int productId) async {
    final response = await _client.getJson('/products/$productId/reviews');
    final data = response['data'] as List<dynamic>? ?? const [];
    return data.whereType<Map<String, dynamic>>().toList();
  }

  Future<Map<String, dynamic>> store({
    required int productId,
    required int rating,
    required String comment,
  }) async {
    final response = await _client.postJson(
      '/products/$productId/reviews',
      body: {'rating': rating, 'comment': comment},
    );
    return response['data'] as Map<String, dynamic>? ?? {};
  }
}
