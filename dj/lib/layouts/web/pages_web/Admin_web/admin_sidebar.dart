import 'package:dj/layouts/web/pages_web/Admin_web/admin_theme.dart';
import 'package:flutter/material.dart';

class AdminSidebar extends StatelessWidget {
  final String selectedPage;
  final ValueChanged<String> onNavigate;

  const AdminSidebar({
    super.key,
    required this.selectedPage,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      decoration: const BoxDecoration(
        color: AdminColors.sidebar,
        border: Border(right: BorderSide(color: AdminColors.border)),
      ),
      child: Column(
        children: [
          // Logo
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AdminColors.border)),
            ),
            child: Row(
              children: [
                Container(
                  width: 34, height: 34,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(0, 197, 192, 192),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image(image: AssetImage('assets/images/logo.png'), width: 100, height: 100),
                ),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('DJIBSOUQ', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AdminColors.text1, letterSpacing: .5)),
                    Text('Admin panel', style: TextStyle(fontSize: 11, color: AdminColors.text3)),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _NavSection('PRINCIPAL'),
                  _NavItem(icon: Icons.grid_view_rounded,    title: 'Dashboard',    page: 'dashboard',    selected: selectedPage, onTap: onNavigate),
                  _NavItem(icon: Icons.receipt_long_outlined, title: 'Commandes',   page: 'commandes',    selected: selectedPage, onTap: onNavigate, badge: 12),
                  _NavItem(icon: Icons.inventory_2_outlined,  title: 'Produits',    page: 'produits',     selected: selectedPage, onTap: onNavigate),
                  _NavItem(icon: Icons.people_outline,        title: 'Utilisateurs',page: 'utilisateurs', selected: selectedPage, onTap: onNavigate),
                  _NavItem(icon: Icons.category_outlined,     title: 'Catégories',  page: 'categories',   selected: selectedPage, onTap: onNavigate),
                  _NavItem(icon: Icons.local_offer_outlined,  title: 'Promotions',  page: 'promos',       selected: selectedPage, onTap: onNavigate, badge: 3),

                  _NavSection('PARAMÈTRES'),
                  _NavItem(icon: Icons.settings_outlined,     title: 'Paramètres',  page: 'settings',     selected: selectedPage, onTap: onNavigate),
                ],
              ),
            ),
          ),

          // Footer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AdminColors.border)),
            ),
            child: Row(
              children: [
                Container(
                  width: 34, height: 34,
                  decoration: const BoxDecoration(color: AdminColors.primary, shape: BoxShape.circle),
                  child: const Center(child: Text('AD', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600))),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Admin DJIBSOUQ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AdminColors.text1), overflow: TextOverflow.ellipsis),
                      Text('Super admin', style: TextStyle(fontSize: 11, color: AdminColors.text3)),
                    ],
                  ),
                ),
                Icon(Icons.logout_outlined, size: 16, color: AdminColors.text3),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavSection extends StatelessWidget {
  final String title;
  const _NavSection(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1.1, color: AdminColors.text3)),
    );
  }
}

class _NavItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final String page;
  final String selected;
  final ValueChanged<String> onTap;
  final int? badge;

  const _NavItem({
    required this.icon,
    required this.title,
    required this.page,
    required this.selected,
    required this.onTap,
    this.badge,
  });

  @override
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.selected == widget.page;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => widget.onTap(widget.page),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            color: isSelected
                ? AdminColors.primaryLight
                : _hovered
                    ? AdminColors.bg
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(widget.icon, size: 18,
                  color: isSelected ? AdminColors.primary : AdminColors.text2),
              const SizedBox(width: 10),
              Expanded(
                child: Text(widget.title,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? AdminColors.primary : AdminColors.text1,
                    )),
              ),
              if (widget.badge != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AdminColors.redLight,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text('${widget.badge}',
                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AdminColors.red)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}