import 'package:flutter/material.dart';
import 'package:dj/widgets/product__widget/shared.dart';

class ProductsWebEmptyState extends StatelessWidget {
  final String q;

  const ProductsWebEmptyState({required this.q});

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
                  color: kBlue50,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.search_off_rounded,
                  size: 36,
                  color: kBlue700,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Aucun résultat pour "${q}"',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: kInk,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Essayez un autre mot-clé',
                style: TextStyle(fontSize: 13, color: kInkMuted),
              ),
            ],
          ),
        ),
      );
}