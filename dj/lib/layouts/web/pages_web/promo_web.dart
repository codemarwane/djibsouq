/// Vue promos / offres : produits filtrés depuis [ProductRepository] après init.
library;

import 'package:flutter/material.dart';
import 'package:dj/widgets/web_header.dart'; // Assure-toi que c'est bien BuildHeader ou ton nom actuel
import 'package:dj/data/product_repository.dart';
import 'package:dj/models/product_models.dart';
import 'package:dj/layouts/web/pages_web/detail_product_popup.dart';
import 'package:dj/widgets/featured_product_card.dart';
import 'package:dj/services/responsive_service.dart'; // â† Important

const Color primaryBlue = Color(0xFF1E3A8A);
const Color lightGrey = Color(0xFFF3F4F6);
const Color textDark = Color(0xFF111827);

class PromoWeb extends StatefulWidget {
  final String? initialCategory;
  const PromoWeb({super.key, this.initialCategory});

  @override
  State<PromoWeb> createState() => _PromoWebState();
}

class _PromoWebState extends State<PromoWeb> {
  late String _selectedCategory;
  late Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = ProductRepository.initialize();
    _selectedCategory = widget.initialCategory ?? 'Toutes';
  }

  List<Product> get _filteredProducts {
    final all = ProductRepository.products;
    if (_selectedCategory == 'Toutes') return all.take(20).toList();
    return all.where((p) => p.category == _selectedCategory).take(20).toList();
  }

  List<String> get _categories => [
        'Toutes',
        ...ProductRepository.categories.map((c) => c.name),
      ];

  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  //  BUILD PRINCIPAL
  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        final deviceType = ResponsiveService.getDeviceType(context);
        final isMobile = deviceType == DeviceType.mobile;
        final isTablet = deviceType == DeviceType.tablet;

    // Tailles responsives
    final horizontalPadding = isMobile ? 16.0 : isTablet ? 32.0 : 60.0;
    final verticalPadding = isMobile ? 30.0 : 50.0;

        return Scaffold(
          backgroundColor: lightGrey,
          body: Column(
            children: [
              buildHeader(currentPage: 'Promo'),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding,
                      vertical: verticalPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildHeroBanner(isMobile, isTablet),
                        const SizedBox(height: 50),
                        _buildSectionHeader(isMobile),
                        const SizedBox(height: 30),
                        _buildCategoryFilters(isMobile),
                        const SizedBox(height: 40),
                        _filteredProducts.isEmpty
                            ? _buildEmptyState()
                            : _buildGrid(isMobile, isTablet),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  //  HERO BANNER RESPONSIVE
  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildHeroBanner(bool isMobile, bool isTablet) {
    final heroHeight = isMobile ? 220.0 : isTablet ? 260.0 : 280.0;
    final titleFontSize = isMobile ? 28.0 : isTablet ? 32.0 : 36.0;
    final subtitleFontSize = isMobile ? 15.0 : 17.0;

    return Container(
      width: double.infinity,
      height: heroHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isMobile ? 16 : 24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F172A), Color(0xFF1E3A8A)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A8A).withOpacity(0.35),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Cercles dÃ©coratifs (rÃ©duits sur mobile)
          if (!isMobile) ...[
            Positioned(right: -40, top: -40, child: _decorativeCircle(240)),
            Positioned(right: 80, bottom: -60, child: _decorativeCircle(180)),
          ],

          Row(
            children: [
              // Texte
              Expanded(
                flex: isMobile ? 1 : 2,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 24 : 60,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.2)),
                        ),
                        child: const Text(
                          'ðŸŽ‰  Offre limitÃ©e',
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                      ),
                      SizedBox(height: isMobile ? 12 : 16),
                      Text(
                        "PRÃ‰PAREZ L'AÃD",
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          height: 1.1,
                        ),
                      ),
                      SizedBox(height: isMobile ? 8 : 10),
                      Text(
                        '-20% sur les vÃªtements d\'AÃ¯d',
                        style: TextStyle(
                          fontSize: subtitleFontSize,
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: isMobile ? 20 : 28),
                      ElevatedButton(
                        onPressed: () => setState(() => _selectedCategory = 'Habits'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: primaryBlue,
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 24 : 32,
                            vertical: isMobile ? 12 : 16,
                          ),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: const Text(
                          'DÃ©couvrir',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Image (masquÃ©e ou rÃ©duite sur trÃ¨s petit mobile)
              if (!isMobile)
                Expanded(
                  flex: 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(isMobile ? 16 : 24),
                      bottomRight: Radius.circular(isMobile ? 16 : 24),
                    ),
                    child: Image.asset(
                      'assets/images/aid_banner.png',
                      fit: BoxFit.cover,
                      height: heroHeight,
                      errorBuilder: (_, __, ___) => Container(
                        color: Colors.white.withOpacity(0.05),
                        child: const Center(child: Text('ðŸ›ï¸', style: TextStyle(fontSize: 80))),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _decorativeCircle(double size) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.05),
        ),
      );

  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  //  SECTION HEADER
  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildSectionHeader(bool isMobile) {
    return Column(
      children: [
        Text(
          'Produits en Promotion',
          style: TextStyle(
            fontSize: isMobile ? 24 : 30,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          '${_filteredProducts.length} produit${_filteredProducts.length > 1 ? 's' : ''} disponible${_filteredProducts.length > 1 ? 's' : ''}',
          style: TextStyle(fontSize: isMobile ? 14 : 15, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  //  CATEGORY FILTERS
  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildCategoryFilters(bool isMobile) {
    return Wrap(
      spacing: isMobile ? 8 : 12,
      runSpacing: isMobile ? 8 : 12,
      alignment: WrapAlignment.center,
      children: _categories.map((cat) {
        final isSelected = _selectedCategory == cat;
        return _FilterChip(
          label: cat,
          isSelected: isSelected,
          onTap: () => setState(() => _selectedCategory = cat),
        );
      }).toList(),
    );
  }

  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  //  PRODUCT DETAIL DIALOG
  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  void _openProductDetail(Product product) {
    DetailProductPopup.show(context, product: product);
  }

  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  //  GRID RESPONSIVE
  // â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
  Widget _buildGrid(bool isMobile, bool isTablet) {
    int crossAxisCount = 4; // desktop par dÃ©faut
    double childAspectRatio = 0.72;

    if (isMobile) {
      crossAxisCount = 2;
      childAspectRatio = 0.78;
    } else if (isTablet) {
      crossAxisCount = 3;
      childAspectRatio = 0.75;
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _filteredProducts.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: isMobile ? 16 : 24,
        mainAxisSpacing: isMobile ? 16 : 24,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (_, i) => FeaturedProductCard(
        product: _filteredProducts[i],
        index: i,
        onTap: () => _openProductDetail(_filteredProducts[i]),
      ),
    );
  }

  // Empty State (inchangÃ© mais avec padding adaptÃ©)
  Widget _buildEmptyState() {
    return SizedBox(
      height: 300,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_offer_outlined, size: 60, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'Aucune promotion pour "$_selectedCategory"',
              style: TextStyle(fontSize: 16, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => setState(() => _selectedCategory = 'Toutes'),
              child: const Text('Voir toutes les promos'),
            ),
          ],
        ),
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
//  FILTER CHIP â€” hover animÃ©
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class _FilterChip extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_FilterChip> createState() => _FilterChipState();
}

class _FilterChipState extends State<_FilterChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.isSelected || _hovered;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
          decoration: BoxDecoration(
            color: widget.isSelected ? primaryBlue : active ? primaryBlue.withOpacity(0.08) : Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: widget.isSelected ? primaryBlue : primaryBlue.withOpacity(0.3),
            ),
            boxShadow: widget.isSelected
                ? [BoxShadow(color: primaryBlue.withOpacity(0.25), blurRadius: 12, offset: const Offset(0, 4))]
                : [],
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: widget.isSelected ? Colors.white : primaryBlue,
            ),
          ),
        ),
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
//  PROMO CARD
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

