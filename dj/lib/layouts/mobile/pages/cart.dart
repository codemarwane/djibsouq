import 'package:flutter/material.dart';
import 'package:dj/data/api/cart_api.dart';
import 'package:dj/models/cart_models.dart';

const Color primaryBlue = Color(0xFF1E3A8A);
const Color lightGrey = Color(0xFFF3F4F6);

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final _cartApi = CartApi();
  late Future<CartModel> _cartFuture;

  @override
  void initState() {
    super.initState();
    _cartFuture = _cartApi.getCart();
  }

  Future<void> _refresh() async {
    setState(() => _cartFuture = _cartApi.getCart());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CartModel>(
      future: _cartFuture,
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: lightGrey,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'Mon Panier',
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
                  ? Center(
                      child: TextButton(
                        onPressed: _refresh,
                        child: const Text('Erreur de chargement. Réessayer'),
                      ),
                    )
                  : _buildCart(snapshot.data!),
        );
      },
    );
  }

  Widget _buildCart(CartModel cart) {
    if (cart.items.isEmpty) {
      return const Center(
        child: Text('Votre panier est vide', style: TextStyle(fontSize: 18)),
      );
    }
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.builder(
        itemCount: cart.items.length + 1,
        itemBuilder: (context, index) {
          if (index == cart.items.length) {
            return ListTile(
              title: const Text('Sous-total'),
              trailing: Text('\$${cart.subtotal.toStringAsFixed(2)}'),
            );
          }
          final item = cart.items[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(item.product.title.isEmpty ? '🛒' : item.product.title[0]),
            ),
            title: Text(item.product.title),
            subtitle: Text('Quantité: ${item.quantity}'),
            trailing: Text('\$${item.unitPriceSnapshot.toStringAsFixed(2)}'),
          );
        },
      ),
    );
  }
}
