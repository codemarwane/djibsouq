import 'package:flutter/material.dart';

class AdminColors {
  static const bg          = Color(0xFFF3F4F6);
  static const surface     = Color(0xFFFFFFFF);
  static const sidebar     = Color(0xFFFFFFFF);
  static const primary     = Color(0xFF1E3A8A);
  static const primaryLight = Color(0xFFE6F1FB);
  static const transparent = Colors.transparent;

  static const text1       = Color(0xFF111827);
  static const text2       = Color(0xFF6B7280);
  static const text3       = Color(0xFF9CA3AF);

  static const border      = Color(0xFFE5E7EB);

  static const green       = Color(0xFF1D9E75);
  static const greenLight  = Color(0xFFE1F5EE);
  static const amber       = Color(0xFFEF9F27);
  static const amberLight  = Color(0xFFFAEEDA);
  static const red         = Color(0xFFE24B4A);
  static const redLight    = Color(0xFFFCEBEB);
  static const blue        = Color(0xFF378ADD);
  static const blueLight   = Color(0xFFE6F1FB);
  static const purple      = Color(0xFF7F77DD);
  static const purpleLight = Color(0xFFEEEDFE);
}

class AdminText {
  static const h1 = TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AdminColors.text1);
  static const h2 = TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: AdminColors.text1);
  static const h3 = TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AdminColors.text1);
  static const body = TextStyle(fontSize: 13, color: AdminColors.text1);
  static const muted = TextStyle(fontSize: 12, color: AdminColors.text2);
  static const tiny = TextStyle(fontSize: 11, color: AdminColors.text3);
  static const mono = TextStyle(fontSize: 12, fontFamily: 'monospace', color: AdminColors.text2);
}