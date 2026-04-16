/// Bannière / offre promotionnelle (pourcentage ou montant fixe selon [discountType]).
class PromotionModel {
  final int id;
  final String title;
  final String description;
  final String discountType;
  final double discountValue;
  final String? bannerImageUrl;

  PromotionModel({
    required this.id,
    required this.title,
    required this.description,
    required this.discountType,
    required this.discountValue,
    this.bannerImageUrl,
  });

  factory PromotionModel.fromJson(Map<String, dynamic> json) {
    return PromotionModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      discountType: json['discountType']?.toString() ?? 'percentage',
      discountValue: (json['discountValue'] as num?)?.toDouble() ?? 0,
      bannerImageUrl: json['bannerImageUrl']?.toString(),
    );
  }
}
