import 'package:dj/widgets/web_header.dart';
import 'package:flutter/material.dart';

const Color primaryBlue = Color(0xFF1E3A8A);
const Color lightGrey = Color(0xFFF3F4F6);
const Color cardGrey = Color(0xFFFFFFFF);
const Color textDark = Color(0xFF111827);

class CartWeb extends StatefulWidget {
  const CartWeb({super.key});

  @override
  State<CartWeb> createState() => _CartWebState();
}

class _CartWebState extends State<CartWeb> {
  // Sample cart items - in real app, this would come from state management
  final List<Map<String, dynamic>> cartItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            BuildHeader(currentPage: 'Cart'),
            _buildCartContent(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  // ================= CART CONTENT =================
  Widget _buildCartContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 60),
      child: cartItems.isEmpty
          ? _buildEmptyCart()
          : _buildFullCart(),
    );
  }

  Widget _buildEmptyCart() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined,
              size: 100, color: primaryBlue.withOpacity(0.3)),
          const SizedBox(height: 20),
          const Text(
            "Votre panier est vide",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Commencez vos achats maintenant",
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
            onPressed: () {},
            child: const Text(
              "Continuer vos achats",
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

  Widget _buildFullCart() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Cart items
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Mon Panier",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: cardGrey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "${cartItems.length} articles",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 40),
        // Order summary
        SizedBox(
          width: 350,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardGrey,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Résumé de la commande",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: textDark,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Sous-total:"),
                    Text("\$0.00"),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Livraison:"),
                    Text("\$0.00"),
                  ],
                ),
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Total:",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "\$0.00",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: primaryBlue,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Procéder au paiement",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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

