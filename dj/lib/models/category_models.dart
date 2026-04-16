/// Catégorie affichée dans l’app, alignée sur le JSON API (`imageUrl`, `icon`, couleur hex).
library;

import 'package:flutter/material.dart';

class Category {
  final int id;
  final String name;
  final String image;
  final String icon;
  final Color color;

  var description;

  Category({
    required this.id,
    required this.name,
    required this.image,
    required this.icon,
    required this.color,
  });

  String? get backgroundImage => null;

  factory Category.fromJson(Map<String, dynamic> json) {
    final colorRaw = json['color']?.toString();
    return Category(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      image: json['imageUrl']?.toString() ?? json['image']?.toString() ?? '',
      icon: json['icon']?.toString() ?? 'category',
      color: _parseColor(colorRaw),
    )..description = json['description'];
  }

  static Color _parseColor(String? raw) {
    if (raw == null || raw.isEmpty) return const Color(0xFF3B82F6);
    final value = raw.replaceAll('#', '');
    final normalized = value.length == 6 ? 'FF$value' : value;
    final intColor = int.tryParse(normalized, radix: 16);
    if (intColor == null) return const Color(0xFF3B82F6);
    return Color(intColor);
  }
}
