
import 'package:flutter/material.dart';
import 'package:dj/data/product_repository.dart';
import 'categories/electronique.dart';
import 'categories/vetements.dart';
import 'categories/maison.dart';
import 'categories/sports.dart';
import 'categories/livres.dart';
import 'categories/beaute.dart';
import 'categories/services_loue.dart';
import 'categories/services_maintenance.dart';

const Color primaryBlue = Color(0xFF1E3A8A);
const Color lightGrey = Color(0xFFF3F4F6);
const Color cardGrey = Color(0xFFE5E7EB);

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  // Mapping des icônes
  static IconData _getIcon(String iconName) {
    switch (iconName) {
      case 'devices':
        return Icons.devices;
      case 'shopping_bag':
        return Icons.shopping_bag;
      case 'home':
        return Icons.home;
      case 'sports_soccer':
        return Icons.sports_soccer;
      case 'library_books':
        return Icons.library_books;
      case 'spa':
        return Icons.spa;
      case 'key':
        return Icons.key;
      case 'build':
        return Icons.build;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: ProductRepository.initialize(),
      builder: (context, snapshot) {
        final categories = ProductRepository.categories;
        return Scaffold(
          backgroundColor: lightGrey,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text(
              'Catégories',
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
              : Padding(
                  padding: const EdgeInsets.all(16),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return _buildCategoryCard(
                        name: category.name,
                        icon: _getIcon(category.icon),
                        color: category.color,
                        imageUrl: category.image,
                        onTap: () => _openCategory(context, category.name),
                      );
                    },
                  ),
                ),
        );
      },
    );
  }

  void _openCategory(BuildContext context, String name) {
    Widget page;
    switch (name) {
      case 'Électronique':
        page = const ElectronicsPage();
        break;
      case 'Vêtements':
        page = const VetementsPage();
        break;
      case 'Maison':
        page = const MaisonPage();
        break;
      case 'Sports':
        page = const SportsPage();
        break;
      case 'Livres':
        page = const LivresPage();
        break;
      case 'Beauté':
        page = const BeautePage();
        break;
      case 'Services loué':
        page = const ServicesLouePage();
        break;
      case 'Services maintenance':
        page = const ServicesMaintenancePage();
        break;
      default:
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(name)));
        return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }

  Widget _buildCategoryCard({
    required String name,
    required IconData icon,
    required Color color,
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image en arrière-plan
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: color.withOpacity(0.1),
                    child: Icon(icon, size: 48, color: color),
                  );
                },
              ),
            ),
            // Overlay gradient
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                ),
              ),
            ),
            // Contenu
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 40, color: Colors.white),
                ),
                const SizedBox(height: 12),
                Text(
                  name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
