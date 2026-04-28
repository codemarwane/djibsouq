class Product {
  final int id;
  final String title;
  final double price;
  final String image;
  final String? imageUrl;
  final String category;
  final int? categoryId;
  final String? categorySlug;
  final String description;
  final double rating;
  final int reviews;
  final bool isBestSeller;
  final double? discount;
  final double? originalPrice;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.image,
    this.imageUrl,
    required this.category,
    this.categoryId,
    this.categorySlug,
    required this.description,
    this.rating = 4.5,
    this.reviews = 0,
    this.isBestSeller = false,
    this.discount,
    this.originalPrice,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      image: json['imageUrl']?.toString() ?? json['image']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString(),
      category: json['category']?.toString() ?? '',
      categoryId: (json['categoryId'] as num?)?.toInt(),
      categorySlug: json['categorySlug']?.toString(),
      description: json['description']?.toString() ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      reviews: (json['reviews'] as num?)?.toInt() ?? 0,
      isBestSeller: json['isBestSeller'] as bool? ?? false,
      discount: (json['discount'] as num?)?.toDouble(),
      originalPrice: (json['originalPrice'] as num?)?.toDouble(),
    );
  }

}    

