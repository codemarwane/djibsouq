import 'package:flutter/material.dart';
import 'package:dj/models/product_models.dart';
import '../detail_product.dart';

const Color primaryBlue = Color(0xFF1E3A8A);
const Color lightGrey = Color(0xFFF3F4F6);
const Color cardGrey = Color(0xFFE5E7EB);

class ServicesMaintenancePage extends StatelessWidget {
  const ServicesMaintenancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Consultation à domicile',
          style: TextStyle(
            color: primaryBlue,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: primaryBlue),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _BuildHeader(),
          const SizedBox(height: 16),
          _buildConsultationCard(context),
          const SizedBox(height: 24),
          _buildTrustSection(),
          const SizedBox(height: 24),
          _buildHowItWorks(),
        ],
      ),
    );
  }

  // 🏠 Bandeau en haut
  Widget _BuildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: primaryBlue,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Consultation informatique à domicile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Un expert se déplace chez vous pour diagnostiquer vos problèmes',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 4),
          Text(
            '🔒 Sécurité et confidentialité garanties',
            style: TextStyle(color: Colors.white),
          ),
          Text(
            '⏱ Intervention rapide et flexible',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  // 🧱 Carte consultation
  Widget _buildConsultationCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.home_repair_service, size: 40, color: primaryBlue),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Consultation à domicile',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryBlue,
                  ),
                ),
              ),
              Text(
                '5,77 \$',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Diagnostic complet, conseils personnalisés et devis transparent si réparation nécessaire.',
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                final detailProduct = Product(
                  id: 9001,
                  title: 'Consultation à domicile',
                  price: 5.77,
                  image: 'https://via.placeholder.com/150',
                  category: 'Services Maintenance',
                  description:
                      'Diagnostic complet, conseils personnalisés et devis transparent',
                );
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailProductPage(product: detailProduct),
                  ),
                );
              },
              child: const Text('RÉSERVER MAINTENANT'),
            ),
          ),
        ],
      ),
    );
  }

  //  Section confiance
  Widget _buildTrustSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Pourquoi nous faire confiance ?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryBlue,
          ),
        ),
        SizedBox(height: 8),
        Text('✔ Techniciens qualifiés et expérimentés'),
        Text('✔ Intervention à domicile avec respect du matériel'),
        Text('✔ Confidentialité et sécurité de vos données'),
        Text('✔ Assistance rapide et fiable'),
      ],
    );
  }

  // 🔁 Comment ça marche
  Widget _buildHowItWorks() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Comment ça marche ?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryBlue,
          ),
        ),
        SizedBox(height: 8),
        Text('1️⃣ Réservez votre consultation à domicile'),
        Text('2️⃣ Le technicien se déplace chez vous'),
        Text('3️⃣ Diagnostic complet et explications claires'),
        Text('4️⃣ Vous décidez librement des actions à suivre'),
      ],
    );
  }
}

