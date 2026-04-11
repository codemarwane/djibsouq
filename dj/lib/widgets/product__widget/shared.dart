import 'package:flutter/material.dart';
import 'package:dj/layouts/web/pages_web/detail_product_popup.dart';
import 'package:dj/models/product_models.dart';

const Color kBlue900 = Color(0xFF1E3A8A);
const Color kBlue700 = Color(0xFF1D4ED8);
const Color kBlue50 = Color(0xFFEFF6FF);
const Color kSurface = Color(0xFFFFFFFF);
const Color kBg = Color(0xFFF8FAFC);
const Color kInk = Color(0xFF0F172A);
const Color kInkMuted = Color(0xFF64748B);
const Color kBorder = Color(0xFFE2E8F0);

class Bp {
  static double width(BuildContext c) => MediaQuery.sizeOf(c).width;
  static bool desktop(BuildContext c) => width(c) >= 1024;

  static int cols(BuildContext c) {
    final w = width(c);
    if (w < 480) return 1;
    if (w < 768) return 2;
    if (w < 1280) return 3;
    return 4;
  }

  static double hPad(BuildContext c) {
    final w = width(c);
    if (w < 640) return 16;
    if (w < 1024) return 28;
    return 40;
  }
}

class Meta {
  final IconData icon;
  final Color bg;
  final Color fg;
  const Meta(this.icon, this.bg, this.fg);
}

const metaMap = <String, Meta>{
  'Electronique': Meta(
    Icons.devices_rounded,
    Color(0xFFEDE9FE),
    Color(0xFF7C3AED),
  ),
  'Vetements': Meta(
    Icons.checkroom_rounded,
    Color(0xFFFCE7F3),
    Color(0xFFDB2777),
  ),
  'Alimentation': Meta(
    Icons.restaurant_rounded,
    Color(0xFFFEF3C7),
    Color(0xFFD97706),
  ),
  'Sport': Meta(Icons.sports_basketball, Color(0xFFD1FAE5), Color(0xFF059669)),
  'Maison': Meta(Icons.home_rounded, Color(0xFFEDE9FE), Color(0xFF7C3AED)),
  'Beaute': Meta(Icons.spa_rounded, Color(0xFFFFE4E6), Color(0xFFE11D48)),
  'Livres': Meta(
    Icons.menu_book_rounded,
    Color(0xFFDBEAFE),
    Color(0xFF2563EB),
  ),
  'Jouets': Meta(Icons.toys_rounded, Color(0xFFFEF3C7), Color(0xFFD97706)),
  'Auto': Meta(Icons.directions_car_rounded, Color(0xFFCCFBF1), Color(0xFF0F766E)),
  'Jardin': Meta(Icons.yard_rounded, Color(0xFFDCFCE7), Color(0xFF16A34A)),
};

Meta metaFor(String cat) =>
    metaMap[cat] ??
    const Meta(Icons.category_rounded, Color(0xFFF1F5F9), Color(0xFF64748B));

void openProductPopup(BuildContext context, Product product) {
  DetailProductPopup.show(context, product: product);
}
