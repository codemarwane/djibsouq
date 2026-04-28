import 'package:dj/models/product_models.dart';
import 'package:dj/models/category_models.dart';
import 'package:dj/models/promotion_models.dart';
import 'package:dj/data/api/catalog_api.dart';

class ProductRepository {
  static final _catalogApi = CatalogApi();
  static List<Category> categories = [];
  static List<Product> products = [];
  static List<PromotionModel> promotions = [];
  static bool _isInitialized = false;
  static bool _isLoading = false;

  static Future<void> initialize() async {
    if (_isInitialized || _isLoading) return;
    _isLoading = true;
    try {
      categories = await _catalogApi.fetchCategories();
      products = await _catalogApi.fetchProducts(perPage: 100);
      promotions = await _catalogApi.fetchPromotions(perPage: 20);
      _isInitialized = true;
    } finally {
      _isLoading = false;
    }
  }

  static Future<void> refreshAll() async {
    _isInitialized = false;
    await initialize();
  }

  static List<Product> getProductsByCategory(String categoryName) {
    if (categoryName == 'Toutes') return products;
    return products.where((product) => product.category == categoryName).toList();
  }

  static List<Product> getPopularProducts({int limit = 4}) {
    return products.take(limit).toList();
  }

  static List<Product> getAllProducts() {
    return products;
  }

  static Product? getProductById(int id) {
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
  static List<Product> getBestSellers() {
    return products.where((p) => p.isBestSeller).toList();
  }

  static int getProductCountByCategory(String categoryName) {
    return products.where((p) => p.category == categoryName).length;
  }


}
