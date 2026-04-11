import 'package:flutter/material.dart';
import 'package:dj/widgets/product__widget/shared.dart';
import 'package:dj/models/product_models.dart';

class ProductsWebPCard extends StatefulWidget {
  final Product product;

  const ProductsWebPCard({required this.product});

  @override
  State<ProductsWebPCard> createState() => _ProductsWebPCardState();
}

class _ProductsWebPCardState extends State<ProductsWebPCard>
    with SingleTickerProviderStateMixin {
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
    final p = widget.product;
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
              color: kSurface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: kBorder),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1.05,
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: kBg,
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
                          color: kInk,
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
                                color: kBlue900,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => openProductPopup(context, p),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: kBlue900,
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
              style: const TextStyle(fontSize: 11, color: kInkMuted),
            ),
          ),
        ],
      );
}
