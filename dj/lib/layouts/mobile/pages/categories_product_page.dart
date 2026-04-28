/// Liste produits pour un nom de catégorie (filtre sur le cache [ProductRepository]).
library;

import 'package:dj/data/product_repository.dart';
import 'package:flutter/material.dart';

// Couleurs cohérentes avec ton app
const Color primaryBlue = Color(0xFF1E3A8A);
const Color lightGrey = Color(0xFFF3F4F6);
const Color cardGrey = Color(0xFFE5E7EB);

class CategoryProductsPage extends StatelessWidget {
  final String categoryName;

  const CategoryProductsPage({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: ProductRepository.initialize(),
      builder: (context, snapshot) {
        final products = ProductRepository.getProductsByCategory(categoryName);
        final isLoading = snapshot.connectionState != ConnectionState.done;

        return Scaffold(
          backgroundColor: lightGrey,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text(
              categoryName,
              style: const TextStyle(
                color: primaryBlue,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: primaryBlue),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : products.isEmpty
                  ? const Center(
                      child: Text(
                        'Aucun produit disponible',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        final product = products[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.08),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: cardGrey,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    product.image,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        const Center(
                                      child: Text('📦', style: TextStyle(fontSize: 28)),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '\$${product.price.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: primaryBlue.withOpacity(0.8),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.grey.shade400,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
        );
      },
    );
  }
}
