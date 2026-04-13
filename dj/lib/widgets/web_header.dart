import 'package:dj/layouts/web/pages_web/promo_web.dart';
import 'package:dj/layouts/web/pages_web/services_louer.dart';
import 'package:dj/layouts/web/pages_web/contact_us.dart';
import 'package:dj/layouts/web/pages_web/about_us.dart';
import 'package:flutter/material.dart';
import 'package:dj/layouts/web/home_web.dart';
import 'package:dj/layouts/web/pages_web/cart_web.dart';
import 'package:dj/layouts/web/pages_web/categories_web.dart';
import 'package:dj/layouts/web/pages_web/favorites_web.dart';
import 'package:dj/layouts/web/pages_web/products_web.dart';
import 'package:dj/layouts/web/pages_web/profile_web.dart';
import 'package:dj/services/responsive_service.dart';
import 'package:dj/auth_page.dart';
import 'package:dj/layouts/web/pages_web/Admin_web/admin_dashboard.dart';


const Color primaryBlue = Color(0xFF1E3A8A);
const Color textDark = Color(0xFF111827);

// ─────────────────────────────────────────────
//  TRANSITION PERSONNALISÉE : Fade + Slide G→D
// ─────────────────────────────────────────────
class FadeSlideRoute extends PageRouteBuilder {
  final Widget page;

  FadeSlideRoute({required this.page})
      : super(
          transitionDuration: const Duration(milliseconds: 400),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Slide léger : vient de la gauche (-6% de la largeur)
            final slide = Tween<Offset>(
              begin: const Offset(-0.06, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

            // Fade : 0 → 1
            final fade = CurvedAnimation(parent: animation, curve: Curves.easeIn);

            return FadeTransition(
              opacity: fade,
              child: SlideTransition(position: slide, child: child),
            );
          },
        );
}

// ─────────────────────────────────────────────
//  HELPER : navigate avec FadeSlideRoute
// ─────────────────────────────────────────────
void navigateTo(BuildContext context, Widget page, {bool replace = false}) {
  if (replace) {
    Navigator.pushReplacement(context, FadeSlideRoute(page: page));
  } else {
    Navigator.push(context, FadeSlideRoute(page: page));
  }
}

// ─────────────────────────────────────────────
//  HEADER
// ─────────────────────────────────────────────
class BuildHeader extends StatefulWidget {
  final String currentPage;

  const BuildHeader({super.key, required this.currentPage});

  @override
  State<BuildHeader> createState() => _BuildHeaderState();
}

class _BuildHeaderState extends State<BuildHeader> {
  late String selectedItem;

  @override
  void initState() {
    super.initState();
    selectedItem = widget.currentPage;
  }

  void _navigate(String title) {
    setState(() => selectedItem = title);
    switch (title) {
      case 'Home':
        navigateTo(context, const HomepageWeb(), replace: true);
        break;
      case 'Categories':
        navigateTo(context, const CategoriesWeb());
        break;
      case 'Products':
        navigateTo(context, const ProductsWeb());
        break;
      case 'Promo':
        navigateTo(context, const PromoWeb());
        break;
      case 'Profil':
        navigateTo(context, const ProfileWeb());
        break;
      case 'Favoris':
        navigateTo(context, const FavoritesWeb());
      break;
      case 'admin':
      navigateTo(context, const AdminDashboard());
      break;
    }
  }

  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Home', 'Categories', 'Products', 'Promo', 'Profil', 'Favoris']
              .map((title) => ListTile(
                    title: Text(title),
                    onTap: () {
                      Navigator.pop(context);
                      _navigate(title);
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final navItems = ['Home', 'Categories', 'Products', 'Promo'];
    final deviceType = ResponsiveService.getDeviceType(context);
    final isMobile = deviceType == DeviceType.mobile;
    final isTablet = deviceType == DeviceType.tablet;

    // Tailles responsives
    final horizontalPadding = isMobile ? 16.0 : isTablet ? 32.0 : 60.0;
    final verticalPadding = isMobile ? 12.0 : 18.0;
    final logoSize = isMobile ? 32.0 : 40.0;
    final logoFontSize = isMobile ? 16.0 : 18.0;
    final iconSpacing = isMobile ? 4.0 : 6.0;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ── LOGO ──
          Flexible(
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => navigateTo(context, const HomepageWeb(), replace: true),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/images/logo.png', width: logoSize, height: logoSize),
                    SizedBox(width: isMobile ? 6 : 8),
                    Flexible(
                      child: Text(
                        'DJIBSOUQ',
                        style: TextStyle(
                          fontSize: logoFontSize,
                          fontWeight: FontWeight.bold,
                          color: primaryBlue,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (!isMobile) ...[
            // ── NAV ──
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: navItems
                    .map((title) => NavItemWeb(
                          title: title,
                          isSelected: selectedItem == title,
                          onTap: () => _navigate(title),
                          deviceType: deviceType,
                        ))
                    .toList(),
              ),
            ),

            SizedBox(width: isTablet ? 20 : 30),
          ] else ...[
            // Mobile: Hamburger menu
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => _showMobileMenu(context),
            ),
          ],

          // ── ICONS ──
          Flexible(
            child: Wrap(
              spacing: iconSpacing,
              runSpacing: iconSpacing,
              alignment: WrapAlignment.end,
              children: [
                _HeaderIcon(
                  icon: Icons.search,
                  activeIcon: Icons.search,
                  isActive: false,
                  tooltip: 'Rechercher',
                  onTap: () {},
                  deviceType: deviceType,
                ),
                _HeaderIcon(
                  icon: Icons.login,
                  activeIcon: Icons.login,
                  isActive: false,
                  tooltip: 'Se connecter',
                  onTap: () => navigateTo(context, const AuthPage()),
                  deviceType: deviceType,
                ),
                if (!isMobile || selectedItem == 'Profil') // Masquer sur mobile sauf si actif
                  _HeaderIcon(
                    icon: Icons.person_outline,
                    activeIcon: Icons.person,
                    isActive: selectedItem == 'Profil',
                    tooltip: 'Profil',
                    onTap: () => navigateTo(context, const ProfileWeb()),
                    deviceType: deviceType,
                  ),
                if (!isMobile || selectedItem == 'Favoris') // Masquer sur mobile sauf si actif
                  _HeaderIcon(
                    icon: Icons.favorite_border,
                    activeIcon: Icons.favorite,
                    isActive: selectedItem == 'Favoris',
                    tooltip: 'Favoris',
                    onTap: () => navigateTo(context, const FavoritesWeb()),
                    deviceType: deviceType,
                  ),
                _HeaderIcon(
                  icon: Icons.shopping_cart_outlined,
                  activeIcon: Icons.shopping_cart,
                  isActive: selectedItem == 'Panier',
                  tooltip: 'Panier',
                  badge: 3,
                  onTap: () => navigateTo(context, const CartWeb()),
                  deviceType: deviceType,
                ),
                _HeaderIcon(
                  icon: Icons.more_vert, 
                  activeIcon: Icons.more_vert, 
                  isActive: false, 
                  tooltip: 'Plus', 
                  onTap: () {
                    // Afficher un menu contextuel avec les options supplémentaires
                    showMenu(
                      context: context,
                      position: const RelativeRect.fromLTRB(1000, 80, 16, 0), // Positionner en haut à droite
                      items: [
                        PopupMenuItem(
                          child: const Text('Services'),
                          onTap: () => navigateTo(context, const ServicesPage()),
                        ),
                        PopupMenuItem(
                          child: const Text('Contactez-nous'),
                          onTap: () => navigateTo(context, const ContactUsWeb()),
                        ),
                        PopupMenuItem(
                          child: const Text('À propos de nous'),
                          onTap: () => navigateTo(context, const AboutUsWeb()),
                        ),
                        PopupMenuItem(
                          child: const Text('Admin Dashboard'),
                          onTap: () => navigateTo(context, const AdminDashboard()),
                        ),
                      ],
                    );
                  }, 
                  deviceType: deviceType
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  HEADER ICON
// ─────────────────────────────────────────────
class _HeaderIcon extends StatefulWidget {
  final IconData icon;
  final IconData activeIcon;
  final bool isActive;
  final String tooltip;
  final VoidCallback onTap;
  final int? badge;
  final DeviceType deviceType;

  const _HeaderIcon({
    required this.icon,
    required this.activeIcon,
    required this.isActive,
    required this.tooltip,
    required this.onTap,
    this.badge,
    required this.deviceType,
  });

  @override
  State<_HeaderIcon> createState() => _HeaderIconState();
}

class _HeaderIconState extends State<_HeaderIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _scale = Tween<double>(begin: 1.0, end: 1.25).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool showActive = widget.isActive || _hovered;
    final isMobile = widget.deviceType == DeviceType.mobile;
    final isTablet = widget.deviceType == DeviceType.tablet;

    // Tailles responsives
    final iconSize = widget.isActive
        ? (isMobile ? 24.0 : isTablet ? 26.0 : 26.0)
        : (isMobile ? 20.0 : isTablet ? 22.0 : 22.0);
    final padding = isMobile ? 8.0 : 10.0;
    final badgeSize = isMobile ? 15.0 : 17.0;
    final badgeFontSize = isMobile ? 9.0 : 10.0;

    return Tooltip(
      message: widget.tooltip,
      preferBelow: true,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          setState(() => _hovered = true);
          _controller.forward();
        },
        onExit: (_) {
          setState(() => _hovered = false);
          if (!widget.isActive) _controller.reverse();
        },
        child: GestureDetector(
          onTap: widget.onTap,
          child: ScaleTransition(
            scale: _scale,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.all(padding),
                  decoration: BoxDecoration(
                    color: showActive ? primaryBlue.withOpacity(0.08) : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      showActive ? widget.activeIcon : widget.icon,
                      key: ValueKey(showActive),
                      size: iconSize,
                      color: showActive ? primaryBlue : Colors.grey.shade600,
                    ),
                  ),
                ),
                if (widget.badge != null && widget.badge! > 0)
                  Positioned(
                    top: isMobile ? 2 : 4,
                    right: isMobile ? 2 : 4,
                    child: Container(
                      width: badgeSize,
                      height: badgeSize,
                      decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
                      child: Center(
                        child: Text(
                          '${widget.badge}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: badgeFontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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
//  NAV ITEM
// ─────────────────────────────────────────────
class NavItemWeb extends StatefulWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  final DeviceType deviceType;

  const NavItemWeb({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
    required this.deviceType,
  });

  @override
  State<NavItemWeb> createState() => _NavItemWebState();
}

class _NavItemWebState extends State<NavItemWeb> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isTablet = widget.deviceType == DeviceType.tablet;

    // Tailles responsives
    final horizontalMargin = isTablet ? 10.0 : 15.0;
    final fontSize = isTablet ? 15.0 : 16.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: EdgeInsets.symmetric(horizontal: horizontalMargin),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: widget.isSelected
                    ? primaryBlue
                    : _hovered
                        ? primaryBlue.withOpacity(0.6)
                        : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 250),
            style: TextStyle(
              fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.w500,
              color: widget.isSelected
                  ? primaryBlue
                  : _hovered
                      ? primaryBlue.withOpacity(0.8)
                      : textDark,
              fontSize: fontSize,
            ),
            child: Text(widget.title),
          ),
        ),
      ),
    );
  }
}
