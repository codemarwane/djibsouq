import 'package:dj/layouts/web/pages_web/Admin_web/admin_theme.dart';
import 'package:dj/layouts/web/pages_web/Admin_web/admin_widget.dart';
import 'package:flutter/material.dart';


class AdminTopBar extends StatelessWidget {
  final String title;
  final String subtitle;

  const AdminTopBar({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      decoration: const BoxDecoration(
        color: AdminColors.surface,
        border: Border(bottom: BorderSide(color: AdminColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AdminText.h2),
                Text(subtitle, style: AdminText.tiny),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Search
          AdminSearchBar(hint: 'Rechercher...', width: 200),
          const SizedBox(width: 12),
          // Notification bell
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  border: Border.all(color: AdminColors.border),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.notifications_none_outlined, size: 18, color: AdminColors.text2),
              ),
              Positioned(
                top: 4, right: 4,
                child: Container(
                  width: 8, height: 8,
                  decoration: const BoxDecoration(color: AdminColors.red, shape: BoxShape.circle),
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),
          // Avatar
          Container(
            width: 36, height: 36,
            decoration: const BoxDecoration(color: AdminColors.primary, shape: BoxShape.circle),
            child: const Center(child: Text('AD', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600))),
          ),
        ],
      ),
    );
  }
}