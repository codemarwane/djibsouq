/// Profil connecté : chargement et mise à jour via [AuthApi] (`/user`).
library;

import 'package:flutter/material.dart';
import 'package:dj/widgets/web_header.dart';
import 'package:dj/routes.dart';
import 'package:dj/data/api/auth_api.dart';
import 'package:dj/models/user_model.dart';

const Color primaryBlue = Color(0xFF1E3A8A);
const Color lightGrey = Color(0xFFF3F4F6);
const Color cardGrey = Color(0xFFFFFFFF);
const Color textDark = Color(0xFF111827);

// Breakpoints
const double mobileBreakpoint = 700;
const double tabletBreakpoint = 1024;

// ─────────────────────────────────────────────
//  PROFILE PAGE
// ─────────────────────────────────────────────
class ProfileWeb extends StatefulWidget {
  const ProfileWeb({super.key});

  @override
  State<ProfileWeb> createState() => _ProfileWebState();
}

class _ProfileWebState extends State<ProfileWeb> {
  final _authApi = AuthApi();
  late Future<UserModel> _userFuture;
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _userFuture = _authApi.me();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
      future: _userFuture,
      builder: (context, snapshot) {
        _user = snapshot.data;
        return Scaffold(
          backgroundColor: lightGrey,
          body: SingleChildScrollView(
            child: Column(
              children: [
                buildHeader(currentPage: 'Profil'),
                if (snapshot.connectionState != ConnectionState.done)
                  const Padding(
                    padding: EdgeInsets.all(48),
                    child: CircularProgressIndicator(),
                  )
                else
                  _buildProfileContent(),
                _buildFooter(),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────
  //  PROFILE CONTENT
  // ─────────────────────────────────────────────
  Widget _buildProfileContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final bool isMobile = width < mobileBreakpoint;
        final bool isTablet = width < tabletBreakpoint;

        final double horizontalPadding = isMobile ? 20 : (isTablet ? 40 : 60);
        final double verticalPadding = isMobile ? 24 : 40;

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Column(
            children: [
              _buildProfileHeader(isMobile: isMobile),
              const SizedBox(height: 30),
              _buildStatsRow(isMobile: isMobile),
              const SizedBox(height: 30),
              _buildProfileSections(isMobile: isMobile),
            ],
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────
  //  PROFILE HEADER – Responsive
  // ─────────────────────────────────────────────
  Widget _buildProfileHeader({required bool isMobile}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1E3A8A), Color(0xFF1E293B)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A8A).withOpacity(0.3),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          if (!isMobile) ...[
            Positioned(right: -30, top: -30, child: _decorativeCircle(200)),
            Positioned(right: 60, bottom: -50, child: _decorativeCircle(150)),
          ],
          Padding(
            padding: EdgeInsets.all(isMobile ? 24 : 40),
            child: isMobile
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildAvatar(isMobile: true),
                      const SizedBox(height: 20),
                      _buildUserInfo(isMobile: true),
                      const SizedBox(height: 24),
                      _buildActionButtons(isMobile: true),
                    ],
                  )
                : Row(
                    children: [
                      _buildAvatar(isMobile: false),
                      const SizedBox(width: 36),
                      Expanded(child: _buildUserInfo(isMobile: false)),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _decorativeCircle(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(0.04),
      ),
    );
  }

  Widget _buildAvatar({required bool isMobile}) {
    final double radius = isMobile ? 48 : 56;
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
      ),
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.white.withOpacity(0.12),
        child: const Icon(Icons.person, size: 64, color: Colors.white),
      ),
    );
  }

  Widget _buildUserInfo({required bool isMobile}) {
    return Column(
      crossAxisAlignment: isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: isMobile
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            Text(
              _user?.name ?? 'Utilisateur',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.greenAccent.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.greenAccent.withOpacity(0.5)),
              ),
              child: const Text(
                'Vérifié',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        _infoRow(Icons.email_outlined, _user?.email ?? '', isMobile),
        const SizedBox(height: 6),
        _infoRow(Icons.location_on_outlined, 'Djibouti, DJ', isMobile),
        if (!isMobile) ...[
          const SizedBox(height: 24),
          _buildActionButtons(isMobile: isMobile),
        ],
      ],
    );
  }

  Widget _infoRow(IconData icon, String text, bool isMobile) {
    return Row(
      mainAxisAlignment: isMobile
          ? MainAxisAlignment.center
          : MainAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.white.withOpacity(0.6)),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(fontSize: 15, color: Colors.white.withOpacity(0.7)),
        ),
      ],
    );
  }

  Widget _buildActionButtons({required bool isMobile}) {
    return isMobile
        ? Column(
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: primaryBlue,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _showEditProfileDialog,
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: const Text(
                  'Éditer le profil',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white.withOpacity(0.4)),
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _shareProfile,
                icon: const Icon(Icons.share_outlined, size: 18),
                label: const Text('Partager'),
              ),
            ],
          )
        : Row(
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: primaryBlue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _showEditProfileDialog,
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: const Text(
                  'Éditer le profil',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white.withOpacity(0.4)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _shareProfile,
                icon: const Icon(Icons.share_outlined, size: 18),
                label: const Text('Partager'),
              ),
            ],
          );
  }

  // ─────────────────────────────────────────────
  //  STATS ROW
  // ─────────────────────────────────────────────
  Widget _buildStatsRow({required bool isMobile}) {
    final stats = [
      _StatItem(
        icon: Icons.shopping_bag_outlined,
        value: '12',
        label: 'Commandes',
        onTap: () => Navigator.pushNamed(context, AppRoutes.products),
      ),
      _StatItem(
        icon: Icons.favorite_outline,
        value: '34',
        label: 'Favoris',
        onTap: () => Navigator.pushNamed(context, AppRoutes.favorites),
      ),
      _StatItem(
        icon: Icons.star_outline,
        value: '4.8',
        label: 'Note',
        onTap: null,
      ),
      _StatItem(
        icon: Icons.card_giftcard_outlined,
        value: '1 200',
        label: 'Points',
        onTap: null, // TODO: page fidélité
      ),
    ];

    return isMobile
        ? Column(
            children: stats
                .map(
                  (s) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _TappableCard(
                      onTap: s.onTap,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: primaryBlue.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(s.icon, color: primaryBlue, size: 22),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s.value,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: textDark,
                                ),
                              ),
                              Text(
                                s.label,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList(),
          )
        : Row(
            children: stats
                .map(
                  (s) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: _TappableCard(
                        onTap: s.onTap,
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: primaryBlue.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(s.icon, color: primaryBlue, size: 22),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  s.value,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: textDark,
                                  ),
                                ),
                                Text(
                                  s.label,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          );
  }

  // ─────────────────────────────────────────────
  //  PROFILE SECTIONS
  // ─────────────────────────────────────────────
  Widget _buildProfileSections({required bool isMobile}) {
    final leftSection = _buildSection('Mon Compte', [
      _MenuItem(
        icon: Icons.shopping_bag_outlined,
        title: 'Mes commandes',
        subtitle: 'Suivi & historique',
        onTap: () => Navigator.pushNamed(context, AppRoutes.products),
      ),
      _MenuItem(
        icon: Icons.location_on_outlined,
        title: 'Mes adresses',
        subtitle: 'Livraison',
        onTap: () => _showComingSoon('Mes adresses'),
      ),
      _MenuItem(
        icon: Icons.payment_outlined,
        title: 'Paiement',
        subtitle: 'Cartes & mobile money',
        onTap: () => _showComingSoon('Paiement'),
      ),
      _MenuItem(
        icon: Icons.favorite_outline,
        title: 'Favoris',
        subtitle: 'Produits aimés',
        onTap: () => Navigator.pushNamed(context, AppRoutes.favorites),
      ),
    ]);

    final rightSection = _buildSection('Paramètres', [
      _MenuItem(
        icon: Icons.notifications_outlined,
        title: 'Notifications',
        subtitle: 'Alertes & mises à jour',
        onTap: () => _showComingSoon('Notifications'),
      ),
      _MenuItem(
        icon: Icons.security_outlined,
        title: 'Sécurité',
        subtitle: 'Mot de passe & authentification',
        onTap: () => _showComingSoon('Sécurité'),
      ),
      _MenuItem(
        icon: Icons.language_outlined,
        title: 'Langue',
        subtitle: 'Français, English...',
        onTap: _showLanguageDialog,
      ),
      _MenuItem(
        icon: Icons.help_outline,
        title: 'Aide',
        subtitle: 'Support & FAQ',
        onTap: () => _showComingSoon('Aide'),
      ),
    ]);

    return isMobile
        ? Column(
            children: [leftSection, const SizedBox(height: 24), rightSection],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: leftSection),
              const SizedBox(width: 24),
              Expanded(child: rightSection),
            ],
          );
  }

  Widget _buildSection(String title, List<_MenuItem> items) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardGrey,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          const SizedBox(height: 16),
          ...items.map(
            (item) => _HoverMenuTile(
              icon: item.icon,
              title: item.title,
              subtitle: item.subtitle,
              onTap: item.onTap,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  FOOTER
  // ─────────────────────────────────────────────
  Widget _buildFooter() {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.all(40),
      color: const Color(0xFF0F172A),
      child: Center(
        child: Text(
          '© 2026 DJIBSOUQ. All rights reserved.',
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  ACTIONS
  // ─────────────────────────────────────────────
  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: SizedBox(
            width: 480,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Éditer le profil',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 24),
                _editField(
                  label: 'Nom',
                  hint: _user?.name ?? '',
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 16),
                _editField(
                  label: 'Email',
                  hint: _user?.email ?? '',
                  icon: Icons.email_outlined,
                ),
                const SizedBox(height: 16),
                _editField(
                  label: 'Ville',
                  hint: 'Djibouti, DJ',
                  icon: Icons.location_on_outlined,
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Annuler',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryBlue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Sauvegarder',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _editField({
    required String label,
    required String hint,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: textDark,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, size: 18, color: Colors.grey),
            filled: true,
            fillColor: lightGrey,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  void _shareProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Lien de profil copié !'),
        backgroundColor: primaryBlue,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature — bientôt disponible'),
        backgroundColor: Colors.grey.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: SizedBox(
            width: 320,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Choisir la langue',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 20),
                ...['🇫🇷  Français', '🇬🇧  English', '🇸🇦  العربية'].map(
                  (lang) => ListTile(
                    title: Text(lang, style: const TextStyle(fontSize: 15)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hoverColor: primaryBlue.withOpacity(0.06),
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Langue : $lang'),
                          backgroundColor: primaryBlue,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  TAPPABLE CARD — hover animé si cliquable
// ─────────────────────────────────────────────
class _TappableCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _TappableCard({required this.child, this.onTap});

  @override
  State<_TappableCard> createState() => _TappableCardState();
}

class _TappableCardState extends State<_TappableCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final tappable = widget.onTap != null;
    return MouseRegion(
      cursor: tappable ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: (_) {
        if (tappable) setState(() => _hovered = true);
      },
      onExit: (_) {
        if (tappable) setState(() => _hovered = false);
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          decoration: BoxDecoration(
            color: cardGrey,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered
                  ? primaryBlue.withOpacity(0.3)
                  : Colors.transparent,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_hovered ? 0.08 : 0.05),
                blurRadius: _hovered ? 16 : 10,
              ),
            ],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  HOVER MENU TILE
// ─────────────────────────────────────────────
class _HoverMenuTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _HoverMenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  State<_HoverMenuTile> createState() => _HoverMenuTileState();
}

class _HoverMenuTileState extends State<_HoverMenuTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
          decoration: BoxDecoration(
            color: _hovered
                ? primaryBlue.withOpacity(0.06)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _hovered
                      ? primaryBlue.withOpacity(0.15)
                      : primaryBlue.withOpacity(0.07),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(widget.icon, color: primaryBlue, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: _hovered ? primaryBlue : textDark,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                transform: Matrix4.translationValues(_hovered ? 4 : 0, 0, 0),
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: _hovered ? primaryBlue : Colors.grey.shade300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  DATA CLASSES
// ─────────────────────────────────────────────
class _MenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });
}

class _StatItem {
  final IconData icon;
  final String value;
  final String label;
  final VoidCallback? onTap;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    this.onTap,
  });
}
