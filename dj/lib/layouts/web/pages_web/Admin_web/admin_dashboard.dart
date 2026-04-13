import 'package:dj/layouts/web/pages_web/Admin_web/admin_sidebar.dart';
import 'package:dj/layouts/web/pages_web/Admin_web/admin_topbar.dart';
import 'package:dj/layouts/web/pages_web/Admin_web/categories_page.dart';
import 'package:dj/layouts/web/pages_web/Admin_web/commande_page.dart';
import 'package:dj/layouts/web/pages_web/Admin_web/dashboard_page.dart';
import 'package:dj/layouts/web/pages_web/Admin_web/produits_page.dart';
import 'package:dj/layouts/web/pages_web/Admin_web/promo_seeting.dart';
import 'package:dj/layouts/web/pages_web/Admin_web/users_page.dart';
import 'package:flutter/material.dart';
import 'admin_theme.dart';


// ─────────────────────────────────────────────────────────────────────────────
//  ADMIN DASHBOARD SHELL
// ─────────────────────────────────────────────────────────────────────────────
class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  String _page = 'dashboard';

  static const _titles = {
    'dashboard':    ('Dashboard',      'Vue d\'ensemble — Avril 2026'),
    'commandes':    ('Commandes',      'Gestion des commandes clients'),
    'produits':     ('Produits',       'Catalogue & inventaire'),
    'utilisateurs': ('Utilisateurs',   'Gestion des comptes'),
    'categories':   ('Catégories',     'Organisation du catalogue'),
    'promos':       ('Promotions',     'Codes promo & réductions'),
    'settings':     ('Paramètres',     'Configuration du site'),
  };

  Widget _buildPage() {
    switch (_page) {
      case 'dashboard':    return const DashboardPage();
      case 'commandes':    return const CommandesPage();
      case 'produits':     return const ProduitsPage();
      case 'utilisateurs': return const UtilisateursPage();
      case 'categories':   return const CategoriesPage();
      case 'promos':       return const PromosPage();
      case 'settings':     return const SettingsPage();
      default:             return const DashboardPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    final info = _titles[_page] ?? ('Dashboard', '');
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Scaffold(
      backgroundColor: AdminColors.bg,
      // Mobile drawer
      drawer: isMobile
          ? Drawer(child: AdminSidebar(selectedPage: _page, onNavigate: (p) {
              setState(() => _page = p);
              Navigator.pop(context);
            }))
          : null,
      body: Row(
        children: [
          // Sidebar (desktop only)
          if (!isMobile)
            AdminSidebar(
              selectedPage: _page,
              onNavigate: (p) => setState(() => _page = p),
            ),

          // Main content
          Expanded(
            child: Column(
              children: [
                AdminTopBar(title: info.$1, subtitle: info.$2),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    transitionBuilder: (child, anim) => FadeTransition(
                      opacity: anim,
                      child: SlideTransition(
                        position: Tween<Offset>(begin: const Offset(0, 0.02), end: Offset.zero)
                            .animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
                        child: child,
                      ),
                    ),
                    child: KeyedSubtree(key: ValueKey(_page), child: _buildPage()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}