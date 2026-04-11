import 'package:flutter/material.dart';
import 'package:dj/data/product_repository.dart';
import 'package:dj/models/product_models.dart';
import 'package:dj/widgets/web_header.dart';
import 'package:dj/widgets/product__widget/shared.dart';
import '../../../widgets/product__widget/sidebar.dart';
import '../../../widgets/product__widget/content_area.dart';
import '../../../widgets/product__widget/guide_chip.dart';

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

  @override
  void initState() {
    super.initState();
    for (final p in ProductRepository.products) {
      _keys.putIfAbsent(p.category, () => GlobalKey());
    }
    _active = widget.initialCategory;
    if (_active != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _goto(_active!));
    }
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
    final desktop = Bp.desktop(context);
    return Scaffold(
      backgroundColor: kBg,
      drawer: desktop
          ? null
          : Drawer(
              width: 300,
              child: ProductsWebSidebar(
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
            // Header
            desktop
                ? BuildHeader(currentPage: 'Products')
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
                          child: ProductsWebSidebar(
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
                          child: ProductsWebContentArea(
                            scroll: _scroll,
                            grouped: _grouped,
                            keys: _keys,
                            q: _q,
                          ),
                        ),
                      ],
                    )
                  : ProductsWebContentArea(
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
      color: kSurface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          Padding(
            padding: EdgeInsets.fromLTRB(Bp.hPad(context), 11, 16, 0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.apps_rounded, size: 13, color: kInkMuted),
                const SizedBox(width: 6),
                const Text(
                  'Parcourir par section',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.6,
                    color: kInkMuted,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 1,
                  ),
                  decoration: BoxDecoration(
                    color: kBlue50,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${cats.length}',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: kBlue700,
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
              Bp.hPad(context),
              0,
              Bp.hPad(context),
              12,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: cats
                  .map(
                    (cat) => ProductsWebGuideChip(
                      cat: cat,
                      count: counts[cat] ?? 0,
                      active: active == cat,
                      onTap: () => onTap(cat),
                    ),
                  )
                  .toList(),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: kBorder),
        ],
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
      BuildHeader(currentPage: 'Products'),
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
