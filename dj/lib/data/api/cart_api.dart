
/// Panier : `/cart` et `/cart/items`. Persiste le `guestToken` renvoyé quand l’utilisateur est invité.
library;

import 'package:dj/data/api/api_client.dart';
import 'package:dj/data/api/guest_token_store.dart';
import 'package:dj/models/cart_models.dart';

class CartApi {
  final _client = ApiClient.instance;

  Future<CartModel> getCart() async {
    final response = await _client.getJson('/cart');
    final data = response['data'] as Map<String, dynamic>? ?? {};
    final guestToken = response['guestToken']?.toString();
    if (guestToken != null) {
      await GuestTokenStore.instance.saveGuestToken(guestToken);
    }
    return CartModel.fromJson(data);
  }

  Future<CartModel> addItem({
    required int productId,
    int quantity = 1,
  }) async {
    final response = await _client.postJson(
      '/cart/items',
      body: {'product_id': productId, 'quantity': quantity},
    );
    final data = response['data'] as Map<String, dynamic>? ?? {};
    final guestToken = response['guestToken']?.toString();
    if (guestToken != null) {
      await GuestTokenStore.instance.saveGuestToken(guestToken);
    }
    return CartModel.fromJson(data);
  }

  Future<CartModel> updateItem({
    required int cartItemId,
    required int quantity,
  }) async {
    final response = await _client.patchJson(
      '/cart/items/$cartItemId',
      body: {'quantity': quantity},
    );
    final data = response['data'] as Map<String, dynamic>? ?? {};
    return CartModel.fromJson(data);
  }

  Future<CartModel> removeItem(int cartItemId) async {
    final response = await _client.deleteJson('/cart/items/$cartItemId');
    final data = response['data'] as Map<String, dynamic>? ?? {};
    return CartModel.fromJson(data);
  }

  Future<void> clearCart() async {
    await _client.deleteJson('/cart');
  }
}
