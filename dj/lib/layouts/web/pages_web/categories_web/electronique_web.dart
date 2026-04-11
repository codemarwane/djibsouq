import 'package:dj/layouts/web/pages_web/detail_product_popup.dart';
import 'package:flutter/material.dart';
import 'package:dj/data/product_repository.dart';
import 'package:dj/models/product_models.dart';
import '../../home_web.dart';
import '../categories_web.dart';
import '../cart_web.dart';
import '../favorites_web.dart';
import '../profile_web.dart';

const Color primaryBlue = Color(0xFF1E3A8A);
const Color lightGrey = Color(0xFFF3F4F6);
const Color cardGrey = Color(0xFFFFFFFF);
const Color textDark = Color(0xFF111827);

// helper to display detail popup
void openProductPopup(BuildContext context, Product product) {
  DetailProductPopup.show(context, product: product);
}

class ElectroniqueCategoryWeb extends StatefulWidget {
  const ElectroniqueCategoryWeb({super.key});

  @override
  State<ElectroniqueCategoryWeb> createState() =>
      _ElectroniqueCategoryWebState();
}

class _ElectroniqueCategoryWebState extends State<ElectroniqueCategoryWeb> {
  late List<Product> products;
  String selectedSort = "Pertinence";

  @override
  void initState() {
    super.initState();
    products = ProductRepository.getProductsByCategory("Électronique");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _BuildHeader(context),
            _buildProductsSection(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _BuildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomepageWeb()),
              );
            },
            child: Row(
              children: const [
                Icon(Icons.play_circle_fill, color: primaryBlue, size: 32),
                SizedBox(width: 8),
                Text("DJIBSOUQ",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: primaryBlue)),
              ],
            ),
          ),
          Row(
            children: [
              _NavItem("Home", onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomepageWeb()),
                );
              }),
              _NavItem("Categories", onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CategoriesWeb()),
                );
              }),
              _NavItem("Deals", onTap: () {}),
              _NavItem("About", onTap: () {}),
              _NavItem("Contact", onTap: () {}),
              const SizedBox(width: 30),
              GestureDetector(
                onTap: () {},
                child: const Icon(Icons.search),
              ),
              const SizedBox(width: 15),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfileWeb(),
                    ),
                  );
                },
                child: const Icon(Icons.person_outline),
              ),
              const SizedBox(width: 15),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavoritesWeb(),
                    ),
                  );
                },
                child: const Icon(Icons.favorite_border),
              ),
              const SizedBox(width: 15),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CartWeb(),
                    ),
                  );
                },
                child: const Icon(Icons.shopping_cart_outlined),
              ),
            ],
          )
        ],
      ),
    );
  }

  // ================= PRODUCTS SECTION =================
  Widget _buildProductsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitleAndSort(),
          const SizedBox(height: 30),
          _buildProductsGrid(),
        ],
      ),
    );
  }

  Widget _buildTitleAndSort() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "ÉLECTRONIQUE",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: selectedSort,
            underline: const SizedBox(),
            items: ["Pertinence", "Prix: Bas à Haut", "Prix: Haut à Bas"]
                .map((sort) => DropdownMenuItem(
                      value: sort,
                      child: Text(sort),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedSort = value!;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductsGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 0.8,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return _buildProductCard(product);
      },
    );
  }

  Widget _buildProductCard(Product product) {
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            openProductPopup(context, product);
          },
          borderRadius: BorderRadius.circular(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: lightGrey,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          product.image,
                          style: const TextStyle(fontSize: 80),
                        ),
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
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: textDark,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "\$${product.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primaryBlue,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.star,
                            size: 14, color: Colors.amber.shade600),
                        const SizedBox(width: 4),
                        Text(
                          "${product.rating} (${product.reviews})",
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryBlue,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        onPressed: () {
                      openProductPopup(context, product);
                    },
                        child: const Text(
                          "Ajouter",
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
        ),
      ),
    );
  }

  // ================= FOOTER =================
  Widget _buildFooter() {
    return Container(
      margin: const EdgeInsets.only(top: 40),
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

// NAV ITEM
class _NavItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _NavItem(this.title, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.w500, color: textDark)),
      ),
    );
  }
}

