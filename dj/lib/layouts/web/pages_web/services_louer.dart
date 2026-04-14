import 'package:flutter/material.dart';
import 'package:dj/widgets/web_header.dart';

// ─────────────────────────────────────────────────────────────────────────────
//  COULEURS
// ─────────────────────────────────────────────────────────────────────────────
class _C {
  static const bg = Color(0xFFF8FAFC);
  static const surface = Color(0xFFFFFFFF);
  static const text1 = Color(0xFF0E0E0C);
  static const text2 = Color(0xFF5A5A56);
  static const text3 = Color(0xFF9C9C96);
  static const border = Color(0x12000000);
  static const borderMd = Color(0x1E000000);

  static const blue50 = Color(0xFFE6F1FB);
  static const blue100 = Color(0xFFB5D4F4);
  static const blue400 = Color(0xFF378ADD);
  static const blue600 = Color(0xFF185FA5);
  static const blue800 = Color(0xFF0C447C);

  static const teal50 = Color(0xFFE1F5EE);
  static const teal400 = Color(0xFF1D9E75);
  static const teal600 = Color(0xFF0F6E56);
  static const teal800 = Color(0xFF085041);

  // static const gray400  = Color(0xFF888780);
  //static const gray600  = Color(0xFF5F5E5A);
}

// ─────────────────────────────────────────────────────────────────────────────
//  MODÈLES
// ─────────────────────────────────────────────────────────────────────────────
class _ServiceData {
  final String id;
  final String category;
  final String title;
  final String tagline;
  final String description;
  final Color accentColor;
  final Color accentLight;
  final Color accentDark;
  final String imageEmoji;
  final List<String> highlights;
  final List<_DetailItem> details;
  final String ctaLabel;

  const _ServiceData({
    required this.id,
    required this.category,
    required this.title,
    required this.tagline,
    required this.description,
    required this.accentColor,
    required this.accentLight,
    required this.accentDark,
    required this.imageEmoji,
    required this.highlights,
    required this.details,
    required this.ctaLabel,
  });
}

class _DetailItem {
  final IconData icon;
  final String title;
  final String subtitle;
  const _DetailItem(this.icon, this.title, this.subtitle);
}

// ─────────────────────────────────────────────────────────────────────────────
//  DONNÉES
// ─────────────────────────────────────────────────────────────────────────────
const _kServices = [
  _ServiceData(
    id: 'maintenance',
    category: 'Partenariat · RoomTech',
    title: 'Maintenance\nInformatique',
    tagline: 'Votre infrastructure entre de bonnes mains',
    description:
        'En partenariat avec RoomTech, société spécialisée, '
        'nous gérons toute votre infrastructure IT. '
        'De la cybersécurité au monitoring 24h, '
        'chaque incident est traité avec réactivité et expertise.',
    accentColor: _C.blue600,
    accentLight: _C.blue50,
    accentDark: _C.blue800,
    imageEmoji: '🖥️',
    highlights: ['Réponse < 4h', 'Uptime 99%', '6j/7 — 8h–20h'],
    details: [
      _DetailItem(
        Icons.shield_outlined,
        'Cybersécurité & antivirus',
        'Protection proactive de vos systèmes',
      ),
      _DetailItem(
        Icons.dns_outlined,
        'Gestion réseau & serveurs',
        'Configuration, maintenance et suivi',
      ),
      _DetailItem(
        Icons.show_chart,
        'Monitoring temps réel',
        'Alertes immédiates en cas d\'anomalie',
      ),
      _DetailItem(
        Icons.schedule_outlined,
        'Interventions planifiées & urgentes',
        'Sur site ou à distance',
      ),
      _DetailItem(
        Icons.description_outlined,
        'Rapport mensuel détaillé',
        'Bilan complet de votre infrastructure',
      ),
      _DetailItem(
        Icons.support_agent_outlined,
        'Support dédié RoomTech',
        'Équipe de techniciens certifiés',
      ),
    ],
    ctaLabel: 'Demander un devis',
  ),
  _ServiceData(
    id: 'saas',
    category: 'Outils · Plateformes SaaS',
    title: 'Location de\nPlateformes SaaS',
    tagline: 'Les meilleurs outils, sans la complexité',
    description:
        'Accédez aux outils professionnels dont vous avez besoin '
        'sans gérer les licences. Nous négocions l\'accès pour vous '
        'et incluons l\'activation, la configuration et le support.',
    accentColor: _C.teal600,
    accentLight: _C.teal50,
    accentDark: _C.teal800,
    imageEmoji: '⚡',
    highlights: ['Activation rapide', 'Prix négociés', 'Support inclus'],
    details: [
      _DetailItem(
        Icons.brush_outlined,
        'Canva Pro',
        'Design graphique & marketing',
      ),
      _DetailItem(
        Icons.notes_outlined,
        'Notion',
        'Productivité & gestion de projet',
      ),
      _DetailItem(Icons.create_outlined, 'Figma', 'Design UI/UX collaboratif'),
      _DetailItem(
        Icons.message_outlined,
        'Slack Pro',
        'Communication d\'équipe',
      ),
      _DetailItem(
        Icons.video_call_outlined,
        'Zoom Pro',
        'Visioconférence professionnelle',
      ),
      _DetailItem(
        Icons.photo_library_outlined,
        'Adobe CC',
        'Suite créative complète',
      ),
    ],
    ctaLabel: 'Voir les offres',
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
//  PAGE PRINCIPALE
// ─────────────────────────────────────────────────────────────────────────────
class ServicesPage extends StatefulWidget {
  const ServicesPage({super.key});

  @override
  State<ServicesPage> createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _heroCtrl;
  late Animation<double> _heroFade;
  late Animation<Offset> _heroSlide;

  @override
  void initState() {
    super.initState();
    _heroCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _heroFade = CurvedAnimation(parent: _heroCtrl, curve: Curves.easeOut);
    _heroSlide = Tween<Offset>(
      begin: const Offset(0, 0.05),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _heroCtrl, curve: Curves.easeOutCubic));
    WidgetsBinding.instance.addPostFrameCallback((_) => _heroCtrl.forward());
  }

  @override
  void dispose() {
    _heroCtrl.dispose();
    super.dispose();
  }

  void _openDetail(_ServiceData service) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ServiceDetailSheet(service: service),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _C.bg,
      body: SafeArea(
        child: Column(
          children: [
            const BuildHeader(currentPage: 'Services'),
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1100),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: FadeTransition(
                        opacity: _heroFade,
                        child: SlideTransition(
                          position: _heroSlide,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 56),
                              const _HeroHeader(),
                              const SizedBox(height: 48),
                              _ServicesRow(onTap: _openDetail),
                              const SizedBox(height: 56),
                              const _PartnerStrip(),
                              const SizedBox(height: 56),
                              const _FooterRow(),
                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  HERO HEADER
// ─────────────────────────────────────────────────────────────────────────────
class _HeroHeader extends StatelessWidget {
  const _HeroHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: _C.surface,
            borderRadius: BorderRadius.circular(99),
            border: Border.all(color: _C.borderMd),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: _C.teal400,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Services disponibles',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: _C.text2,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Deux services,\nune seule solution.',
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.w800,
            height: 1.08,
            letterSpacing: -1.5,
            color: _C.text1,
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Maintenance informatique professionnelle avec RoomTech '
          'et accès à toutes vos plateformes SaaS favorites, sans friction.',
          style: TextStyle(fontSize: 17, color: _C.text2, height: 1.7),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  LIGNE DES 2 CARTES
// ─────────────────────────────────────────────────────────────────────────────
class _ServicesRow extends StatelessWidget {
  final void Function(_ServiceData) onTap;
  const _ServicesRow({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    final cards = _kServices
        .asMap()
        .entries
        .map((e) => _ServiceCard(service: e.value, onTap: () => onTap(e.value)))
        .toList();

    if (isMobile) {
      return Column(
        children: cards
            .map(
              (c) =>
                  Padding(padding: const EdgeInsets.only(bottom: 16), child: c),
            )
            .toList(),
      );
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: cards[0]),
          const SizedBox(width: 20),
          Expanded(child: cards[1]),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  CARTE SERVICE  ← pièce maîtresse
// ─────────────────────────────────────────────────────────────────────────────
class _ServiceCard extends StatefulWidget {
  final _ServiceData service;
  final VoidCallback onTap;
  const _ServiceCard({required this.service, required this.onTap});

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _scale = Tween<double>(
      begin: 1,
      end: 1.015,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.service;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() => _hovered = true);
        _ctrl.forward();
      },
      onExit: (_) {
        setState(() => _hovered = false);
        _ctrl.reverse();
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _ctrl,
          builder: (_, child) =>
              Transform.scale(scale: _scale.value, child: child),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            decoration: BoxDecoration(
              color: _C.surface,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: _hovered ? s.accentColor.withOpacity(.4) : _C.border,
                width: _hovered ? 1.5 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: s.accentColor.withOpacity(_hovered ? .16 : .05),
                  blurRadius: _hovered ? 48 : 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── ZONE IMAGE ────────────────────────────────────────
                  _CardImageZone(service: s, hovered: _hovered),
                  // ── CONTENU ───────────────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(26, 22, 26, 26),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: s.accentLight,
                            borderRadius: BorderRadius.circular(99),
                          ),
                          child: Text(
                            s.category,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: .4,
                              color: s.accentDark,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          s.title,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            height: 1.15,
                            letterSpacing: -.5,
                            color: _C.text1,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          s.tagline,
                          style: const TextStyle(
                            fontSize: 14,
                            color: _C.text2,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 18),
                        // Highlights
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            for (final h in s.highlights)
                              _HighlightChip(label: h, color: s.accentColor),
                          ],
                        ),
                        const SizedBox(height: 22),
                        // CTA row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Voir les détails →',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: s.accentColor,
                              ),
                            ),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: _hovered ? s.accentColor : s.accentLight,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                size: 17,
                                color: _hovered ? Colors.white : s.accentColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  ZONE IMAGE / ILLUSTRATION DE LA CARTE
// ─────────────────────────────────────────────────────────────────────────────
class _CardImageZone extends StatelessWidget {
  final _ServiceData service;
  final bool hovered;
  const _CardImageZone({required this.service, required this.hovered});

  @override
  Widget build(BuildContext context) {
    final s = service;
    final isMaintenance = s.id == 'maintenance';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 230,
      decoration: BoxDecoration(
        color: hovered
            ? s.accentColor.withOpacity(.09)
            : s.accentLight.withOpacity(.55),
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          // Grille de points
          Positioned.fill(
            child: CustomPaint(
              painter: _DotGridPainter(color: s.accentColor.withOpacity(.07)),
            ),
          ),
          // Cercle décoratif grand
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: s.accentColor.withOpacity(.08),
              ),
            ),
          ),
          // Cercle décoratif petit
          Positioned(
            bottom: 20,
            left: -20,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: s.accentColor.withOpacity(.07),
              ),
            ),
          ),

          // Icônes flottantes autour
          ..._buildFloatingIcons(s, hovered),

          // Emoji central géant
          Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 300),
              style: TextStyle(fontSize: hovered ? 86 : 76),
              child: Text(s.imageEmoji),
            ),
          ),

          // Badge partenaire / nb outils
          Positioned(
            bottom: 14,
            left: 20,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _C.surface.withOpacity(.9),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: s.accentColor.withOpacity(.15),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    isMaintenance ? 'RT' : '10+',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: s.accentColor,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    isMaintenance ? 'Partenaire RoomTech' : 'Plateformes SaaS',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: _C.text1,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // "Voir détails" badge au hover
          Positioned(
            top: 14,
            right: 14,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: hovered ? 1 : 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: s.accentColor,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: const Text(
                  'Voir détails',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFloatingIcons(_ServiceData s, bool hovered) {
    final items = s.id == 'maintenance'
        ? [
            (Icons.shield_outlined, -0.75, -0.40),
            (Icons.dns_outlined, 0.78, -0.38),
            (Icons.show_chart, -0.72, 0.50),
            (Icons.wifi_outlined, 0.75, 0.52),
          ]
        : [
            (Icons.brush_outlined, -0.76, -0.42),
            (Icons.video_call_outlined, 0.77, -0.40),
            (Icons.edit_note_outlined, -0.74, 0.48),
            (Icons.photo_library_outlined, 0.76, 0.50),
          ];

    return items
        .map(
          (item) => Positioned.fill(
            child: Align(
              alignment: Alignment(item.$2, item.$3),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 250),
                opacity: hovered ? 1.0 : 0.6,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: hovered ? 40 : 36,
                  height: hovered ? 40 : 36,
                  decoration: BoxDecoration(
                    color: _C.surface,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: s.accentColor.withOpacity(.18),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(item.$1, size: 17, color: s.accentColor),
                ),
              ),
            ),
          ),
        )
        .toList();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  DOT GRID PAINTER
// ─────────────────────────────────────────────────────────────────────────────
class _DotGridPainter extends CustomPainter {
  final Color color;
  const _DotGridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    const step = 22.0;
    for (double x = 0; x < size.width; x += step) {
      for (double y = 0; y < size.height; y += step) {
        canvas.drawCircle(Offset(x, y), 1.4, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DotGridPainter old) => old.color != color;
}

// ─────────────────────────────────────────────────────────────────────────────
//  HIGHLIGHT CHIP
// ─────────────────────────────────────────────────────────────────────────────
class _HighlightChip extends StatelessWidget {
  final String label;
  final Color color;
  const _HighlightChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: _C.bg,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: _C.borderMd),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: _C.text1,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  PARTNER STRIP
// ─────────────────────────────────────────────────────────────────────────────
class _PartnerStrip extends StatelessWidget {
  const _PartnerStrip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _C.border),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: _C.blue600,
              borderRadius: BorderRadius.circular(11),
            ),
            alignment: Alignment.center,
            child: const Text(
              'RT',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: .5,
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'RoomTech — Partenaire certifié',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: _C.text1,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'Société de maintenance IT reconnue, intervenant avec des techniciens '
                  'certifiés et une approche orientée résultats.',
                  style: TextStyle(fontSize: 13, color: _C.text2, height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          _Btn(label: 'En savoir plus', onTap: () {}),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  FOOTER ROW
// ─────────────────────────────────────────────────────────────────────────────
class _FooterRow extends StatelessWidget {
  const _FooterRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          '© 2026 DJIBSOUQ · En partenariat avec RoomTech',
          style: TextStyle(fontSize: 13, color: _C.text3),
        ),
        Row(
          children: [
            for (final l in ['Confidentialité', 'Conditions', 'Contact'])
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  l,
                  style: const TextStyle(fontSize: 13, color: _C.text3),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  BOTTOM SHEET — DÉTAIL
// ─────────────────────────────────────────────────────────────────────────────
class _ServiceDetailSheet extends StatelessWidget {
  final _ServiceData service;
  const _ServiceDetailSheet({required this.service});

  @override
  Widget build(BuildContext context) {
    final s = service;
    final isMaintenance = s.id == 'maintenance';

    return DraggableScrollableSheet(
      initialChildSize: .88,
      minChildSize: .5,
      maxChildSize: .96,
      builder: (_, controller) => Container(
        decoration: const BoxDecoration(
          color: _C.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: _C.borderMd,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.fromLTRB(28, 16, 28, 40),
                children: [
                  // ── HEADER ─────────────────────────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: s.accentLight,
                                borderRadius: BorderRadius.circular(99),
                              ),
                              child: Text(
                                s.category,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: s.accentDark,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              s.title,
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                height: 1.1,
                                letterSpacing: -.8,
                                color: _C.text1,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              s.tagline,
                              style: const TextStyle(
                                fontSize: 16,
                                color: _C.text2,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(s.imageEmoji, style: const TextStyle(fontSize: 64)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── DESCRIPTION ────────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: s.accentLight.withOpacity(.5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: s.accentColor.withOpacity(.12)),
                    ),
                    child: Text(
                      s.description,
                      style: const TextStyle(
                        fontSize: 15,
                        color: _C.text2,
                        height: 1.75,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── HIGHLIGHTS ─────────────────────────────────────────
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (final h in s.highlights)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: s.accentLight,
                            borderRadius: BorderRadius.circular(99),
                            border: Border.all(
                              color: s.accentColor.withOpacity(.2),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle_outline_rounded,
                                size: 14,
                                color: s.accentColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                h,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: s.accentDark,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // ── DÉTAILS ────────────────────────────────────────────
                  Text(
                    isMaintenance
                        ? 'Services inclus'
                        : 'Plateformes disponibles',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -.3,
                      color: _C.text1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: s.details.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 2.5,
                        ),
                    itemBuilder: (_, i) => _DetailCard(
                      item: s.details[i],
                      accentColor: s.accentColor,
                      accentLight: s.accentLight,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // ── SLA (maintenance only) ─────────────────────────────
                  if (isMaintenance) ...[
                    const Text(
                      'Engagements de service',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -.3,
                        color: _C.text1,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 2.2,
                      children: const [
                        _SlaBox(
                          label: 'Réponse',
                          val: '< 4h',
                          sub: 'Incidents critiques',
                        ),
                        _SlaBox(
                          label: 'Disponibilité',
                          val: '6j/7',
                          sub: '8h – 20h',
                        ),
                        _SlaBox(
                          label: 'Uptime garanti',
                          val: '99%',
                          sub: 'Réseau & serveurs',
                        ),
                        _SlaBox(
                          label: 'Intervention',
                          val: 'Sur site',
                          sub: '& à distance',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // RoomTech about card
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: _C.bg,
                        borderRadius: BorderRadius.circular(14),
                        border: Border(
                          left: const BorderSide(color: _C.blue400, width: 3),
                          top: BorderSide(color: _C.blue100),
                          right: BorderSide(color: _C.blue100),
                          bottom: BorderSide(color: _C.blue100),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: _C.blue600,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'RT',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'RoomTech',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: _C.blue800,
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  'Équipe de techniciens certifiés avec une approche orientée résultats.',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: _C.text2,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],

                  // ── PLANS (saas only) ──────────────────────────────────
                  if (!isMaintenance) ...[
                    const Text(
                      'Nos formules',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -.3,
                        color: _C.text1,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...[
                      (
                        '🌱',
                        'Starter',
                        '29 000',
                        ['Canva Pro', 'Notion', 'Zoom Pro'],
                      ),
                      (
                        '⚡',
                        'Pro',
                        '59 000',
                        ['Canva Pro', 'Notion', 'Figma', 'Slack', 'Zoom Pro'],
                      ),
                      (
                        '🏢',
                        'Entreprise',
                        '99 000',
                        [
                          'Canva Pro',
                          'Notion',
                          'Figma',
                          'Slack',
                          'Zoom',
                          'Adobe CC',
                        ],
                      ),
                    ].map(
                      (p) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _PlanRow(
                          emoji: p.$1,
                          name: p.$2,
                          price: p.$3,
                          tools: p.$4,
                          featured: p.$2 == 'Pro',
                          accentColor: s.accentColor,
                          accentLight: s.accentLight,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // ── CTA ────────────────────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: s.accentColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        s.ctaLabel,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
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
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  DETAIL CARD
// ─────────────────────────────────────────────────────────────────────────────
class _DetailCard extends StatelessWidget {
  final _DetailItem item;
  final Color accentColor, accentLight;
  const _DetailCard({
    required this.item,
    required this.accentColor,
    required this.accentLight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _C.bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _C.border),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: accentLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(item.icon, size: 16, color: accentColor),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _C.text1,
                  ),
                ),
                Text(
                  item.subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: _C.text3,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  PLAN ROW (sheet SaaS)
// ─────────────────────────────────────────────────────────────────────────────
class _PlanRow extends StatelessWidget {
  final String emoji, name, price;
  final List<String> tools;
  final bool featured;
  final Color accentColor, accentLight;

  const _PlanRow({
    required this.emoji,
    required this.name,
    required this.price,
    required this.tools,
    required this.featured,
    required this.accentColor,
    required this.accentLight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _C.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: featured ? accentColor.withOpacity(.4) : _C.border,
          width: featured ? 1.5 : 1,
        ),
        boxShadow: featured
            ? [BoxShadow(color: accentColor.withOpacity(.08), blurRadius: 16)]
            : null,
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: _C.text1,
                      ),
                    ),
                    if (featured) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: accentLight,
                          borderRadius: BorderRadius.circular(99),
                        ),
                        child: Text(
                          'Populaire',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: accentColor,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: tools
                      .map(
                        (t) => Text(
                          t,
                          style: const TextStyle(fontSize: 12, color: _C.text3),
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: _C.text1,
                ),
              ),
              const Text(
                'FCFA/mois',
                style: TextStyle(fontSize: 11, color: _C.text3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  SLA BOX
// ─────────────────────────────────────────────────────────────────────────────
class _SlaBox extends StatelessWidget {
  const _SlaBox({required this.label, required this.val, required this.sub});
  final String label, val, sub;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _C.bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _C.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              color: _C.text3,
              letterSpacing: .8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            val,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: _C.text1,
            ),
          ),
          Text(sub, style: const TextStyle(fontSize: 11, color: _C.text2)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  BOUTON RÉUTILISABLE
// ─────────────────────────────────────────────────────────────────────────────
class _Btn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _Btn({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
        decoration: BoxDecoration(
          color: _C.text1,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: _C.surface,
          ),
        ),
      ),
    );
  }
}
