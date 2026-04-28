import 'package:flutter/material.dart';
import 'package:dj/data/api/wishlist_api.dart';
import 'package:dj/models/product_models.dart';

const Color primaryBlue = Color(0xFF1E3A8A);
const Color lightGrey = Color(0xFFF3F4F6);

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final _wishlistApi = WishlistApi();
  late Future<List<Product>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _favoritesFuture = _wishlistApi.getWishlist();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: _favoritesFuture,
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: lightGrey,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'Mes Favoris',
              style: TextStyle(
                color: primaryBlue,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            centerTitle: false,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: primaryBlue),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: snapshot.connectionState != ConnectionState.done
              ? const Center(child: CircularProgressIndicator())
              : snapshot.hasError
                  ? const Center(child: Text('Erreur de chargement'))
                  : _buildContent(snapshot.data ?? const []),
        );
      },
    );
  }

  Widget _buildContent(List<Product> products) {
    if (products.isEmpty) {
      return const Center(child: Text('Aucun favori'));
    }
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ListTile(
          leading: CircleAvatar(child: Text(product.title.isEmpty ? '⭐' : product.title[0])),
          title: Text(product.title),
          subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
        );
      },
    );
  }
}
