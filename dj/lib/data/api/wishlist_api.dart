/// Liste de souhaits : GET/POST `/wishlist`, DELETE `/wishlist/:id` (même session invité que le panier).
library;

import 'package:dj/data/api/api_client.dart';
import 'package:dj/models/product_models.dart';

class WishlistApi {
  final _client = ApiClient.instance;

  Future<List<Product>> getWishlist() async {
    final response = await _client.getJson('/wishlist');
    final list = (response['data'] as List<dynamic>? ?? const []);
    return list
        .whereType<Map<String, dynamic>>()
        .map(Product.fromJson)
        .toList();
  }

  Future<void> add(int productId) async {
    await _client.postJson('/wishlist', body: {'product_id': productId});
  }

  Future<void> remove(int productId) async {
    await _client.deleteJson('/wishlist/$productId');
  }
}
