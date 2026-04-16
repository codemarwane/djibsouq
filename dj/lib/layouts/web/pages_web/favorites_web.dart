import 'package:dj/layouts/web/pages_web/products_web.dart';
import 'package:dj/widgets/web_header.dart';
import 'package:flutter/material.dart';

const Color primaryBlue = Color(0xFF1E3A8A);
const Color lightGrey = Color(0xFFF3F4F6);
const Color cardGrey = Color(0xFFFFFFFF);
const Color textDark = Color(0xFF111827);
const Color mutedText = Color(0xFF6B7280);

class FavoritesWeb extends StatefulWidget {
  const FavoritesWeb({super.key});

  @override
  State<FavoritesWeb> createState() => _FavoritesWebState();
}

class _FavoritesWebState extends State<FavoritesWeb> {
  // Données exemples - à remplacer par ton state management
  List<Map<String, dynamic>> favorites = [
    {
      'id': 1,
      'name': 'Chaussures Sport Nike Air Max',
      'price': 24500,
      'image': 'assets/products/shoes.jpg',
      'category': 'Mode • Sport',
    },
    {
      'id': 2,
      'name': 'Smartphone Samsung Galaxy A55 5G',
      'price': 89000,
      'image': 'assets/products/phone.jpg',
      'category': 'Électronique',
    },
    {
      'id': 3,
      'name': 'Sac à dos imperméable 40L',
      'price': 18500,
      'image': 'assets/products/bag.jpg',
      'category': 'Accessoires',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            BuildHeader(currentPage: "Favoris"),
            _buildFavoritesContent(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 60),
      child: favorites.isEmpty
          ? _buildEmptyFavorites()
          : _buildFavoritesList(),
    );
  }

  // ==================== ÉTAT VIDE ====================
  Widget _buildEmptyFavorites() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 120),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: primaryBlue.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.favorite_border_rounded,
                size: 120,
                color: primaryBlue.withOpacity(0.35),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              "Votre liste de favoris est vide",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textDark),
            ),
            const SizedBox(height: 12),
            Text(
              "Ajoutez des produits que vous aimez pour les retrouver facilement ici.",
              style: TextStyle(fontSize: 17, color: mutedText, height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ProductsWeb()),
                );
              },
              icon: const Icon(Icons.shopping_bag_outlined),
              label: const Text(
                "Découvrir les produits",
                style: TextStyle(fontSize: 16.5, fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== LISTE DES FAVORIS (Nouvelle structure) ====================
  Widget _buildFavoritesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Mes Favoris",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textDark),
            ),
            Text(
              "${favorites.length} produit${favorites.length > 1 ? 's' : ''}",
              style: TextStyle(fontSize: 16, color: mutedText),
            ),
          ],
        ),
        const SizedBox(height: 40),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: favorites.length,
          separatorBuilder: (context, index) => const SizedBox(height: 20),
          itemBuilder: (context, index) {
            final product = favorites[index];
            return _buildFavoriteCard(product, index);
          },
        ),
      ],
    );
  }

  // ==================== NOUVELLE CARTE HORIZONTALE ====================
  Widget _buildFavoriteCard(Map<String, dynamic> product, int index) {
    return Container(
      decoration: BoxDecoration(
        color: cardGrey,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Section
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)),
              child: Container(
                width: 280,
                color: lightGrey,
                child: product['image'] != null
                    ? Image.asset(product['image'], fit: BoxFit.cover)
                    : const Icon(Icons.image, size: 80, color: Colors.grey),
              ),
            ),

            // Content Section
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['category'] ?? '',
                              style: TextStyle(fontSize: 13, color: mutedText, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              product['name'],
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w600,
                                height: 1.3,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                        // Bouton supprimer favori
                        IconButton(
                          onPressed: () {
                            setState(() {
                              favorites.removeAt(index);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Produit retiré des favoris")),
                            );
                          },
                          icon: const Icon(Icons.favorite_rounded, color: Colors.red, size: 28),
                        ),
                      ],
                    ),

                    // Price
                    Text(
                      "${product['price'].toStringAsFixed(0)} DJF",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: primaryBlue,
                      ),
                    ),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: primaryBlue),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () {
                              // Voir détails
                            },
                            child: const Text("Voir détails", style: TextStyle(color: primaryBlue)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryBlue,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Produit ajouté au panier ✓")),
                              );
                            },
                            child: const Text(
                              "Ajouter au panier",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==================== FOOTER ====================
  Widget _buildFooter() {
    return Container(
      margin: const EdgeInsets.only(top: 100),
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 60),
      color: const Color(0xFF0F172A),
      child: const Center(
        child: Text(
          '© 2026 DJIBSOUQ — Djibouti, République de Djibouti — Tous droits réservés',
          style: TextStyle(color: Colors.white54, fontSize: 14),
        ),
      ),
    );
  }
}