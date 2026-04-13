import 'package:flutter/material.dart';
import 'admin_theme.dart';



// ─── STATUS PILL ──────────────────────────────────────────────────────────────
class StatusPill extends StatelessWidget {
  final String label;
  final Color color;
  final Color bg;

  const StatusPill({super.key, required this.label, required this.color, required this.bg});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(99)),
      child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
    );
  }
}

// ─── METRIC CARD ─────────────────────────────────────────────────────────────
class MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final String sub;
  final bool isUp;

  const MetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.sub,
    this.isUp = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AdminColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AdminColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AdminText.muted),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AdminColors.text1)),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(isUp ? Icons.arrow_upward : Icons.arrow_downward,
                  size: 12, color: isUp ? AdminColors.green : AdminColors.red),
              const SizedBox(width: 3),
              Text(sub, style: TextStyle(fontSize: 11.5, color: isUp ? AdminColors.green : AdminColors.red)),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── CARD CONTAINER ──────────────────────────────────────────────────────────
class AdminCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const AdminCard({super.key, required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AdminColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AdminColors.border),
      ),
      child: child,
    );
  }
}

// ─── CARD HEADER ─────────────────────────────────────────────────────────────
class AdminCardHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? action;

  const AdminCardHeader({super.key, required this.title, this.subtitle, this.action});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AdminText.h3),
              if (subtitle != null) ...[
                const SizedBox(height: 2),
                Text(subtitle!, style: AdminText.tiny),
              ],
            ],
          ),
        ),
        if (action != null) action!,
      ],
    );
  }
}

// ─── PRIMARY BUTTON ──────────────────────────────────────────────────────────
class AdminPrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final IconData? icon;

  const AdminPrimaryButton({super.key, required this.label, required this.onTap, this.icon});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: AdminColors.primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 16), const SizedBox(width: 6)],
          Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

// ─── OUTLINE BUTTON ──────────────────────────────────────────────────────────
class AdminOutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final IconData? icon;

  const AdminOutlineButton({super.key, required this.label, required this.onTap, this.icon});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: AdminColors.text1,
        side: const BorderSide(color: AdminColors.border),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[Icon(icon, size: 15), const SizedBox(width: 6)],
          Text(label, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}

// ─── ICON BUTTON ─────────────────────────────────────────────────────────────
class AdminIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;

  const AdminIconBtn({super.key, required this.icon, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Container(
        width: 30, height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: AdminColors.border),
        ),
        child: Icon(icon, size: 15, color: color ?? AdminColors.text2),
      ),
    );
  }
}

// ─── AVATAR ──────────────────────────────────────────────────────────────────
class UserAvatar extends StatelessWidget {
  final String initials;
  final Color bg;
  final Color textColor;
  final double size;

  const UserAvatar({
    super.key,
    required this.initials,
    required this.bg,
    required this.textColor,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Center(
        child: Text(initials,
            style: TextStyle(fontSize: size * 0.35, fontWeight: FontWeight.w600, color: textColor)),
      ),
    );
  }
}

// ─── SEARCH BAR ──────────────────────────────────────────────────────────────
class AdminSearchBar extends StatelessWidget {
  final String hint;
  final ValueChanged<String>? onChanged;
  final double? width;

  const AdminSearchBar({super.key, required this.hint, this.onChanged, this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 36,
      decoration: BoxDecoration(
        color: AdminColors.bg,
        border: Border.all(color: AdminColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        onChanged: onChanged,
        style: AdminText.body,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AdminText.muted,
          prefixIcon: const Icon(Icons.search, size: 16, color: AdminColors.text3),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
        ),
      ),
    );
  }
}

// ─── EMPTY STATE ─────────────────────────────────────────────────────────────
class AdminEmptyState extends StatelessWidget {
  final String message;

  const AdminEmptyState({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            const Icon(Icons.inbox_outlined, size: 40, color: AdminColors.text3),
            const SizedBox(height: 12),
            Text(message, style: AdminText.muted),
          ],
        ),
      ),
    );
  }
}