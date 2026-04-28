import 'package:dj/models/category_models.dart';
import 'package:dj/data/product_repository.dart';
import 'package:dj/widgets/products_horizontal_list.dart';
import 'package:flutter/material.dart';
import 'pages/categories.dart';
import 'pages/categories_product_page.dart';
import 'pages/drawer_mobile.dart';
import 'pages/detail_product.dart';

const Color primaryBlue = Color(0xFF1E3A8A);
const Color lightGrey = Color(0xFFF3F4F6);

class HomepageMobile extends StatefulWidget {
  const HomepageMobile({super.key});

  @override
  State<HomepageMobile> createState() => _HomepageMobileState();
}

class _HomepageMobileState extends State<HomepageMobile> {
  late ValueNotifier<int> _currentBanner;
  late PageController _pageController;
  late Future<void> _initFuture;

  @override
  void initState() {
    super.initState();
    _currentBanner = ValueNotifier(0);
    _pageController = PageController(viewportFraction: 0.9);
    _initFuture = ProductRepository.initialize();
  }

  @override
  void dispose() {
    _currentBanner.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initFuture,
      builder: (context, snapshot) {
        final categories = ProductRepository.categories;
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return Scaffold(
          backgroundColor: lightGrey,
          drawer: const AppDrawer(),
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                _buildAppBar(),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _searchBar(),
                        const SizedBox(height: 20),
                        _bannerSection(),
                        const SizedBox(height: 24),
                        _sectionTitle("Categories"),
                        const SizedBox(height: 12),
                        _categoriesPreview(categories),
                        const SizedBox(height: 32),
                        ...categories.map((category) {
                          final products =
                              ProductRepository.getProductsByCategory(category.name);
                          if (products.isEmpty) return const SizedBox();
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ProductsHorizontalList(
                                title: category.name,
                                products: products,
                                detailPageBuilder: (product) =>
                                    DetailProductPage(product: product),
                              ),
                              const SizedBox(height: 32),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// ---------------- APP BAR ----------------

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      pinned: true,
      title: const Text(
        "DJIBSOUQ",
        style: TextStyle(
          color: primaryBlue,
          fontWeight: FontWeight.bold,
          fontSize: 22,
        ),
      ),
    );
  }

  /// ---------------- SEARCH ----------------

  Widget _searchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: "Search products...",
          border: InputBorder.none,
          icon: Icon(Icons.search),
        ),
      ),
    );
  }

  /// ---------------- BANNER ----------------

  Widget _bannerSection() {
    final banners = [
      {
        'title': 'Big Sale Today',
        'subtitle': 'Up to 50% discount on selected items',
      },
      {
        'title': 'New Arrivals',
        'subtitle': 'Discover the latest products',
      },
      {
        'title': 'Free Delivery',
        'subtitle': 'On orders over 50\$',
      },
    ];

    return Column(
      children: [
        ValueListenableBuilder<int>(
          valueListenable: _currentBanner,
          builder: (_, value, __) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(banners.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 6,
                  width: value == index ? 18 : 6,
                  decoration: BoxDecoration(
                    color: value == index
                        ? primaryBlue
                        : primaryBlue.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                  ),
                );
              }),
            );
          },
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 160,
          child: PageView.builder(
            controller: _pageController,
            itemCount: banners.length,
            onPageChanged: (index) {
              _currentBanner.value = index;
            },
            itemBuilder: (_, index) {
              final banner = banners[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [
                        primaryBlue.withOpacity(0.8),
                        primaryBlue.withOpacity(0.5),
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          banner['title']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          banner['subtitle']!,
                          style: const TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// ---------------- TITRE ----------------

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  /// ---------------- CATEGORIES ----------------

  Widget _categoriesPreview(List<Category> categories) {
    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemBuilder: (_, index) {
            final category = categories[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategoryProductsPage(
                      categoryName: category.name,
                    ),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    category.name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: primaryBlue,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CategoriesPage()),
            );
          },
          child: const Text(
            'Voir toutes les catégories →',
            style: TextStyle(
              color: primaryBlue,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
