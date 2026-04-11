import 'package:flutter/material.dart';
import 'package:dj/models/product_models.dart';
import 'package:dj/widgets/product__widget/shared.dart';
import 'package:dj/widgets/product__widget/empty_state.dart';
import 'package:dj/widgets/product__widget/section.dart';

class ProductsWebContentArea extends StatelessWidget {
  final ScrollController scroll;
  final Map<String, List<Product>> grouped;
  final Map<String, GlobalKey> keys;
  final String q;

  const ProductsWebContentArea({
    required this.scroll,
    required this.grouped,
    required this.keys,
    required this.q,
  });

  @override
  Widget build(BuildContext context) {
    final hPad = Bp.hPad(context);
    return SingleChildScrollView(
      controller: scroll,
      child: Padding(
        padding: EdgeInsets.fromLTRB(hPad, 32, hPad, 48),
        child: grouped.isEmpty
            ? ProductsWebEmptyState(q: q)
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: grouped.entries
                    .map(
                      (e) => ProductsWebSection(
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
