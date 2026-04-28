import 'package:dj/data/api/api_client.dart';
import 'package:dj/models/category_models.dart';
import 'package:dj/models/product_models.dart';
import 'package:dj/models/promotion_models.dart';

class CatalogApi {
  final _client = ApiClient.instance;

  Future<List<Category>> fetchCategories() async {
    final response = await _client.getJson('/categories');
    final list = (response['data'] as List<dynamic>? ?? const []);
    return list
        .whereType<Map<String, dynamic>>()
        .map(Category.fromJson)
        .toList();
  }

  Future<List<Product>> fetchProducts({
    String? categorySlug,
    int perPage = 50,
  }) async {
    final response = await _client.getJson(
      '/products',
      queryParameters: {
        if (categorySlug != null && categorySlug.isNotEmpty)
          'category_slug': categorySlug,
        'per_page': perPage,
      },
    );
    final list = (response['data'] as List<dynamic>? ?? const []);
    return list
        .whereType<Map<String, dynamic>>()
        .map(Product.fromJson)
        .toList();
  }

  Future<Product?> fetchProductById(int productId) async {
    final response = await _client.getJson('/products/$productId');
    final data = response['data'] as Map<String, dynamic>?;
    if (data == null) return null;
    return Product.fromJson(data);
  }

  Future<List<PromotionModel>> fetchPromotions({int perPage = 20}) async {
    final response = await _client.getJson(
      '/promotions',
      queryParameters: {'per_page': perPage},
    );
    final list = (response['data'] as List<dynamic>? ?? const []);
    return list
        .whereType<Map<String, dynamic>>()
        .map(PromotionModel.fromJson)
        .toList();
  }
}
