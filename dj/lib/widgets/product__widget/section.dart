import 'package:flutter/material.dart';
import 'package:dj/models/product_models.dart';
import 'package:dj/widgets/featured_product_card.dart';
import 'package:dj/widgets/product__widget/shared.dart';

class ProductsWebSection extends StatelessWidget {
  final GlobalKey? sectionKey;
  final String cat;
  final List<Product> products;

  const ProductsWebSection({
    required this.sectionKey,
    required this.cat,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    final m = metaFor(cat);
    return Container(
      key: sectionKey,
      margin: const EdgeInsets.only(bottom: 56),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
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
                        color: kInk,
                      ),
                    ),
                    Text(
                      '${products.length} produit${products.length > 1 ? 's' : ''}',
                      style: const TextStyle(fontSize: 12, color: kInkMuted),
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
          LayoutBuilder(
            builder: (ctx, box) {
              final cols = Bp.cols(ctx);
              const gap = 16.0;
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
