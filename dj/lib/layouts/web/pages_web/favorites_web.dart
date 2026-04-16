/// Favoris web : [WishlistApi] et navigation vers le catalogue.
library;

import 'package:dj/layouts/web/pages_web/products_web.dart';
import 'package:dj/widgets/web_header.dart';
import 'package:flutter/material.dart';
import 'package:dj/data/api/wishlist_api.dart';
import 'package:dj/models/product_models.dart';


const Color primaryBlue = Color(0xFF1E3A8A);
const Color lightGrey = Color(0xFFF3F4F6);
const Color cardGrey = Color(0xFFFFFFFF);
const Color textDark = Color(0xFF111827);

class FavoritesWeb extends StatefulWidget {
  const FavoritesWeb({super.key});

  @override
  State<FavoritesWeb> createState() => _FavoritesWebState();
}

class _FavoritesWebState extends State<FavoritesWeb> {
  final _wishlistApi = WishlistApi();
  late Future<List<Product>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _favoritesFuture = _wishlistApi.getWishlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildHeader(currentPage: "Favorites"),
            FutureBuilder<List<Product>>(
              future: _favoritesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 60),
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 60),
                    child: Text('Erreur de chargement favoris'),
                  );
                }
                return _buildFavoritesContent(snapshot.data ?? const []);
              },
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  // ================= FAVORITES CONTENT =================
  Widget _buildFavoritesContent(List<Product> favorites) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 60),
      child: favorites.isEmpty
          ? _buildEmptyFavorites()
          : _buildFavoritesList(favorites),
    );
  }

  Widget _buildEmptyFavorites() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border,
              size: 100, color: primaryBlue.withOpacity(0.3)),
          const SizedBox(height: 20),
          const Text(
            "Aucun favori pour le moment",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Découvrez les produits et ajoutez vos favoris",
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryBlue,
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
                vertical: 15,
              ),
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ProductsWeb()),
              );
            },
            child: const Text(
              "Explorez les produits",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesList(List<Product> favorites) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Mes Favoris",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: favorites.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            return _buildFavoriteCard(favorites[index]);
          },
        ),
      ],
    );
  }

  Widget _buildFavoriteCard(Product product) {
    return Container(
      decoration: BoxDecoration(
        color: cardGrey,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  color: lightGrey,
                  child: const Icon(Icons.image, size: 60),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    icon: const Icon(Icons.favorite, color: primaryBlue),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "\$${product.price.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: primaryBlue,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Ajouter au panier",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= FOOTER =================
  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(40),
      color: primaryBlue,
      child: const Center(
        child: Text(
          "© 2026 MIZUX. All rights reserved.",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
