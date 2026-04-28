import 'dart:async';
import 'package:dj/layouts/web/pages_web/categories_web.dart';
import 'package:dj/models/category_models.dart';
import 'package:dj/models/product_models.dart';
import 'package:dj/widgets/web_header.dart';
import 'package:dj/data/product_repository.dart';
import 'package:dj/widgets/hero_galaxy.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dj/widgets/featured_product_card.dart';
import 'package:dj/widgets/promo_card.dart';
import 'package:dj/widgets/best_seller_card.dart';
import 'package:dj/routes.dart';
import 'package:dj/widgets/simple_widgets.dart';

// ─────────────────────────────────────────────
//  BREAKPOINTS
// ─────────────────────────────────────────────
// mobile  : < 600
// tablet  : 600 – 1024
// desktop : > 1024

const Color primaryBlue = Color(0xFF1E3A8A);
const Color lightGrey = Color(0xFFF3F4F6);
const Color textDark = Color(0xFF111827);

const double mobileBreakpoint = 600.0;
const double tabletBreakpoint = 900.0;
const double largeBreakpoint = 1400.0;

// ─────────────────────────────────────────────
//  HOMEPAGE
// ─────────────────────────────────────────────
class HomepageWeb extends StatefulWidget {
  const HomepageWeb({super.key});

  @override
  State<HomepageWeb> createState() => _HomepageWebState();
}

class _HomepageWebState extends State<HomepageWeb> with TickerProviderStateMixin {
  String _selectedCategory = 'Toutes';
  final GlobalKey _downloadKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  late Future<void> _initFuture;

  late AnimationController _fadeController;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

  @override
  void initState() {
    super.initState();
    _initFuture = ProductRepository.initialize();
    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _fadeIn = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _slideIn = Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero)
        .animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic));
    WidgetsBinding.instance.addPostFrameCallback((_) => _fadeController.forward());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _scrollToDownload() {
    final ctx = _downloadKey.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx,
          duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
    }
  }

  IconData _iconFromName(String name) {
    const map = {
      'star': Icons.star, 'stars': Icons.star,
      'devices': Icons.devices, 'shopping_bag': Icons.shopping_bag,
      'home': Icons.home, 'sports_soccer': Icons.sports_soccer,
      'add': Icons.add,
    };
    return map[name] ?? Icons.category;
  }

  String _emojiFromIcon(String iconName) {
    const map = {
      'devices': '📱', 'shopping_bag': '👕',
      'home': '🏠', 'sports_soccer': '⚽',
    };
    return map[iconName] ?? '🛍️';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        if (_selectedCategory == 'Toutes' && ProductRepository.categories.isNotEmpty) {
          _selectedCategory = ProductRepository.categories.first.name;
        }
        return Scaffold(
          backgroundColor: lightGrey,
          body: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                buildHeader(currentPage: 'Home'),
                HeroGalaxy(onDownloadTap: _scrollToDownload),
                FadeTransition(
                  opacity: _fadeIn,
                  child: SlideTransition(
                    position: _slideIn,
                    child: Column(
                      children: [
                        _buildBestSellers(),
                        _buildPromoCarousel(),
                        _buildCategoriesBar(),
                        _buildFeaturedProducts(),
                        _buildDownloadSection(),
                        _buildWhyShop(),
                        _buildNewsletterSection(),
                        _buildFooter(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBestSellers() {
    final bestSellers = ProductRepository.getBestSellers();
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < mobileBreakpoint;
      final isLarge = constraints.maxWidth >= largeBreakpoint;
      return Container(
        padding: EdgeInsets.symmetric(vertical: isMobile ? 40 : 60),
        color: Colors.white,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isLarge ? 1400 : 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 0),
                  child: SectionLabel(label: '🔥 Best Sellers'),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  height: isMobile ? 200 : 220,
                  child: _BestSellerCarousel(products: bestSellers, isMobile: isMobile),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  // ─────────────────────────────────────────────
  // PROMO CAROUSEL — OPTIMISÉ & RESPONSIVE
  // ─────────────────────────────────────────────
  Widget _buildPromoCarousel() {
    final promoCategories =
        ProductRepository.categories.where((c) => c.name != 'New Arrivals').toList();

    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < mobileBreakpoint;

      return Container(
        padding: EdgeInsets.symmetric(vertical: isMobile ? 40 : 60),
        color: lightGrey,
        child: Center(
          child: SizedBox(
            width: constraints.maxWidth > 1200
                ? 1250
                : constraints.maxWidth * (isMobile ? 0.95 : 0.9),
            child: Column(
              children: [
                SectionLabel(label: '🎉 Promotions Spéciales', center: true),
                const SizedBox(height: 8),
                const Text(
                  'Découvrez nos offres exceptionnelles par catégorie',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: isMobile ? 28 : 40),

                // Liste horizontale
                SizedBox(
                  height: isMobile ? 185 : 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 0),
                    itemCount: promoCategories.length,
                    itemBuilder: (context, i) {
                      final cat = promoCategories[i];
                      return SizedBox(
                        width: isMobile ? 175 : 280,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 8 : 15,
                          ),
                          child: PromoCard(
                            title: cat.name,
                            description: "Jusqu'à -20% sur nos ${cat.name.toLowerCase()}",
                            emoji: _emojiFromIcon(cat.icon),
                            color: cat.color,
                            categoryName: cat.name,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  // ─────────────────────────────────────────────
  //  CATEGORIES BAR
  // ─────────────────────────────────────────────
  Widget _buildCategoriesBar() {
    final allCategories = [
      ...ProductRepository.categories,
      Category(name: 'Toutes', icon: 'list_alt', color: Colors.purpleAccent.shade400, id: 10000, image: ''),
    ];

    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < mobileBreakpoint;

      if (isMobile) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: allCategories.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 2.1,
            ),
            itemBuilder: (context, i) {
              final cat = allCategories[i];
              final isLast = i == allCategories.length - 1;
              return _AnimatedCategoryCard(
                icon: _iconFromName(cat.icon),
                title: cat.name,
                color: cat.color,
                delay: i * 60,
                isMobile: true,
                isSelected: !isLast && _selectedCategory == cat.name,
                onTap: isLast
                    ? () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const CategoriesWeb()))
                    : () => setState(() => _selectedCategory = cat.name),
              );
            },
          ),
        );
      }

      // Tablet & Desktop
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        child: Row(
          children: List.generate(allCategories.length, (i) {
            final cat = allCategories[i];
            final isLast = i == allCategories.length - 1;
            return Flexible(
              fit: FlexFit.tight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: _AnimatedCategoryCard(
                  icon: _iconFromName(cat.icon),
                  title: cat.name,
                  color: cat.color,
                  delay: i * 80,
                  isSelected: !isLast && _selectedCategory == cat.name,
                  onTap: isLast
                      ? () => Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const CategoriesWeb()))
                      : () => setState(() => _selectedCategory = cat.name),
                ),
              ),
            );
          }),
        ),
      );
    });
  }

  // ─────────────────────────────────────────────
  //  FEATURED PRODUCTS
  // ─────────────────────────────────────────────
  Widget _buildFeaturedProducts() {
    final products = ProductRepository.getProductsByCategory(_selectedCategory);
    final limited = products.length > 8 ? products.sublist(0, 8) : products;

    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < mobileBreakpoint;
      final isTablet = constraints.maxWidth < tabletBreakpoint;
      final isLarge = constraints.maxWidth >= largeBreakpoint;

      int crossAxis = 4;
      double aspectRatio = 0.85;

      if (isMobile) {
        crossAxis = 2;
        aspectRatio = 0.68; // 🔥 plus de hauteur
      } else if (isTablet) {
        crossAxis = 3;
        aspectRatio = 0.72;
      } else if (isLarge) {
        crossAxis = 5;
        aspectRatio = 0.9;
      }

      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : isLarge ? 32 : 24,
          vertical: isMobile ? 32 : 40,
        ),
        color: Colors.white,
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isLarge ? 1600 : 1300),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _selectedCategory,
                            style: TextStyle(
                              fontSize: isMobile ? 22 : 26,
                              fontWeight: FontWeight.bold,
                              color: textDark,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Container(
                                width: 32,
                                height: 3,
                                decoration: BoxDecoration(color: primaryBlue, borderRadius: BorderRadius.circular(10)),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                width: 8,
                                height: 3,
                                decoration: BoxDecoration(
                                  color: primaryBlue.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (products.length > 8)
                      SeeMoreButton(
                        onTap: () => Navigator.pushNamed(
                          context,
                          AppRoutes.products,
                          arguments: _selectedCategory,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                limited.isEmpty
                    ? EmptyCategory(category: _selectedCategory)
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: limited.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxis,
                          mainAxisSpacing: isMobile ? 16 : isLarge ? 24 : 20,
                          crossAxisSpacing: isMobile ? 16 : isLarge ? 24 : 20,
                          childAspectRatio: aspectRatio,
                        ),
                        itemBuilder: (_, i) => FeaturedProductCard(
                          product: limited[i],
                          index: i,
                        ),
                      ),
              ],
            ),
          ),
        ),
      );
    });
  }

  // ─────────────────────────────────────────────
  //  DOWNLOAD SECTION
  // ─────────────────────────────────────────────
  Widget _buildDownloadSection() {
    return Container(
      key: _downloadKey,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF1E3A8A)],
        ),
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        final isMobile = constraints.maxWidth < mobileBreakpoint;

        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? 60 : 80,
            horizontal: isMobile ? 24 : 60,
          ),
          child: isMobile
              ? Column(
                  children: [
                    _downloadTextSection(isMobile: true),
                    const SizedBox(height: 40),
                    Center(
                      child: deviceImage(
                        image: 'assets/images/swift_phone.png',
                        height: 260,
                        scale: 1.05,
                        isPrimary: true,
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: _downloadTextSection()),
                    const SizedBox(width: 50),
                    Expanded(child: _downloadDeviceSection()),
                  ],
                ),
        );
      }),
    );
  }

  Widget _downloadTextSection({bool isMobile = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Shop Smarter with\nDJIBSOUQ Mobile App',
          style: TextStyle(
            fontSize: isMobile ? 32 : 40,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Browse thousands of products, track orders instantly\nand get exclusive mobile-only deals.',
          style: TextStyle(fontSize: isMobile ? 15.5 : 18, color: Colors.white70, height: 1.55),
        ),
        const SizedBox(height: 28),
        _featureItem(Icons.flash_on, 'Exclusive Flash Deals'),
        _featureItem(Icons.notifications_active, 'Real-time Order Tracking'),
        _featureItem(Icons.security, 'Secure & Fast Checkout'),
        const SizedBox(height: 40),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.greenAccent.shade400,
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 24 : 28,
              vertical: isMobile ? 16 : 18,
            ),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          onPressed: () => launchUrl(
            Uri.parse('https://play.google.com/store/apps/details?id=com.djibsouq.app'),
            mode: LaunchMode.externalApplication,
          ),
          icon: const Icon(Icons.android, color: Colors.black),
          label: const Text('Download on Play Store',
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _downloadDeviceSection() {
    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth;
      final stackH = w < 500 ? w * 0.95 : 420.0;
      final computerH = stackH * 0.70;
      final padH = stackH * 0.52;
      final phoneH = stackH * 0.55;

      return SizedBox(
        height: stackH,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: stackH, height: stackH,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Colors.blueAccent.withOpacity(0.25), Colors.transparent],
                ),
              ),
            ),
            Positioned(
              left: w * 0.04,
              top: 0, bottom: 0,
              child: Align(
                alignment: Alignment.centerLeft,
                child: deviceImage(
                  image: 'assets/images/swift_computer.png',
                  height: computerH,
                  scale: 1.05,
                  opacity: 0.95,
                ),
              ),
            ),
            Positioned(
              right: w * 0.10,
              bottom: stackH * 0.05,
              child: deviceImage(
                image: 'assets/images/swift_pad.png',
                height: padH,
                scale: 1.05,
              ),
            ),
            Positioned(
              bottom: stackH * 0.02,
              child: deviceImage(
                image: 'assets/images/swift_phone.png',
                height: phoneH,
                scale: 1.1,
                isPrimary: true,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _featureItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.greenAccent.shade400, size: 22),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(color: Colors.white70, fontSize: 16)),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  WHY SHOP
  // ─────────────────────────────────────────────
  Widget _buildWhyShop() {
    final items = [
      WhyItem(icon: Icons.local_shipping, title: 'Free Delivery', subtitle: 'Fast shipping across Djibouti'),
      WhyItem(icon: Icons.lock, title: 'Secure Payment', subtitle: 'Encrypted & safe checkout'),
      WhyItem(icon: Icons.verified, title: 'Quality Products', subtitle: 'Verified sellers & brands'),
      WhyItem(icon: Icons.support_agent, title: '24/7 Support', subtitle: "We're here anytime"),
    ];

    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < mobileBreakpoint;
      return Container(
        padding: EdgeInsets.symmetric(vertical: isMobile ? 32 : 40, horizontal: isMobile ? 16 : 40),
        color: lightGrey,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: isMobile
                ? Column(children: items.map((e) => Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: e)).toList())
                : Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: items.map((e) => Expanded(child: e)).toList()),
          ),
        ),
      );
    });
  }

  // ─────────────────────────────────────────────
  //  NEWSLETTER
  // ─────────────────────────────────────────────
  Widget _buildNewsletterSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFF2A2D43), Color(0xFF1E3A8A)]),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: LayoutBuilder(builder: (context, constraints) {
            final isSmall = constraints.maxWidth < 700;
            return Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.1)),
              ),
              child: isSmall
                  ? Column(children: [_newsletterBox(isMobile: true), const SizedBox(height: 30), _socialRow()])
                  : Row(children: [
                      Expanded(flex: 3, child: _newsletterBox()),
                      const SizedBox(width: 40),
                      Expanded(flex: 2, child: _socialRow()),
                    ]),
            );
          }),
        ),
      ),
    );
  }

  Widget _newsletterBox({bool isMobile = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Never Miss a Deal!',
            style: TextStyle(fontSize: isMobile ? 22 : 30, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 12),
        const Text(
          'Subscribe to get exclusive offers, new arrivals, and updates straight to your inbox.',
          style: TextStyle(fontSize: 16, color: Colors.white70, height: 1.5),
        ),
        const SizedBox(height: 24),
        isMobile
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _emailField(),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      backgroundColor: Colors.greenAccent.shade400,
                    ),
                    child: const Text('Subscribe',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(child: _emailField()),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      backgroundColor: Colors.greenAccent.shade400,
                    ),
                    child: const Text('Subscribe',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ],
              ),
      ],
    );
  }

  Widget _emailField() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Your email',
        hintStyle: const TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  Widget _socialRow() {
    const socials = [
      (icon: Icons.facebook, color: Colors.blue),
      (icon: Icons.camera_alt, color: Colors.purple),
      (icon: Icons.chat, color: Colors.lightBlue),
      (icon: Icons.video_call, color: Colors.red),
    ];
    return Wrap(
      spacing: 16, runSpacing: 16, alignment: WrapAlignment.center,
      children: socials.map((s) => SocialChip(icon: s.icon, color: s.color)).toList(),
    );
  }

  // ─────────────────────────────────────────────
  //  FOOTER
  // ─────────────────────────────────────────────
  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      color: const Color(0xFF080F1E),
      child: Column(
        children: [
          Container(
            height: 3,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6), Color(0xFF1E3A8A)],
              ),
            ),
          ),
          LayoutBuilder(builder: (context, constraints) {
            final isMobile = constraints.maxWidth < mobileBreakpoint;
            return Padding(
              padding: EdgeInsets.symmetric(
                vertical: 64,
                horizontal: isMobile ? 24 : 60,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1300),
                  child: LayoutBuilder(builder: (context, c) {
                    final isSmall = c.maxWidth < 900;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        isSmall
                            ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                _FooterColumnLogo(),
                                const SizedBox(height: 40),
                                _FooterColumnLinks(),
                                const SizedBox(height: 40),
                                _FooterColumnCustomer(),
                                const SizedBox(height: 40),
                                _FooterColumnSocials(),
                              ])
                            : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Expanded(flex: 3, child: _FooterColumnLogo()),
                                Expanded(flex: 2, child: _FooterColumnLinks()),
                                Expanded(flex: 2, child: _FooterColumnCustomer()),
                                Expanded(flex: 2, child: _FooterColumnSocials()),
                              ]),
                        const SizedBox(height: 56),
                        Container(height: 1, color: Colors.white.withOpacity(0.08)),
                        const SizedBox(height: 28),
                        LayoutBuilder(builder: (context, c2) {
                          final narrow = c2.maxWidth < 700;
                          return narrow
                              ? Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                  Text('© 2026 DJIBSOUQ. All rights reserved.',
                                      style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 13)),
                                  const SizedBox(height: 12),
                                  Wrap(spacing: 16, children: [
                                    _FooterLink('Privacy'),
                                    _FooterLink('Terms'),
                                    _FooterLink('Cookies'),
                                  ]),
                                ])
                              : Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                  Text('© 2026 DJIBSOUQ. All rights reserved.',
                                      style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 13)),
                                  Row(children: [
                                    _FooterLink('Privacy Policy'),
                                    const SizedBox(width: 24),
                                    _FooterLink('Terms of Service'),
                                    const SizedBox(width: 24),
                                    _FooterLink('Cookies'),
                                  ]),
                                ]);
                        }),
                      ],
                    );
                  }),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}









// ─────────────────────────────────────────────
//  ANIMATED CATEGORY CARD — responsive
// ─────────────────────────────────────────────
class _AnimatedCategoryCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final Color color;
  final int delay;
  final VoidCallback? onTap;
  final bool isSelected;
  final bool isMobile;

  const _AnimatedCategoryCard({
    required this.icon,
    required this.title,
    required this.color,
    this.delay = 0,
    this.onTap,
    this.isSelected = false,
    this.isMobile = false,
  });

  @override
  State<_AnimatedCategoryCard> createState() => _AnimatedCategoryCardState();
}

class _AnimatedCategoryCardState extends State<_AnimatedCategoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _scaleAnim = Tween<double>(begin: 1, end: 1.08)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) { _controller.forward(); setState(() => _hovered = true); },
      onExit: (_) { _controller.reverse(); setState(() => _hovered = false); },
      child: GestureDetector(
        onTap: widget.onTap,
        child: ScaleTransition(
          scale: _scaleAnim,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: widget.isMobile ? double.infinity : 180,
            height: widget.isMobile ? 60 : 100,
            margin: EdgeInsets.symmetric(horizontal: widget.isMobile ? 0 : 6),
            padding: EdgeInsets.symmetric(
              horizontal: widget.isMobile ? 12 : 16,
              vertical: widget.isMobile ? 8 : 12,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withOpacity(widget.isSelected ? 0.35 : 0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
              border: Border.all(
                color: (_hovered || widget.isSelected) ? widget.color : Colors.transparent,
                width: 2,
              ),
              image: const DecorationImage(
                image: AssetImage('assets/images/bg_stars_wb.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(widget.isSelected ? 0.55 : 0.4),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: widget.color.withOpacity(0.2), shape: BoxShape.circle),
                    padding: EdgeInsets.all(widget.isMobile ? 6 : 10),
                    child: Icon(widget.icon, color: widget.color, size: widget.isMobile ? 18 : 28),
                  ),
                  SizedBox(width: widget.isMobile ? 8 : 14),
                  Expanded(
                    child: Text(widget.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: widget.isMobile ? 13 : 16,
                        ),
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  BEST SELLER CAROUSEL — responsive
// ─────────────────────────────────────────────
class _BestSellerCarousel extends StatefulWidget {
  final List<Product> products;
  final bool isMobile;
  const _BestSellerCarousel({required this.products, this.isMobile = false});

  @override
  State<_BestSellerCarousel> createState() => _BestSellerCarouselState();
}

class _BestSellerCarouselState extends State<_BestSellerCarousel> {
  late final PageController _pageController;
  Timer? _timer;
  int _currentPage = 0;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: widget.isMobile ? 0.6 : 0.25);
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_isHovered) return;
      _currentPage++;
      _pageController.animateToPage(_currentPage,
          duration: const Duration(milliseconds: 800), curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _moveTo(int step) {
    _currentPage = (_currentPage + step).clamp(0, widget.products.length * 1000);
    _pageController.animateToPage(_currentPage,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _isHovered = true,
      onExit: (_) => _isHovered = false,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PageView.builder(
            controller: _pageController,
            itemBuilder: (_, i) {
              final product = widget.products[i % widget.products.length];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: BestSellerCard(product: product),
              );
            },
          ),
          Positioned(
            left: 4,
            child: IconButton(
              icon: const CircleAvatar(radius: 18, backgroundColor: Colors.white,
                  child: Icon(Icons.chevron_left, color: Colors.black87)),
              onPressed: () => _moveTo(-2),
            ),
          ),
          Positioned(
            right: 4,
            child: IconButton(
              icon: const CircleAvatar(radius: 18, backgroundColor: Colors.white,
                  child: Icon(Icons.chevron_right, color: Colors.black87)),
              onPressed: () => _moveTo(2),
            ),
          ),
        ],
      ),
    );
  }
}



// ─────────────────────────────────────────────
//  SOCIAL CHIP
// ─────────────────────────────────────────────
class _SocialChip extends StatefulWidget {
  final IconData icon;
  final Color color;
  const _SocialChip({required this.icon, required this.color});

  @override
  State<_SocialChip> createState() => _SocialChipState();
}

class _SocialChipState extends State<_SocialChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () {},
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.all(_hovered ? 16 : 14),
          decoration: BoxDecoration(
            color: widget.color.withOpacity(_hovered ? 1.0 : 0.85),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(_hovered ? 0.7 : 0.4),
                blurRadius: _hovered ? 18 : 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(widget.icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  FOOTER WIDGETS (inchangés)
// ─────────────────────────────────────────────
class _FooterColumnLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Image.asset('assets/images/logo.png', height: 36),
          const SizedBox(width: 10),
          const Text('DJIBSOUQ',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20, letterSpacing: 1.5)),
        ]),
        const SizedBox(height: 16),
        Text('Your Online Command Hub\nin Djibouti.',
            style: TextStyle(color: Colors.white.withOpacity(0.45), fontSize: 14, height: 1.7)),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.android, color: Colors.greenAccent.shade400, size: 20),
              const SizedBox(width: 8),
              Text('Available on Play Store',
                  style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 13)),
            ],
          ),
        ),
      ],
    );
  }
}

class _FooterColumnLinks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const links = ['Home', 'Categories', 'Best Sellers', 'Featured Products', 'Contact'];
    return _FooterColumn(title: 'Quick Links', children: links.map((l) => _FooterNavLink(l)).toList());
  }
}

class _FooterColumnCustomer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const services = ['Help Center', 'Returns', 'Shipping Info', 'Track Orders', 'Gift Cards'];
    return _FooterColumn(title: 'Customer Service', children: services.map((s) => _FooterNavLink(s)).toList());
  }
}

class _FooterColumnSocials extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const socials = [
      (icon: Icons.facebook, color: Color(0xFF1877F2)),
      (icon: Icons.camera_alt, color: Color(0xFFE1306C)),
      (icon: Icons.chat, color: Color(0xFF29B6F6)),
      (icon: Icons.video_call, color: Color(0xFFFF0000)),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FooterSectionTitle('Follow Us'),
        const SizedBox(height: 20),
        Wrap(spacing: 12, runSpacing: 12,
            children: socials.map((s) => SocialChip(icon: s.icon, color: s.color)).toList()),
        const SizedBox(height: 28),
        _FooterSectionTitle('Contact'),
        const SizedBox(height: 12),
        _FooterContactRow(Icons.email_outlined, 'hello@djibsouq.dj'),
        const SizedBox(height: 8),
        _FooterContactRow(Icons.phone_outlined, '+253 77 00 00 00'),
      ],
    );
  }
}

class _FooterColumn extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _FooterColumn({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_FooterSectionTitle(title), const SizedBox(height: 16), ...children],
    );
  }
}

class _FooterSectionTitle extends StatelessWidget {
  final String text;
  const _FooterSectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14, letterSpacing: 0.5));
  }
}

class _FooterNavLink extends StatefulWidget {
  final String label;
  const _FooterNavLink(this.label);

  @override
  State<_FooterNavLink> createState() => _FooterNavLinkState();
}

class _FooterNavLinkState extends State<_FooterNavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 180),
            style: TextStyle(fontSize: 14, color: _hovered ? Colors.white : Colors.white.withOpacity(0.4)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: _hovered ? 12 : 0,
                  child: _hovered
                      ? const Icon(Icons.arrow_forward, size: 10, color: Colors.white)
                      : const SizedBox.shrink(),
                ),
                if (_hovered) const SizedBox(width: 4),
                Text(widget.label),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FooterContactRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _FooterContactRow(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 15, color: Colors.white.withOpacity(0.35)),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.4))),
      ],
    );
  }
}

class _FooterLink extends StatefulWidget {
  final String label;
  const _FooterLink(this.label);

  @override
  State<_FooterLink> createState() => _FooterLinkState();
}

class _FooterLinkState extends State<_FooterLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () {},
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 180),
          style: TextStyle(fontSize: 13, color: _hovered ? Colors.white : Colors.white.withOpacity(0.35)),
          child: Text(widget.label),
        ),
      ),
    );
  }
}