/// Catalogue web produits : [ProductRepository], grille responsive et fiches détail.
library;

import 'package:flutter/material.dart';
import 'package:dj/data/product_repository.dart';
import 'package:dj/models/product_models.dart';
import 'package:dj/widgets/featured_product_card.dart';
import 'package:dj/widgets/web_header.dart';
import 'package:dj/layouts/web/pages_web/detail_product_popup.dart';

// ═══════════════════════════════════════════
//  DESIGN TOKENS
// ═══════════════════════════════════════════
const Color _blue900 = Color(0xFF1E3A8A);
const Color _blue700 = Color(0xFF1D4ED8);
const Color _blue50 = Color(0xFFEFF6FF);
const Color _surface = Color(0xFFFFFFFF);
const Color _bg = Color(0xFFF8FAFC);
const Color _ink = Color(0xFF0F172A);
const Color _inkMuted = Color(0xFF64748B);
const Color _border = Color(0xFFE2E8F0);

// ═══════════════════════════════════════════
//  BREAKPOINTS
// ═══════════════════════════════════════════
class _Bp {
  static double width(BuildContext c) => MediaQuery.sizeOf(c).width;
  static bool desktop(BuildContext c) => width(c) >= 1024;

  // Colonnes de grille
  static int cols(BuildContext c) {
    final w = width(c);
    if (w < 480) return 1;
    if (w < 768) return 2;
    if (w < 1280) return 3;
    return 4;
  }

  // Padding horizontal zone contenu
  static double hPad(BuildContext c) {
    final w = width(c);
    if (w < 640) return 16;
    if (w < 1024) return 28;
    return 40;
  }
}

// ═══════════════════════════════════════════
//  CATEGORY METADATA
// ═══════════════════════════════════════════
class _Meta {
  final IconData icon;
  final Color bg;
  final Color fg;
  const _Meta(this.icon, this.bg, this.fg);
}

const _metaMap = <String, _Meta>{
  'Electronique': _Meta(
    Icons.devices_rounded,
    Color(0xFFEDE9FE),
    Color(0xFF7C3AED),
  ),
  'Vetements': _Meta(
    Icons.checkroom_rounded,
    Color(0xFFFCE7F3),
    Color(0xFFDB2777),
  ),
  'Alimentation': _Meta(
    Icons.restaurant_rounded,
    Color(0xFFFEF3C7),
    Color(0xFFD97706),
  ),
  'Sport': _Meta(Icons.sports_basketball, Color(0xFFD1FAE5), Color(0xFF059669)),
  'Maison': _Meta(Icons.home_rounded, Color(0xFFEDE9FE), Color(0xFF7C3AED)),
  'Beaute': _Meta(Icons.spa_rounded, Color(0xFFFFE4E6), Color(0xFFE11D48)),
  'Livres': _Meta(
    Icons.menu_book_rounded,
    Color(0xFFDBEAFE),
    Color(0xFF2563EB),
  ),
  'Jouets': _Meta(Icons.toys_rounded, Color(0xFFFEF3C7), Color(0xFFD97706)),
  'Auto': _Meta(
    Icons.directions_car_rounded,
    Color(0xFFCCFBF1),
    Color(0xFF0F766E),
  ),
  'Jardin': _Meta(Icons.yard_rounded, Color(0xFFDCFCE7), Color(0xFF16A34A)),
};

_Meta _metaFor(String cat) =>
    _metaMap[cat] ??
    const _Meta(Icons.category_rounded, Color(0xFFF1F5F9), Color(0xFF64748B));

// ═══════════════════════════════════════════
//  POPUP ADAPTATIF
// ═══════════════════════════════════════════
void openProductPopup(BuildContext context, Product product) {
  DetailProductPopup.show(context, product: product);
}

// ═══════════════════════════════════════════
//  PAGE RACINE
// ═══════════════════════════════════════════
class ProductsWeb extends StatefulWidget {
  final String? initialCategory;
  const ProductsWeb({super.key, this.initialCategory});

  @override
  State<ProductsWeb> createState() => _ProductsWebState();
}

class _ProductsWebState extends State<ProductsWeb> {
  final _scroll = ScrollController();
  final _keys = <String, GlobalKey>{};
  String _q = '';
  String? _active;
  late Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = ProductRepository.initialize();
    _active = widget.initialCategory;
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _goto(String cat) {
    setState(() => _active = cat);
    final ctx = _keys[cat]?.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeInOut,
      );
    }
  }

  void _gotoClose(String cat, BuildContext ctx) {
    Navigator.of(ctx).pop();
    _goto(cat);
  }

  List<String> get _cats => _keys.keys.toList();

  Map<String, int> get _counts {
    final m = <String, int>{};
    for (final p in ProductRepository.products) {
      m[p.category] = (m[p.category] ?? 0) + 1;
    }
    return m;
  }

  Map<String, List<Product>> get _grouped {
    final m = <String, List<Product>>{};
    final ql = _q.toLowerCase();
    for (final p in ProductRepository.products) {
      if (_q.isEmpty ||
          p.title.toLowerCase().contains(ql) ||
          p.category.toLowerCase().contains(ql)) {
        m.putIfAbsent(p.category, () => []).add(p);
      }
    }
    return m;
  }

  // ─── BUILD ────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        _keys.clear();
        for (final p in ProductRepository.products) {
          _keys.putIfAbsent(p.category, () => GlobalKey());
        }
        if (_active != null && _keys.containsKey(_active)) {
          WidgetsBinding.instance.addPostFrameCallback((_) => _goto(_active!));
          _active = null;
        }
        final desktop = _Bp.desktop(context);
        return Scaffold(
          backgroundColor: _bg,
          drawer: desktop
              ? null
              : Drawer(
                  width: 300,
                  child: _Sidebar(
                    cats: _cats,
                    counts: _counts,
                    active: _active,
                    query: _q,
                    onSearch: (v) => setState(() => _q = v),
                    onTap: (cat) => _gotoClose(cat, context),
                    isDrawer: true,
                  ),
                ),
          body: Builder(
            builder: (scaffoldCtx) => Column(
              children: [
                desktop
                    ? buildHeader(currentPage: 'Products')
                    : _MobileBar(
                        onMenu: () => Scaffold.of(scaffoldCtx).openDrawer(),
                      ),

            // Guide des sections
            _GuideStrip(
              cats: _cats,
              counts: _counts,
              active: _active,
              onTap: _goto,
            ),

            // Corps
            Expanded(
              child: desktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 272,
                          child: _Sidebar(
                            cats: _cats,
                            counts: _counts,
                            active: _active,
                            query: _q,
                            onSearch: (v) => setState(() => _q = v),
                            onTap: _goto,
                            isDrawer: false,
                          ),
                        ),
                        Expanded(
                          child: _ContentArea(
                            scroll: _scroll,
                            grouped: _grouped,
                            keys: _keys,
                            q: _q,
                          ),
                        ),
                      ],
                    )
                  : _ContentArea(
                      scroll: _scroll,
                      grouped: _grouped,
                      keys: _keys,
                      q: _q,
                    ),
            ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ═══════════════════════════════════════════
//  SIDEBAR (partagée desktop + drawer)
// ═══════════════════════════════════════════
class _Sidebar extends StatelessWidget {
  final List<String> cats;
  final Map<String, int> counts;
  final String? active;
  final String query;
  final ValueChanged<String> onSearch;
  final ValueChanged<String> onTap;
  final bool isDrawer;

  const _Sidebar({
    required this.cats,
    required this.counts,
    required this.active,
    required this.query,
    required this.onSearch,
    required this.onTap,
    required this.isDrawer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _ink,
        image: const DecorationImage(
          image: AssetImage('assets/images/bg_stars_wb.png'),
          fit: BoxFit.cover,
          opacity: 0.18,
        ),
      ),
      child: Column(
        children: [
          // Fermer (drawer uniquement)
          if (isDrawer) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white70),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ] else
            const SizedBox(height: 28),

          // Titre
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
            child: Row(
              children: [
                Container(
                  width: 3,
                  height: 14,
                  decoration: BoxDecoration(
                    color: _blue700,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Catégories',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.6,
                  ),
                ),
              ],
            ),
          ),

          // Recherche
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            child: TextField(
              onChanged: onSearch,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.4,
              ),
              cursorColor: Colors.white54,
              decoration: InputDecoration(
                hintText: 'Rechercher…',
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.35),
                  fontSize: 13,
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: Colors.white.withOpacity(0.35),
                  size: 18,
                ),
                filled: true,
                fillColor: Colors.white.withOpacity(0.07),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Liste catégories
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 4),
              itemCount: cats.length,
              itemBuilder: (_, i) => _SideItem(
                cat: cats[i],
                count: counts[cats[i]] ?? 0,
                active: active == cats[i],
                onTap: () => onTap(cats[i]),
              ),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════
//  GUIDE STRIP — bande de navigation rapide
// ═══════════════════════════════════════════
class _GuideStrip extends StatelessWidget {
  final List<String> cats;
  final Map<String, int> counts;
  final String? active;
  final ValueChanged<String> onTap;

  const _GuideStrip({
    required this.cats,
    required this.counts,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (cats.isEmpty) return const SizedBox.shrink();

    return Container(
      color: _surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Padding(
            padding: EdgeInsets.fromLTRB(_Bp.hPad(context), 11, 16, 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.apps_rounded, size: 13, color: _inkMuted),
                const SizedBox(width: 6),
                const Text(
                  'Parcourir par section',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.6,
                    color: _inkMuted,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: _blue50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${cats.length}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: _blue700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Chips — SingleChildScrollView horizontal, hauteur intrinsèque
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.fromLTRB(
              _Bp.hPad(context),
              0,
              _Bp.hPad(context),
              12,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: cats
                  .map(
                    (cat) => _GuideChip(
                      cat: cat,
                      count: counts[cat] ?? 0,
                      active: active == cat,
                      onTap: () => onTap(cat),
                    ),
                  )
                  .toList(),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: _border),
        ],
      ),
    );
  }
}

class _GuideChip extends StatefulWidget {
  final String cat;
  final int count;
  final bool active;
  final VoidCallback onTap;
  const _GuideChip({
    required this.cat,
    required this.count,
    required this.active,
    required this.onTap,
  });
  @override
  State<_GuideChip> createState() => _GuideChipState();
}

class _GuideChipState extends State<_GuideChip> {
  bool _hov = false;

  @override
  Widget build(BuildContext context) {
    final m = _metaFor(widget.cat);
    final on = widget.active || _hov;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 170),
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
          decoration: BoxDecoration(
            color: widget.active
                ? m.fg
                : on
                ? m.bg
                : _bg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.active
                  ? m.fg
                  : on
                  ? m.fg.withOpacity(0.3)
                  : _border,
              width: widget.active ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                m.icon,
                size: 15,
                color: widget.active ? Colors.white : m.fg,
              ),
              const SizedBox(width: 7),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 100),
                child: Text(
                  widget.cat,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: widget.active
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: widget.active ? Colors.white : _ink,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: widget.active ? Colors.white.withOpacity(0.22) : m.bg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${widget.count}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: widget.active ? Colors.white : m.fg,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════
//  ZONE DE CONTENU SCROLLABLE
// ═══════════════════════════════════════════
class _ContentArea extends StatelessWidget {
  final ScrollController scroll;
  final Map<String, List<Product>> grouped;
  final Map<String, GlobalKey> keys;
  final String q;

  const _ContentArea({
    required this.scroll,
    required this.grouped,
    required this.keys,
    required this.q,
  });

  @override
  Widget build(BuildContext context) {
    final hPad = _Bp.hPad(context);
    return SingleChildScrollView(
      controller: scroll,
      child: Padding(
        padding: EdgeInsets.fromLTRB(hPad, 32, hPad, 48),
        child: grouped.isEmpty
            ? _Empty(q: q)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: grouped.entries
                    .map(
                      (e) => _Section(
                        sectionKey: keys[e.key],
                        cat: e.key,
                        products: e.value,
                      ),
                    )
                    .toList(),
              ),
      ),
    );
  }
}

// ═══════════════════════════════════════════
//  SECTION
// ═══════════════════════════════════════════
class _Section extends StatelessWidget {
  final GlobalKey? sectionKey;
  final String cat;
  final List<Product> products;

  const _Section({
    required this.sectionKey,
    required this.cat,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    final m = _metaFor(cat);
    return Container(
      key: sectionKey,
      margin: const EdgeInsets.only(bottom: 56),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header de section
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: m.bg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(m.icon, size: 18, color: m.fg),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      cat,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: _ink,
                      ),
                    ),
                    Text(
                      '${products.length} produit${products.length > 1 ? "s" : ""}',
                      style: const TextStyle(fontSize: 12, color: _inkMuted),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 2,
            width: 36,
            decoration: BoxDecoration(
              color: m.fg,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 20),
          // Grille anti-overflow : Wrap + LayoutBuilder
          LayoutBuilder(
            builder: (ctx, box) {
              final cols = _Bp.cols(ctx);
              final gap = 16.0;
              final cw = (box.maxWidth - gap * (cols - 1)) / cols;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: products.asMap().entries.map((entry) {
                  final index = entry.key;
                  final product = entry.value;
                  return SizedBox(
                    width: cw,
                    child: FeaturedProductCard(
                      product: product,
                      index: index,
                      onTap: () => openProductPopup(context, product),
                      onBuyNow: () => openProductPopup(context, product),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════
//  PRODUCT CARD — overflow-safe
// ═══════════════════════════════════════════
class _PCard extends StatefulWidget {
  final Product p;
  const _PCard({required this.p});
  @override
  State<_PCard> createState() => _PCardState();
}

class _PCardState extends State<_PCard> with SingleTickerProviderStateMixin {
  late final AnimationController _ac = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );
  late final Animation<double> _sc = Tween(
    begin: 1.0,
    end: 1.035,
  ).animate(CurvedAnimation(parent: _ac, curve: Curves.easeOutCubic));

  @override
  void dispose() {
    _ac.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.p;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _ac.forward(),
      onExit: (_) => _ac.reverse(),
      child: ScaleTransition(
        scale: _sc,
        child: GestureDetector(
          onTap: () => openProductPopup(context, p),
          child: Container(
            decoration: BoxDecoration(
              color: _surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: _border),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                AspectRatio(
                  aspectRatio: 1.05,
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: _bg,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Center(
                          child: Text(
                            p.image,
                            style: const TextStyle(fontSize: 58),
                          ),
                        ),
                        if (p.isBestSeller)
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFFEF4444),
                                    Color(0xFFF97316),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'HOT',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                // Infos
                Padding(
                  padding: const EdgeInsets.fromLTRB(13, 12, 13, 14),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _ink,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      _Stars(rating: p.rating, reviews: p.reviews),
                      const SizedBox(height: 11),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '\$${p.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: _blue900,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => openProductPopup(context, p),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: _blue900,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.add_shopping_cart_rounded,
                                color: Colors.white,
                                size: 15,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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

// ═══════════════════════════════════════════
//  ETOILES
// ═══════════════════════════════════════════
class _Stars extends StatelessWidget {
  final double rating;
  final int reviews;
  const _Stars({required this.rating, required this.reviews});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      ...List.generate(
        5,
        (i) => Icon(
          i < rating.floor() ? Icons.star_rounded : Icons.star_border_rounded,
          size: 13,
          color: const Color(0xFFF59E0B),
        ),
      ),
      const SizedBox(width: 4),
      Flexible(
        child: Text(
          '($reviews)',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 11, color: _inkMuted),
        ),
      ),
    ],
  );
}

// ═══════════════════════════════════════════
//  ETAT VIDE
// ═══════════════════════════════════════════
class _Empty extends StatelessWidget {
  final String q;
  const _Empty({required this.q});

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 320,
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: const BoxDecoration(
              color: _blue50,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.search_off_rounded,
              size: 36,
              color: _blue700,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Aucun résultat pour "$q"',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: _ink,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Essayez un autre mot-clé',
            style: TextStyle(fontSize: 13, color: _inkMuted),
          ),
        ],
      ),
    ),
  );
}

// ═══════════════════════════════════════════
//  SIDEBAR ITEM
// ═══════════════════════════════════════════
class _SideItem extends StatefulWidget {
  final String cat;
  final int count;
  final bool active;
  final VoidCallback onTap;
  const _SideItem({
    required this.cat,
    required this.count,
    required this.active,
    required this.onTap,
  });
  @override
  State<_SideItem> createState() => _SideItemState();
}

class _SideItemState extends State<_SideItem> {
  bool _hov = false;

  @override
  Widget build(BuildContext context) {
    final m = _metaFor(widget.cat);
    final on = widget.active || _hov;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: on ? Colors.white.withOpacity(0.09) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border(
              left: BorderSide(
                color: widget.active ? m.fg : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                m.icon,
                size: 16,
                color: on ? Colors.white : Colors.white.withOpacity(0.45),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.cat,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: widget.active
                        ? FontWeight.w700
                        : FontWeight.w400,
                    color: on ? Colors.white : Colors.white.withOpacity(0.55),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(on ? 0.14 : 0.07),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${widget.count}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withOpacity(on ? 0.9 : 0.4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════
//  MOBILE BAR
// ═══════════════════════════════════════════
class _MobileBar extends StatelessWidget {
  final VoidCallback onMenu;
  const _MobileBar({required this.onMenu});

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      buildHeader(currentPage: 'Products'),
      Positioned(
        left: 4,
        top: 0,
        bottom: 0,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: IconButton(
              icon: const Icon(Icons.menu_rounded, color: Colors.white),
              tooltip: 'Catégories',
              onPressed: onMenu,
            ),
          ),
        ),
      ),
    ],
  );
}
