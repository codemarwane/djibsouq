import 'package:flutter/material.dart';
import 'package:dj/widgets/web_header.dart';
import 'package:dj/routes.dart';

const Color primaryBlue = Color(0xFF1E3A8A);
const Color lightGrey = Color(0xFFF3F4F6);
const Color cardGrey = Color(0xFFFFFFFF);
const Color textDark = Color(0xFF111827);
const Color accentGreen = Color(0xFF16A34A);

// Breakpoints
const double mobileBreakpoint = 700;
const double tabletBreakpoint = 1024;

// ─────────────────────────────────────────────
//  ABOUT US PAGE
// ─────────────────────────────────────────────
class AboutUsWeb extends StatefulWidget {
  const AboutUsWeb({super.key});

  @override
  State<AboutUsWeb> createState() => _AboutUsWebState();
}

class _AboutUsWebState extends State<AboutUsWeb> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            BuildHeader(currentPage: 'À propos'),
            _buildAboutContent(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  ABOUT CONTENT
  // ─────────────────────────────────────────────
  Widget _buildAboutContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final bool isMobile = width < mobileBreakpoint;
        final bool isTablet = width < tabletBreakpoint;

        final double horizontalPadding = isMobile ? 20 : (isTablet ? 40 : 60);
        final double verticalPadding = isMobile ? 24 : 40;

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding,
            vertical: verticalPadding,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ───── HERO SECTION ─────
              _buildHeroSection(isMobile: isMobile),
              const SizedBox(height: 60),

              // ───── MISSION SECTION ─────
              _buildMissionSection(isMobile: isMobile),
              const SizedBox(height: 60),

              // ───── VALUES SECTION ─────
              _buildValuesSection(isMobile: isMobile),
              const SizedBox(height: 60),

              // ───── STATS SECTION ─────
              _buildStatsSection(isMobile: isMobile),
              const SizedBox(height: 60),

              // ───── TEAM SECTION ─────
              _buildTeamSection(isMobile: isMobile),
              const SizedBox(height: 60),

              // ───── CTA SECTION ─────
              _buildCTASection(isMobile: isMobile),
            ],
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────
  //  HERO SECTION
  // ─────────────────────────────────────────────
  Widget _buildHeroSection({required bool isMobile}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'À propos de DJIBSOUQ',
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Votre plateforme de marché local de confiance depuis 2020',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey.shade600,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'DJIBSOUQ est une plateforme e-commerce révolutionnaire basée à Djibouti, '
          'dédiée à connecter les vendeurs locaux avec des clients à travers le pays. '
          'Nous croyons au pouvoir du commerce numérique pour transformer les petites '
          'entreprises et créer des opportunités économiques durables.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade700,
            height: 1.8,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  //  MISSION SECTION
  // ─────────────────────────────────────────────
  Widget _buildMissionSection({required bool isMobile}) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: cardGrey,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: isMobile
          ? Column(
              children: [
                _buildMissionItem(
                  icon: Icons.flag_outlined,
                  title: 'Notre Mission',
                  description:
                      'Transformer le commerce local en rendant les produits de qualité accessibles à tous.',
                ),
                const SizedBox(height: 30),
                _buildMissionItem(
                  icon: Icons.visibility_outlined,
                  title: 'Notre Vision',
                  description:
                      'Devenir la plateforme de marché la plus fiable et conviviale en Afrique de l\'Est.',
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  child: _buildMissionItem(
                    icon: Icons.flag_outlined,
                    title: 'Notre Mission',
                    description:
                        'Transformer le commerce local en rendant les produits de qualité accessibles à tous.',
                  ),
                ),
                const SizedBox(width: 40),
                Expanded(
                  child: _buildMissionItem(
                    icon: Icons.visibility_outlined,
                    title: 'Notre Vision',
                    description:
                        'Devenir la plateforme de marché la plus fiable et conviviale en Afrique de l\'Est.',
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildMissionItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: primaryBlue, size: 32),
        ),
        const SizedBox(height: 16),
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────
  //  VALUES SECTION
  // ─────────────────────────────────────────────
  Widget _buildValuesSection({required bool isMobile}) {
    final values = [
      {
        'icon': Icons.verified_outlined,
        'title': 'Intégrité',
        'description': 'Transparence et honnêteté dans toutes nos relations',
      },
      {
        'icon': Icons.security_outlined,
        'title': 'Sécurité',
        'description': 'Protection maximale des données de nos utilisateurs',
      },
      {
        'icon': Icons.people_outline,
        'title': 'Communauté',
        'description': 'Construire ensemble une économie locale forte',
      },
      {
        'icon': Icons.lightbulb_outlined,
        'title': 'Innovation',
        'description': 'Amélioration continue de nos services',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nos Valeurs',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
        const SizedBox(height: 30),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isMobile ? 1 : 2,
            mainAxisSpacing: 24,
            crossAxisSpacing: 24,
            childAspectRatio: 1.2,
          ),
          itemCount: values.length,
          itemBuilder: (context, index) {
            final value = values[index];
            return _buildValueCard(
              icon: value['icon'] as IconData,
              title: value['title'] as String,
              description: value['description'] as String,
            );
          },
        ),
      ],
    );
  }

  Widget _buildValueCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardGrey,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          )
        ],
        border: Border.all(
          color: Colors.grey.shade100,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: primaryBlue, size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  STATS SECTION
  // ─────────────────────────────────────────────
  Widget _buildStatsSection({required bool isMobile}) {
    final stats = [
      {'number': '15K+', 'label': 'Clients actifs'},
      {'number': '2.5K+', 'label': 'Vendeurs'},
      {'number': '50K+', 'label': 'Produits listés'},
      {'number': '98%', 'label': 'Satisfaction client'},
    ];

    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: primaryBlue,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 2 : 4,
              mainAxisSpacing: 30,
              crossAxisSpacing: 24,
            ),
            itemCount: stats.length,
            itemBuilder: (context, index) {
              final stat = stats[index];
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    stat['number']!,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    stat['label']!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  TEAM SECTION
  // ─────────────────────────────────────────────
  Widget _buildTeamSection({required bool isMobile}) {
    final team = [
      {
        'name': 'Ali Hassan',
        'role': 'Fondateur & PDG',
        'bio': 'Entrepreneur visionnaire avec 10 ans d\'expérience en e-commerce',
      },
      {
        'name': 'Fatima Ibrahim',
        'role': 'Directrice Opérationnelle',
        'bio': 'Expert en logistique et gestion d\'équipes performantes',
      },
      {
        'name': 'Mohamed Ahmed',
        'role': 'Chef Technologique',
        'bio': 'Développeur senior spécialisé en plateformes e-commerce',
      },
      {
        'name': 'Amina Said',
        'role': 'Responsable Client',
        'bio': 'Passionnée par l\'excellence du service client',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Notre Équipe',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: textDark,
          ),
        ),
        const SizedBox(height: 30),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isMobile ? 1 : (2),
            mainAxisSpacing: 24,
            crossAxisSpacing: 24,
            childAspectRatio: 1.1,
          ),
          itemCount: team.length,
          itemBuilder: (context, index) {
            final member = team[index];
            return _buildTeamCard(
              name: member['name']!,
              role: member['role']!,
              bio: member['bio']!,
            );
          },
        ),
      ],
    );
  }

  Widget _buildTeamCard({
    required String name,
    required String role,
    required String bio,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: cardGrey,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          )
        ],
        border: Border.all(
          color: Colors.grey.shade100,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Avatar placeholder
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.person_outline,
              color: primaryBlue,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                role,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: primaryBlue,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                bio,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  CTA SECTION
  // ─────────────────────────────────────────────
  Widget _buildCTASection({required bool isMobile}) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: lightGrey,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: primaryBlue.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rejoignez notre communauté',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textDark,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Que vous soyez client ou vendeur, nous vous accueillons avec enthousiasme. '
            'Découvrez comment DJIBSOUQ peut transformer votre expérience d\'achat ou de vente.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade600,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.products);
                },
                child: const Text(
                  'Découvrir les produits',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: primaryBlue, width: 2),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.contact_us);
                },
                child: const Text(
                  'Nous contacter',
                  style: TextStyle(
                    color: primaryBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────
  //  FOOTER
  // ─────────────────────────────────────────────
  Widget _buildFooter() {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.all(40),
      color: const Color(0xFF0F172A),
      child: Center(
        child: Text(
          '© 2026 DJIBSOUQ. All rights reserved.',
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14),
        ),
      ),
    );
  }
}

