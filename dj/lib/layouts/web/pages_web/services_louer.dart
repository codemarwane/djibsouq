import 'package:flutter/material.dart';
import 'package:dj/widgets/web_header.dart';

const Color primaryBlue = Color(0xFF1E3A8A);
const Color blue600 = Color(0xFF2563EB);
const Color accentTeal = Color(0xFF14B8A6);
const Color lightGrey = Color(0xFFF8FAFC);
const Color textDark = Color(0xFF111827);
const Color _textMid = Color(0xFF4B5563);

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              BuildHeader(currentPage: 'Services'),

              // ==================== HERO SECTION ====================
              _ServicesHero(),

              const SizedBox(height: 80),

              // ==================== SECTION 1 : MAINTENANCE ====================
              _SectionWrapper(
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SectionHeader(num: '01', title: 'Maintenance Informatique'),
                    const SizedBox(height: 40),
                    _MaintenanceSection(),
                  ],
                ),
              ),

              const SizedBox(height: 60),

              // ==================== SECTION 2 : LOCATION SAAS ====================
              _SectionWrapper(
                color: lightGrey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SectionHeader(num: '02', title: 'Location de Plateformes SaaS'),
                    const SizedBox(height: 20),
                    const _SaasIntro(),
                    const SizedBox(height: 40),
                    const _SaasPlansGrid(),
                  ],
                ),
              ),

              const SizedBox(height: 100),
              _ServicesFooterBand(),
            ],
          ),
        ),
      ),
    );
  }
}

// ====================== HERO ======================
class _ServicesHero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: double.infinity,
      height: size.width > 900 ? 520 : 420,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F172A), primaryBlue],
        ),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Services Professionnels à Louer',
                  style: TextStyle(
                    fontSize: size.width > 900 ? 52 : 42,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.1,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  'Maintenance informatique & Accès aux meilleurs outils SaaS\nsans investissement lourd',
                  style: TextStyle(
                    fontSize: size.width > 900 ? 22 : 18,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ====================== SECTION HEADER ======================
class _SectionHeader extends StatelessWidget {
  final String num;
  final String title;

  const _SectionHeader({required this.num, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: blue600.withOpacity(0.1),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Text(
            num,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: blue600),
          ),
        ),
        const SizedBox(width: 16),
        Text(
          title,
          style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textDark),
        ),
      ],
    );
  }
}

// ====================== MAINTENANCE SECTION ======================
class _MaintenanceSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 850;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1100),
      child: isWide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Expanded(flex: 5, child: _MaintenanceLeft()),
                SizedBox(width: 60),
                Expanded(flex: 4, child: _MaintenanceRight()),
              ],
            )
          : Column(
              children: const [
                _MaintenanceLeft(),
                SizedBox(height: 40),
                _MaintenanceRight(),
              ],
            ),
    );
  }
}

class _MaintenanceLeft extends StatelessWidget {
  const _MaintenanceLeft();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Maintenance complète de votre parc informatique",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 20),
        const Text(
          "Nous nous occupons de vos ordinateurs, serveurs, réseaux et systèmes en partenariat avec des experts locaux.\n\n"
          "• Diagnostic et réparation rapide\n"
          "• Optimisation des performances\n"
          "• Sauvegarde et cybersécurité\n"
          "• Support à distance ou intervention sur site à Djibouti",
          style: TextStyle(fontSize: 17, height: 1.7, color: _textMid),
        ),
        const SizedBox(height: 30),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.arrow_forward),
          label: const Text("Demander un devis"),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryBlue,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}

class _MaintenanceRight extends StatelessWidget {
  const _MaintenanceRight();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: const [
        _SlaBox(label: "Réponse critique", value: "< 4h", color: Colors.redAccent),
        _SlaBox(label: "Support", value: "6j/7", color: accentTeal),
        _SlaBox(label: "Uptime garanti", value: "99.5%", color: blue600),
        _SlaBox(label: "Intervention", value: "Sur site", color: Colors.orange),
      ],
    );
  }
}

class _SlaBox extends StatelessWidget {
  final String label, value;
  final Color color;

  const _SlaBox({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}

// ====================== SAAS SECTION ======================
class _SaasIntro extends StatelessWidget {
  const _SaasIntro();

  @override
  Widget build(BuildContext context) {
    return const Text(
      "Accédez aux meilleurs outils professionnels sans acheter de licence complète.\n"
      "Payez uniquement ce que vous utilisez chaque mois.",
      style: TextStyle(fontSize: 18, height: 1.6, color: _textMid),
    );
  }
}

class _SaasPlansGrid extends StatelessWidget {
  const _SaasPlansGrid();

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;

    final plans = [
      {"name": "Canva Pro", "price": "8 000 FDJ", "desc": "Design graphique"},
      {"name": "Adobe Express", "price": "25 000 FDJ", "desc": "Outils créatifs"},
      {"name": "Notion + Zoho", "price": "15 000 FDJ", "desc": "Productivité"},
      {"name": "Visme", "price": "12 000 FDJ", "desc": "Infographies"},
    ];

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1100),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isWide ? 2 : 1,
          childAspectRatio: isWide ? 2.1 : 2.8,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
        ),
        itemCount: plans.length,
        itemBuilder: (context, index) {
          final plan = plans[index];
          return _SaasCard(
            name: plan["name"]!,
            price: plan["price"]!,
            desc: plan["desc"]!,
          );
        },
      ),
    );
  }
}

class _SaasCard extends StatelessWidget {
  final String name, price, desc;

  const _SaasCard({required this.name, required this.price, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 6))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(desc, style: const TextStyle(fontSize: 16, color: _textMid)),
          const Spacer(),
          Text(
            price + " / mois",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryBlue),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: const BorderSide(color: primaryBlue),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Louer ce service"),
            ),
          ),
        ],
      ),
    );
  }
}

// ====================== FOOTER ======================
class _ServicesFooterBand extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 40),
      color: primaryBlue,
      child: const Center(
        child: Text(
          "Besoin d’un service sur mesure ? Contactez-nous →",
          style: TextStyle(color: Colors.white, fontSize: 18),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

// ====================== WRAPPER ======================
class _SectionWrapper extends StatelessWidget {
  final Widget child;
  final Color color;

  const _SectionWrapper({required this.child, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: color,
      padding: const EdgeInsets.symmetric(vertical: 70),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: child,
          ),
        ),
      ),
    );
  }
}
