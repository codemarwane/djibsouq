import 'package:flutter/material.dart';
import 'package:dj/widgets/product__widget/shared.dart';
import 'package:dj/widgets/product__widget/side_item.dart';

class ProductsWebSidebar extends StatelessWidget {
  final List<String> cats;
  final Map<String, int> counts;
  final String? active;
  final String query;
  final ValueChanged<String> onSearch;
  final ValueChanged<String> onTap;
  final bool isDrawer;

  const ProductsWebSidebar({
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
        color: kInk,
        image: const DecorationImage(
          image: AssetImage('assets/images/bg_stars_wb.png'),
          fit: BoxFit.cover,
          opacity: 0.18,
        ),
      ),
      child: Column(
        children: [
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
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
            child: Row(
              children: [
                Container(
                  width: 3,
                  height: 14,
                  decoration: BoxDecoration(
                    color: kBlue700,
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
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 4),
              itemCount: cats.length,
              itemBuilder: (_, i) => ProductsWebSideItem(
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
