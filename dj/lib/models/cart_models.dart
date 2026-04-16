/// Modèles du panier API : ligne avec produit embarqué et totaux du panier.
library;

import 'package:dj/models/product_models.dart';

class CartItemModel {
  CartItemModel({
    required this.id,
    required this.quantity,
    required this.unitPriceSnapshot,
    required this.product,
  });

  final int id;
  final int quantity;
  final double unitPriceSnapshot;
  final Product product;

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      unitPriceSnapshot: (json['unitPriceSnapshot'] as num?)?.toDouble() ?? 0,
      product: Product.fromJson((json['product'] as Map<String, dynamic>? ?? {})),
    );
  }
}

class CartModel {
  CartModel({
    required this.id,
    required this.items,
    required this.itemsCount,
    required this.subtotal,
    this.guestToken,
  });

  final int id;
  final List<CartItemModel> items;
  final int itemsCount;
  final double subtotal;
  final String? guestToken;

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final itemsRaw = (json['items'] as List<dynamic>? ?? const []);
    return CartModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      items: itemsRaw
          .whereType<Map<String, dynamic>>()
          .map(CartItemModel.fromJson)
          .toList(),
      itemsCount: (json['itemsCount'] as num?)?.toInt() ?? 0,
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0,
      guestToken: json['guestToken']?.toString(),
    );
  }
}
