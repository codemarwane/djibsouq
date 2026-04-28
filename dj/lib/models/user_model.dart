class UserModel {
  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    this.isActive = true,
    this.inactiveReason,
    this.lastLoginAt,
  });

  final int id;
  final String name;
  final String email;
  final String role;
  final String? phone;
  final bool isActive;
  final String? inactiveReason;
  final String? lastLoginAt;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      role: json['role']?.toString() ?? 'customer',
      phone: json['phone']?.toString(),
      isActive: json['isActive'] as bool? ?? true,
      inactiveReason: json['inactiveReason']?.toString(),
      lastLoginAt: json['lastLoginAt']?.toString(),
    );
  }
}
