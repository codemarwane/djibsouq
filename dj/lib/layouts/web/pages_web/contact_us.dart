import 'package:dj/widgets/web_header.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const DjibsouqApp());
}

class DjibsouqApp extends StatelessWidget {
  const DjibsouqApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Djibsouq',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFF8FAFC),
        primaryColor: const Color(0xFF1E3A8A),
        useMaterial3: true,
      ),
      home: const ContactPage(),
    );
  }
}

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  // ==================== Couleurs ====================
  final Color djBlue = const Color(0xFF1E3A8A);
  final Color djBlueMid = const Color(0xFF3B82F6);
  final Color djWhite = Colors.white;
  final Color djText = const Color(0xFF111827);
  final Color djMuted = const Color(0xFF6B7280);
  final Color djBorder = const Color(0xFFE2E8F0);
  final Color djDark = const Color(0xFF0F172A);
  final Color successGreen = const Color(0xFF10B981);

  // ==================== État ====================
  String _selectedTag = 'Commande';
  final List<String> _tags = ['Commande', 'Livraison', 'Paiement', 'Retour', 'Partenariat', 'Autre'];

  final TextEditingController _fnCtrl = TextEditingController();
  final TextEditingController _lnCtrl = TextEditingController();
  final TextEditingController _emCtrl = TextEditingController();
  final TextEditingController _phCtrl = TextEditingController();
  final TextEditingController _msgCtrl = TextEditingController();

  bool _emError = false;
  bool _msgError = false;
  bool _showSuccess = false;

  void _doSend() {
    setState(() {
      _emError = _emCtrl.text.trim().isEmpty;
      _msgError = _msgCtrl.text.trim().isEmpty;
    });

    if (!_emError && !_msgError) {
      _fnCtrl.clear();
      _lnCtrl.clear();
      _emCtrl.clear();
      _phCtrl.clear();
      _msgCtrl.clear();

      setState(() => _showSuccess = true);

      Future.delayed(const Duration(seconds: 5), () {
        if (mounted) setState(() => _showSuccess = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            BuildHeader(currentPage: 'Contact',),
            _buildHero(),
            _buildMainLayout(context),
            _buildDarkBand(),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  // ==================== HERO (légèrement amélioré) ====================
  Widget _buildHero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 60, left: 48, right: 48, bottom: 40),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1)),
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1060),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFDBEAFE),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.support_agent, size: 18, color: Color(0xFF1E40AF)),
                    const SizedBox(width: 8),
                    const Text(
                      'SERVICE CLIENT',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF1E40AF)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w800, height: 1.05, color: Colors.black87),
                  children: [
                    const TextSpan(text: 'Une question ? '),
                    TextSpan(text: 'Nous sommes là.', style: TextStyle(color: djBlue)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Notre équipe sengage à vous répondre sous 4 heures en semaine. Remplissez le formulaire ci-dessous.',
                style: TextStyle(fontSize: 17, color: djMuted, height: 1.6),
              ),
              const SizedBox(height: 40),
              Row(
                children: [
                  _statItem('< 4h', 'Temps de réponse moyen'),
                  const SizedBox(width: 50),
                  _statItem('6j/7', 'Disponibilité'),
                  const SizedBox(width: 50),
                  _statItem('98%', 'Satisfaction client'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statItem(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value, style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: djBlue)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 13.5, color: djMuted)),
      ],
    );
  }

  // ==================== CONTENU PRINCIPAL ====================
  Widget _buildMainLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 50),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1080),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 820;

              return isDesktop
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 2, child: _buildForm()),
                        const SizedBox(width: 40),
                        Expanded(flex: 1, child: _buildSidebar()),
                      ],
                    )
                  : Column(
                      children: [
                        _buildForm(),
                        const SizedBox(height: 40),
                        _buildSidebar(),
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }

  // ==================== FORMULAIRE MODERNE ====================
  Widget _buildForm() {
    return Container(
      decoration: BoxDecoration(
        color: djWhite,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: djBorder),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        children: [
          // En-tête du formulaire
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
            decoration: BoxDecoration(
              color: djBlue,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Envoyez-nous un message',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
                ),
                SizedBox(height: 6),
                Text(
                  'Nous vous répondrons dans les plus brefs délais',
                  style: TextStyle(fontSize: 14.5, color: Colors.white70),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_showSuccess)
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFECFDF5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: successGreen.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: successGreen, size: 26),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Text(
                            'Votre message a été envoyé avec succès.\nNous vous répondrons sous 4 heures.',
                            style: TextStyle(color: Color(0xFF065F46), fontSize: 14.5, height: 1.5),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Tags
                const Text('SUJET DE LA DEMANDE', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Colors.black54)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _tags.map((tag) => _tagChip(tag)).toList(),
                ),

                const SizedBox(height: 28),
                Row(
                  children: [
                    Expanded(child: _buildTextField('Prénom', _fnCtrl)),
                    const SizedBox(width: 20),
                    Expanded(child: _buildTextField('Nom', _lnCtrl)),
                  ],
                ),
                const SizedBox(height: 20),
                _buildTextField('Email', _emCtrl, error: _emError, keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 20),
                _buildTextField('Téléphone', _phCtrl, keyboardType: TextInputType.phone),
                const SizedBox(height: 20),
                _buildTextField('Votre message', _msgCtrl, error: _msgError, maxLines: 5),

                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton.icon(
                    onPressed: _doSend,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: djBlue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    icon: const Icon(Icons.send_rounded, color: Colors.white),
                    label: const Text(
                      'Envoyer le message',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
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

  Widget _tagChip(String tag) {
    bool isSelected = _selectedTag == tag;
    return GestureDetector(
      onTap: () => setState(() => _selectedTag = tag),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFDBEAFE) : Colors.transparent,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: isSelected ? djBlueMid : djBorder,
            width: 1.2,
          ),
        ),
        child: Text(
          tag,
          style: TextStyle(
            fontSize: 13.5,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            color: isSelected ? djBlue : djMuted,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool error = false, int maxLines = 1, TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            hintText: label.contains('message') ? 'Décrivez votre demande en détail...' : null,
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: error ? Colors.red : djBorder, width: 1),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: error ? Colors.red : djBorder, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: djBlueMid, width: 1.8),
            ),
          ),
        ),
      ],
    );
  }

  // ==================== SIDEBAR MODERNE ====================
  Widget _buildSidebar() {
    return Column(
      children: [
        _infoCard(Icons.phone_rounded, 'Téléphone', '+253 21 35 67 89', const Color(0xFFDBEAFE), djBlue),
        const SizedBox(height: 16),
        _infoCard(Icons.email_rounded, 'Email', 'support@djibsouq.dj', const Color(0xFFECFDF5), const Color(0xFF10B981)),
        const SizedBox(height: 16),
        _infoCard(Icons.location_on_rounded, 'Adresse', 'Djibouti-ville, République de Djibouti', const Color(0xFFFEF3C7), const Color(0xFFB45309)),
        const SizedBox(height: 16),
        _infoCard(Icons.access_time_rounded, 'Horaires', 'Lundi  Vendredi : 08h  18h\nSamedi : 09h  13h', const Color(0xFFEEF2FF), const Color(0xFF6366F1)),
        const SizedBox(height: 24),
        _buildMapCard(),
      ],
    );
  }

  Widget _infoCard(IconData icon, String title, String value, Color bgColor, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: djBorder),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: iconColor, size: 26),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: djMuted)),
                const SizedBox(height: 6),
                Text(value, style: const TextStyle(fontSize: 15.5, height: 1.45, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: djBorder),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15)],
      ),
      child: Column(
        children: [
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F9FF),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(double.infinity, 160),
                  painter: _GridPainter(djBlue.withOpacity(0.15)),
                ),
                const Icon(Icons.location_pin, size: 60, color: Color(0xFF1E3A8A)),
                Positioned(
                  bottom: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
                    ),
                    child: const Text(
                      'DJIBSOUQ  Siège Social',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                _miniStat('Réponse', '< 4h', 'Incidents critiques'),
                const SizedBox(width: 12),
                _miniStat('Disponible', '6j/7', '08h  18h'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniStat(String label, String value, String sub) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 11, color: djMuted, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: djBlue)),
          Text(sub, style: TextStyle(fontSize: 12, color: djMuted)),
        ],
      ),
    );
  }

  // ==================== BANDES & FOOTER (inchangés sauf léger polish) ====================
  Widget _buildDarkBand() {
    return Container(
      width: double.infinity,
      color: djDark,
      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 48),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1060),
          child: Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 30,
            runSpacing: 30,
            children: [
              const SizedBox(
                width: 460,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Téléchargez lapp DJIBSOUQ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
                    SizedBox(height: 10),
                    Text(
                      'Commandez, suivez vos livraisons en temps réel et profitez doffres exclusives depuis votre mobile.',
                      style: TextStyle(fontSize: 14.5, color: Colors.white70, height: 1.6),
                    ),
                  ],
                ),
              ),
              Wrap(
                spacing: 12,
                children: [
                  _darkChip(Icons.play_arrow_rounded, 'Google Play'),
                  _darkChip(Icons.apple_rounded, 'App Store'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _darkChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28),
      color: djDark,
      child: const Center(
        child: Text(
          ' 2026 DJIBSOUQ  Djibouti, République de Djibouti  Tous droits réservés',
          style: TextStyle(fontSize: 13, color: Colors.white38),
        ),
      ),
    );
  }

  // ==================== Grid Painter (conservé) ====================
  @override
  void dispose() {
    _fnCtrl.dispose();
    _lnCtrl.dispose();
    _emCtrl.dispose();
    _phCtrl.dispose();
    _msgCtrl.dispose();
    super.dispose();
  }
}

class _GridPainter extends CustomPainter {
  final Color color;
  _GridPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 0.6;

    for (double x = 0; x <= size.width; x += 22) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += 22) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
