import 'package:flutter/material.dart';

// ─── ORDER ────────────────────────────────────────────────────────────────────
enum OrderStatus { pending, inProgress, delivered, cancelled }

extension OrderStatusExt on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.pending:    return 'En attente';
      case OrderStatus.inProgress: return 'En cours';
      case OrderStatus.delivered:  return 'Livrée';
      case OrderStatus.cancelled:  return 'Annulée';
    }
  }
  Color get color {
    switch (this) {
      case OrderStatus.pending:    return const Color(0xFFEF9F27);
      case OrderStatus.inProgress: return const Color(0xFF378ADD);
      case OrderStatus.delivered:  return const Color(0xFF1D9E75);
      case OrderStatus.cancelled:  return const Color(0xFFE24B4A);
    }
  }
  Color get bg {
    switch (this) {
      case OrderStatus.pending:    return const Color(0xFFFAEEDA);
      case OrderStatus.inProgress: return const Color(0xFFE6F1FB);
      case OrderStatus.delivered:  return const Color(0xFFE1F5EE);
      case OrderStatus.cancelled:  return const Color(0xFFFCEBEB);
    }
  }
}

class OrderModel {
  final String id;
  final String client;
  final String product;
  final int amount;
  final OrderStatus status;
  final String date;

  OrderModel({
    required this.id,
    required this.client,
    required this.product,
    required this.amount,
    required this.status,
    required this.date,
  });
}

// ─── PRODUCT ──────────────────────────────────────────────────────────────────
enum ProductStatus { active, lowStock, outOfStock }

extension ProductStatusExt on ProductStatus {
  String get label {
    switch (this) {
      case ProductStatus.active:     return 'En stock';
      case ProductStatus.lowStock:   return 'Bas stock';
      case ProductStatus.outOfStock: return 'Rupture';
    }
  }
  Color get color {
    switch (this) {
      case ProductStatus.active:     return const Color(0xFF1D9E75);
      case ProductStatus.lowStock:   return const Color(0xFFEF9F27);
      case ProductStatus.outOfStock: return const Color(0xFFE24B4A);
    }
  }
  Color get bg {
    switch (this) {
      case ProductStatus.active:     return const Color(0xFFE1F5EE);
      case ProductStatus.lowStock:   return const Color(0xFFFAEEDA);
      case ProductStatus.outOfStock: return const Color(0xFFFCEBEB);
    }
  }
}

class ProductModel {
  final String id;
  String sku;
  String name;
  String category;
  int price;
  int stock;
  int sales;

  ProductModel({
    required this.id,
    required this.sku,
    required this.name,
    required this.category,
    required this.price,
    required this.stock,
    required this.sales,
  });

  ProductStatus get status {
    if (stock == 0)  return ProductStatus.outOfStock;
    if (stock < 15)  return ProductStatus.lowStock;
    return ProductStatus.active;
  }
}

// ─── USER ─────────────────────────────────────────────────────────────────────
enum UserRole { client, vendor, admin, superAdmin }

extension UserRoleExt on UserRole {
  String get label {
    switch (this) {
      case UserRole.client:     return 'Client';
      case UserRole.vendor:     return 'Vendeur';
      case UserRole.admin:      return 'Admin';
      case UserRole.superAdmin: return 'Super admin';
    }
  }
  Color get color {
    switch (this) {
      case UserRole.client:     return const Color(0xFF378ADD);
      case UserRole.vendor:     return const Color(0xFFEF9F27);
      case UserRole.admin:      return const Color(0xFF7F77DD);
      case UserRole.superAdmin: return const Color(0xFF7F77DD);
    }
  }
  Color get bg {
    switch (this) {
      case UserRole.client:     return const Color(0xFFE6F1FB);
      case UserRole.vendor:     return const Color(0xFFFAEEDA);
      case UserRole.admin:      return const Color(0xFFEEEDFE);
      case UserRole.superAdmin: return const Color(0xFFEEEDFE);
    }
  }
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final int orders;
  final int totalSpent;
  final UserRole role;
  final String joinDate;
  bool isBanned;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.orders,
    required this.totalSpent,
    required this.role,
    required this.joinDate,
    this.isBanned = false,
  });

  String get initials {
    final parts = name.split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.substring(0, 2).toUpperCase();
  }
}

// ─── CATEGORY ─────────────────────────────────────────────────────────────────
class CategoryModel {
  String name;
  String emoji;
  int products;
  int salesPercent;
  Color color;

  CategoryModel({
    required this.name,
    required this.emoji,
    required this.products,
    required this.salesPercent,
    required this.color,
  });
}

// ─── PROMO ────────────────────────────────────────────────────────────────────
enum PromoStatus { active, expired }

class PromoModel {
  final String id;
  String code;
  String description;
  int discount;
  String category;
  int usages;
  int? maxUsages;
  String? expiry;
  PromoStatus status;

  PromoModel({
    required this.id,
    required this.code,
    required this.description,
    required this.discount,
    required this.category,
    required this.usages,
    this.maxUsages,
    this.expiry,
    required this.status,
  });
}

// ─── SAMPLE DATA ──────────────────────────────────────────────────────────────
class AdminSampleData {
  static List<OrderModel> orders = [
    OrderModel(id: '#5501', client: 'Amine Houssein',  product: 'iPhone 15 Pro',      amount: 189000, status: OrderStatus.delivered,  date: '09 Avr 2026'),
    OrderModel(id: '#5500', client: 'Fatuma Ali',       product: 'Nike Air Max',         amount: 24500,  status: OrderStatus.inProgress, date: '09 Avr 2026'),
    OrderModel(id: '#5499', client: 'Omar Daher',       product: 'Samsung TV 55"',       amount: 142000, status: OrderStatus.pending,    date: '08 Avr 2026'),
    OrderModel(id: '#5498', client: 'Hodan Ismail',     product: 'Canapé 3 places',      amount: 67000,  status: OrderStatus.delivered,  date: '07 Avr 2026'),
    OrderModel(id: '#5497', client: 'Youssouf Abdou',  product: 'MacBook Air M3',       amount: 198000, status: OrderStatus.cancelled,  date: '07 Avr 2026'),
    OrderModel(id: '#5496', client: 'Rahma Mohamed',   product: 'HP Laptop 15',         amount: 98000,  status: OrderStatus.delivered,  date: '06 Avr 2026'),
    OrderModel(id: '#5495', client: 'Ibrahim Said',    product: 'Air Jordan 1',         amount: 42000,  status: OrderStatus.inProgress, date: '06 Avr 2026'),
    OrderModel(id: '#5494', client: 'Amina Hassan',    product: 'Samsung Galaxy S24',   amount: 145000, status: OrderStatus.pending,    date: '05 Avr 2026'),
  ];

  static List<ProductModel> products = [
    ProductModel(id: '1', sku: 'SKU-001', name: 'iPhone 15 Pro 256GB',   category: 'Électronique', price: 189000, stock: 12,  sales: 234),
    ProductModel(id: '2', sku: 'SKU-002', name: 'Samsung Galaxy S24',     category: 'Électronique', price: 145000, stock: 45,  sales: 189),
    ProductModel(id: '3', sku: 'SKU-003', name: 'Air Jordan 1 Retro',     category: 'Mode',          price: 42000,  stock: 0,   sales: 167),
    ProductModel(id: '4', sku: 'SKU-004', name: 'HP Laptop 15 Intel i7',  category: 'Électronique', price: 98000,  stock: 28,  sales: 134),
    ProductModel(id: '5', sku: 'SKU-005', name: 'Canapé L-shaped 5 pl.',  category: 'Maison',        price: 120000, stock: 6,   sales: 89),
    ProductModel(id: '6', sku: 'SKU-006', name: 'Nike Air Max 270',       category: 'Mode',          price: 24500,  stock: 31,  sales: 76),
  ];

  static List<UserModel> users = [
    UserModel(id: '1', name: 'Amine Houssein', email: 'amine.h@gmail.com',       orders: 24, totalSpent: 412000, role: UserRole.client,     joinDate: 'Jan 2025'),
    UserModel(id: '2', name: 'Fatuma Ali',      email: 'fatuma.ali@djib.dj',       orders: 18, totalSpent: 287000, role: UserRole.client,     joinDate: 'Mar 2025'),
    UserModel(id: '3', name: 'Said Salah',      email: 'said.s@vendor.dj',         orders: 0,  totalSpent: 0,      role: UserRole.vendor,     joinDate: 'Fév 2025'),
    UserModel(id: '4', name: 'Admin DJIBSOUQ', email: 'admin@djibsouq.dj',        orders: 0,  totalSpent: 0,      role: UserRole.superAdmin, joinDate: 'Jan 2024'),
  ];

  static List<CategoryModel> categories = [
    CategoryModel(name: 'Électronique', emoji: '📱', products: 234, salesPercent: 78, color: const Color(0xFF378ADD)),
    CategoryModel(name: 'Mode',          emoji: '👕', products: 189, salesPercent: 54, color: const Color(0xFF7F77DD)),
    CategoryModel(name: 'Maison',        emoji: '🏠', products: 145, salesPercent: 41, color: const Color(0xFFEF9F27)),
    CategoryModel(name: 'Sports',        emoji: '⚽', products: 98,  salesPercent: 29, color: const Color(0xFF1D9E75)),
  ];

  static List<PromoModel> promos = [
    PromoModel(id: '1', code: 'FLASH20', description: 'Flash Deal Électronique', discount: 20, category: 'Électronique', usages: 324, maxUsages: 500,   expiry: '15 Avr 2026', status: PromoStatus.active),
    PromoModel(id: '2', code: 'MODE15',  description: 'Promo Mode Printemps',    discount: 15, category: 'Mode',          usages: 89,  maxUsages: 200,   expiry: '30 Avr 2026', status: PromoStatus.active),
    PromoModel(id: '3', code: 'BIENV10', description: 'Bienvenue nouveaux clients', discount: 10, category: 'Toutes',    usages: 1245, maxUsages: null,  expiry: null,          status: PromoStatus.active),
    PromoModel(id: '4', code: 'NOEL25',  description: 'Promo Noël 2025',         discount: 25, category: 'Toutes',        usages: 2890, maxUsages: 3000, expiry: '05 Jan 2026', status: PromoStatus.expired),
  ];
}