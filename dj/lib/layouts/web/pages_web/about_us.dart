import 'package:dj/widgets/web_header.dart';
import 'package:flutter/material.dart';
import 'package:dj/routes.dart';

// ─────────────────────────────────────────────
//  DESIGN TOKENS
// ─────────────────────────────────────────────
const Color _navy      = Color(0xFF0B1628);
const Color _blue      = Color(0xFF1E3A8A);
const Color _blueLight = Color(0xFF3B82F6);
const Color _accent    = Color(0xFF06B6D4);  // cyan accent
const Color _gold      = Color(0xFFF59E0B);
const Color _surface   = Color(0xFFF8FAFC);
const Color _card      = Color(0xFFFFFFFF);
const Color _border    = Color(0xFFE2E8F0);
const Color _textDark  = Color(0xFF0F172A);
const Color _textMid   = Color(0xFF475569);
const Color _textLight = Color(0xFF94A3B8);

const double _mobileBreak = 700;
const double _tabletBreak = 1024;

// ─────────────────────────────────────────────
//  PAGE
// ─────────────────────────────────────────────
class AboutUsWeb extends StatefulWidget {
  const AboutUsWeb({super.key});
  @override
  State<AboutUsWeb> createState() => _AboutUsWebState();
}

class _AboutUsWebState extends State<AboutUsWeb> with TickerProviderStateMixin {
  late final AnimationController _heroCtrl;
  late final Animation<double> _heroFade;
  late final Animation<Offset> _heroSlide;

  @override
  void initState() {
    super.initState();
    _heroCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _heroFade  = CurvedAnimation(parent: _heroCtrl, curve: Curves.easeOut);
    _heroSlide = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(CurvedAnimation(parent: _heroCtrl, curve: Curves.easeOutCubic));
    WidgetsBinding.instance.addPostFrameCallback((_) => _heroCtrl.forward());
  }

  @override
  void dispose() {
    _heroCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      body: SingleChildScrollView(
        child: Column(
          children: [
            BuildHeader(currentPage: 'À propos'),
            FadeTransition(
              opacity: _heroFade,
              child: SlideTransition(
                position: _heroSlide,
                child: Column(
                  children: [
                    _HeroSection(),
                    _StatsStrip(),
                    _MissionSection(),
                    _ValuesSection(),
                    _TimelineSection(),
                    _TeamSection(),
                    _CTASection(),
                    _FooterBar(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  HERO
// ─────────────────────────────────────────────
class _HeroSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final isMobile = c.maxWidth < _mobileBreak;
      return Stack(
        children: [
          // Background gradient
          Container(
            height: isMobile ? 520 : 580,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [_navy, Color(0xFF0F2A5C), Color(0xFF0B1628)],
              ),
            ),
          ),
          // Decorative grid overlay
          Positioned.fill(
            child: CustomPaint(painter: _GridPainter()),
          ),
          // Decorative circles
          Positioned(top: -80, right: -60, child: _GlowCircle(size: 340, color: _blueLight.withOpacity(0.08))),
          Positioned(bottom: -40, left: -40, child: _GlowCircle(size: 260, color: _accent.withOpacity(0.06))),
          // Content
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 24 : 80,
              vertical: isMobile ? 60 : 80,
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 860),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Label chip
                    _Chip(label: 'DEPUIS 2020 · DJIBOUTI', color: _accent),
                    const SizedBox(height: 28),
                    Text(
                      isMobile
                          ? 'La marketplace\nde référence\nà Djibouti'
                          : 'La marketplace\nde référence à Djibouti',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isMobile ? 42 : 58,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.08,
                        letterSpacing: -1.5,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      'DJIBSOUQ connecte vendeurs locaux et acheteurs à travers\ntout le pays — simplement, rapidement, équitablement.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isMobile ? 16 : 18,
                        color: Colors.white.withOpacity(0.65),
                        height: 1.7,
                      ),
                    ),
                    const SizedBox(height: 36),
                    if (!isMobile)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _HeroButton(
                            label: 'Découvrir les produits',
                            icon: Icons.arrow_forward_rounded,
                            filled: true,
                            onTap: () => Navigator.pushNamed(context, AppRoutes.products),
                          ),
                          const SizedBox(width: 14),
                          _HeroButton(
                            label: 'Nous contacter',
                            icon: Icons.mail_outline_rounded,
                            filled: false,
                            onTap: () => Navigator.pushNamed(context, AppRoutes.contact_us),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}

// ─────────────────────────────────────────────
//  STATS STRIP
// ─────────────────────────────────────────────
class _StatsStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stats = [
      ('15 000+', 'Clients satisfaits'),
      ('2 800',   'Vendeurs actifs'),
      ('65 000+', 'Produits disponibles'),
      ('98 %',    'Taux de satisfaction'),
    ];
    return LayoutBuilder(builder: (context, c) {
      final isMobile = c.maxWidth < _mobileBreak;
      return Container(
        color: _card,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 36, horizontal: isMobile ? 20 : 60),
              child: isMobile
                  ? GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 2.2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      children: stats.map((s) => _StatTile(num: s.$1, label: s.$2)).toList(),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: stats.map((s) => _StatTile(num: s.$1, label: s.$2)).toList(),
                    ),
            ),
          ),
        ),
      );
    });
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.num, required this.label});
  final String num, label;
  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      ShaderMask(
        shaderCallback: (b) => const LinearGradient(
          colors: [_blueLight, _accent],
        ).createShader(b),
        child: Text(num, style: const TextStyle(
          fontSize: 36, fontWeight: FontWeight.w800,
          color: Colors.white, letterSpacing: -0.5,
        )),
      ),
      const SizedBox(height: 4),
      Text(label, style: const TextStyle(fontSize: 13, color: _textMid)),
    ]);
  }
}

// ─────────────────────────────────────────────
//  MISSION & VISION
// ─────────────────────────────────────────────
class _MissionSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final isMobile = c.maxWidth < _mobileBreak;
      return Container(
        color: _surface,
        padding: EdgeInsets.symmetric(vertical: isMobile ? 60 : 88, horizontal: isMobile ? 24 : 80),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(children: [
              _SectionLabel(label: 'NOTRE RAISON D\'ÊTRE'),
              const SizedBox(height: 16),
              Text('Ce qui nous anime', style: TextStyle(
                fontSize: isMobile ? 30 : 40,
                fontWeight: FontWeight.w800,
                color: _textDark,
                letterSpacing: -0.8,
              )),
              const SizedBox(height: 48),
              isMobile
                  ? Column(children: [
                      _MissionCard(icon: Icons.flag_rounded, accent: _blue,
                          title: 'Notre Mission',
                          body: 'Rendre les produits locaux accessibles à tous les Djiboutiens grâce à une plateforme simple, rapide et fiable.'),
                      const SizedBox(height: 24),
                      _MissionCard(icon: Icons.auto_awesome_rounded, accent: _accent,
                          title: 'Notre Vision',
                          body: 'Devenir la référence du e-commerce en Afrique de l\'Est en valorisant l\'économie locale et les entrepreneurs djiboutiens.'),
                    ])
                  : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Expanded(child: _MissionCard(icon: Icons.flag_rounded, accent: _blue,
                          title: 'Notre Mission',
                          body: 'Rendre les produits locaux accessibles à tous les Djiboutiens grâce à une plateforme simple, rapide et fiable.')),
                      const SizedBox(width: 28),
                      Expanded(child: _MissionCard(icon: Icons.auto_awesome_rounded, accent: _accent,
                          title: 'Notre Vision',
                          body: 'Devenir la référence du e-commerce en Afrique de l\'Est en valorisant l\'économie locale et les entrepreneurs djiboutiens.')),
                    ]),
            ]),
          ),
        ),
      );
    });
  }
}

class _MissionCard extends StatelessWidget {
  const _MissionCard({required this.icon, required this.accent, required this.title, required this.body});
  final IconData icon;
  final Color accent;
  final String title, body;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(36),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _border),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 24, offset: const Offset(0, 8))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: 52, height: 52,
          decoration: BoxDecoration(
            color: accent.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: accent, size: 26),
        ),
        const SizedBox(height: 24),
        Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: _textDark, letterSpacing: -0.3)),
        const SizedBox(height: 12),
        Container(width: 32, height: 3, decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(4))),
        const SizedBox(height: 16),
        Text(body, style: const TextStyle(fontSize: 15.5, color: _textMid, height: 1.75)),
      ]),
    );
  }
}

// ─────────────────────────────────────────────
//  VALUES
// ─────────────────────────────────────────────
class _ValuesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final values = [
      (Icons.verified_rounded,     _blue,   'Intégrité',    'Transparence totale avec nos vendeurs et acheteurs à chaque étape.'),
      (Icons.lock_rounded,         _accent, 'Sécurité',     'Paiements chiffrés et protection complète de vos données personnelles.'),
      (Icons.groups_rounded,       _gold,   'Communauté',   'Soutien des entrepreneurs locaux et de l\'économie djiboutienne.'),
      (Icons.rocket_launch_rounded, const Color(0xFF8B5CF6), 'Innovation', 'Amélioration continue pour une expérience toujours plus fluide.'),
    ];
    return LayoutBuilder(builder: (context, c) {
      final isMobile = c.maxWidth < _mobileBreak;
      final isTablet = c.maxWidth < _tabletBreak;
      return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0B1628), Color(0xFF0F2245)],
          ),
        ),
        padding: EdgeInsets.fromLTRB(
          isMobile ? 24 : 80,
          isMobile ? 60 : 88,
          isMobile ? 24 : 80,
          isMobile ? 62 : 90,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(children: [
              _SectionLabel(label: 'NOS VALEURS', light: true),
              const SizedBox(height: 16),
              Text('Ce qui guide nos décisions', style: TextStyle(
                fontSize: isMobile ? 30 : 40,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -0.8,
              )),
              const SizedBox(height: 48),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 4),
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: isMobile ? 2.8 : (isTablet ? 1.9 : 1.15),
                ),
                itemCount: values.length,
                itemBuilder: (_, i) {
                  final v = values[i];
                  return _ValueCard(icon: v.$1, accent: v.$2, title: v.$3, body: v.$4);
                },
              ),
            ]),
          ),
        ),
      );
    });
  }
}

class _ValueCard extends StatefulWidget {
  const _ValueCard({required this.icon, required this.accent, required this.title, required this.body});
  final IconData icon;
  final Color accent;
  final String title, body;
  @override
  State<_ValueCard> createState() => _ValueCardState();
}

class _ValueCardState extends State<_ValueCard> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: _hovered
              ? Colors.white.withOpacity(0.07)
              : Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: _hovered ? widget.accent.withOpacity(0.6) : Colors.white.withOpacity(0.1),
          ),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: widget.accent.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(widget.icon, color: widget.accent, size: 22),
          ),
          const SizedBox(height: 18),
          Text(widget.title, style: const TextStyle(
            fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: -0.2,
          )),
          const SizedBox(height: 10),
          Text(widget.body, style: TextStyle(
            fontSize: 13.5, color: Colors.white.withOpacity(0.55), height: 1.65,
          )),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  TIMELINE / STORY
// ─────────────────────────────────────────────
class _TimelineSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final events = [
      ('2020', 'Lancement', 'DJIBSOUQ est fondé avec une vision simple : connecter Djibouti.'),
      ('2021', 'Croissance', 'Cap des 1 000 vendeurs inscrits et lancement de l\'application mobile.'),
      ('2023', 'Expansion', 'Plus de 10 000 clients actifs et déploiement dans toutes les régions.'),
      ('2026', 'Aujourd\'hui', '65 000+ produits, 2 800 vendeurs et une communauté en plein essor.'),
    ];
    return LayoutBuilder(builder: (context, c) {
      final isMobile = c.maxWidth < _mobileBreak;
      return Container(
        color: _surface,
        padding: EdgeInsets.symmetric(vertical: isMobile ? 60 : 88, horizontal: isMobile ? 24 : 80),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(children: [
              _SectionLabel(label: 'NOTRE HISTOIRE'),
              const SizedBox(height: 16),
              Text('Le chemin parcouru', style: TextStyle(
                fontSize: isMobile ? 30 : 40,
                fontWeight: FontWeight.w800,
                color: _textDark,
                letterSpacing: -0.8,
              )),
              const SizedBox(height: 52),
              isMobile
                  ? Column(
                      children: List.generate(events.length, (i) => Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: _TimelineTile(
                          year: events[i].$1,
                          title: events[i].$2,
                          body: events[i].$3,
                          isLast: i == events.length - 1,
                        ),
                      )),
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(events.length, (i) => Expanded(
                        child: _TimelineNode(
                          year: events[i].$1,
                          title: events[i].$2,
                          body: events[i].$3,
                          index: i,
                          total: events.length,
                        ),
                      )),
                    ),
            ]),
          ),
        ),
      );
    });
  }
}

class _TimelineTile extends StatelessWidget {
  const _TimelineTile({required this.year, required this.title, required this.body, required this.isLast});
  final String year, title, body;
  final bool isLast;
  @override
  Widget build(BuildContext context) {
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Column(children: [
        Container(
          width: 14, height: 14,
          decoration: const BoxDecoration(color: _blueLight, shape: BoxShape.circle),
        ),
        if (!isLast)
          Container(width: 2, height: 80, color: _border),
      ]),
      const SizedBox(width: 20),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(year, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _blueLight, letterSpacing: 1)),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: _textDark)),
        const SizedBox(height: 6),
        Text(body, style: const TextStyle(fontSize: 14, color: _textMid, height: 1.6)),
      ])),
    ]);
  }
}

class _TimelineNode extends StatelessWidget {
  const _TimelineNode({required this.year, required this.title, required this.body, required this.index, required this.total});
  final String year, title, body;
  final int index, total;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [_blue, _blueLight]),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(child: Text('${index + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16))),
          ),
          Expanded(child: Container(height: 2, color: index < total - 1 ? _border : Colors.transparent)),
        ]),
        const SizedBox(height: 16),
        Text(year, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _blueLight, letterSpacing: 1)),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: _textDark)),
        const SizedBox(height: 8),
        Text(body, style: const TextStyle(fontSize: 13.5, color: _textMid, height: 1.65)),
      ]),
    );
  }
}

// ─────────────────────────────────────────────
//  TEAM
// ─────────────────────────────────────────────
class _TeamSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final team = [
      ('Ali Hassan',      'Fondateur & PDG',        'Visionnaire du commerce numérique à Djibouti.', 'AH', _blue),
      ('Fatima Ibrahim',  'Directrice Opérations',  'Logistique & excellence de l\'expérience client.', 'FI', _accent),
      ('Mohamed Ahmed',   'CTO',                    'Architecte de la plateforme et tech lead.', 'MA', _gold),
      ('Amina Said',      'Responsable Support',    'Championne du service client 5 étoiles.', 'AS', const Color(0xFF8B5CF6)),
    ];
    return LayoutBuilder(builder: (context, c) {
      final isMobile = c.maxWidth < _mobileBreak;
      final isTablet = c.maxWidth < _tabletBreak;
      return Container(
        color: _card,
        padding: EdgeInsets.symmetric(vertical: isMobile ? 60 : 88, horizontal: isMobile ? 24 : 80),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(children: [
              _SectionLabel(label: 'L\'ÉQUIPE'),
              const SizedBox(height: 16),
              Text('Les visages derrière DJIBSOUQ', style: TextStyle(
                fontSize: isMobile ? 30 : 40,
                fontWeight: FontWeight.w800,
                color: _textDark,
                letterSpacing: -0.8,
              )),
              const SizedBox(height: 48),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 4),
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 20,
                  childAspectRatio: isMobile ? 3 : (isTablet ? 1.8 : 1.2),
                ),
                itemCount: team.length,
                itemBuilder: (_, i) {
                  final m = team[i];
                  return _TeamCard(name: m.$1, role: m.$2, bio: m.$3, initials: m.$4, accent: m.$5);
                },
              ),
            ]),
          ),
        ),
      );
    });
  }
}

class _TeamCard extends StatefulWidget {
  const _TeamCard({required this.name, required this.role, required this.bio, required this.initials, required this.accent});
  final String name, role, bio, initials;
  final Color accent;
  @override
  State<_TeamCard> createState() => _TeamCardState();
}

class _TeamCardState extends State<_TeamCard> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _hovered ? widget.accent.withOpacity(0.45) : _border,
            width: _hovered ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: _hovered ? widget.accent.withOpacity(0.12) : Colors.black.withOpacity(0.04),
              blurRadius: _hovered ? 28 : 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: 64, height: 64,
            decoration: BoxDecoration(
              color: widget.accent.withOpacity(_hovered ? 0.2 : 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(child: Text(widget.initials, style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w700, color: widget.accent,
            ))),
          ),
          const SizedBox(height: 16),
          Text(widget.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: _textDark)),
          const SizedBox(height: 4),
          Text(widget.role, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: widget.accent, letterSpacing: 0.2)),
          const SizedBox(height: 10),
          Text(widget.bio, textAlign: TextAlign.center, style: const TextStyle(fontSize: 13, color: _textMid, height: 1.55)),
        ]),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  CTA
// ─────────────────────────────────────────────
class _CTASection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, c) {
      final isMobile = c.maxWidth < _mobileBreak;
      return Container(
        color: _surface,
        padding: EdgeInsets.symmetric(vertical: isMobile ? 60 : 88, horizontal: isMobile ? 24 : 80),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Stack(children: [
              // Glow bg
              Positioned.fill(child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                    colors: [Color(0xFF0F2A5C), _navy],
                  ),
                ),
              )),
              Positioned(top: -60, right: -60, child: _GlowCircle(size: 240, color: _accent.withOpacity(0.12))),
              Padding(
                padding: EdgeInsets.all(isMobile ? 32 : 56),
                child: Column(children: [
                  const Icon(Icons.storefront_rounded, color: _accent, size: 36),
                  const SizedBox(height: 20),
                  Text(
                    'Prêt à rejoindre l\'aventure ?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isMobile ? 26 : 36,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: -0.7,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Que vous soyez vendeur ou acheteur, DJIBSOUQ est fait pour vous.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, color: Colors.white54, height: 1.6),
                  ),
                  const SizedBox(height: 36),
                  Wrap(
                    spacing: 14, runSpacing: 12, alignment: WrapAlignment.center,
                    children: [
                      _HeroButton(label: 'Commencer à acheter', icon: Icons.arrow_forward_rounded, filled: true,
                          onTap: () => Navigator.pushNamed(context, AppRoutes.products)),
                      _HeroButton(label: 'Devenir vendeur', icon: Icons.storefront_outlined, filled: false,
                          onTap: () => Navigator.pushNamed(context, AppRoutes.contact_us)),
                    ],
                  ),
                ]),
              ),
            ]),
          ),
        ),
      );
    });
  }
}

// ─────────────────────────────────────────────
//  FOOTER BAR
// ─────────────────────────────────────────────
class _FooterBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: _navy,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 40),
      child: Center(
        child: Text(
          '© 2026 DJIBSOUQ · Djibouti, République de Djibouti · Tous droits réservés',
          style: TextStyle(color: Colors.white.withOpacity(0.35), fontSize: 13),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  SHARED SMALL WIDGETS
// ─────────────────────────────────────────────
class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.color});
  final String label;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: color, letterSpacing: 1.2)),
      ]),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, this.light = false});
  final String label;
  final bool light;
  @override
  Widget build(BuildContext context) {
    return Text(label, style: TextStyle(
      fontSize: 11, fontWeight: FontWeight.w700,
      letterSpacing: 2, color: light ? _accent : _blueLight,
    ));
  }
}

class _HeroButton extends StatefulWidget {
  const _HeroButton({required this.label, required this.icon, required this.filled, required this.onTap});
  final String label;
  final IconData icon;
  final bool filled;
  final VoidCallback onTap;
  @override
  State<_HeroButton> createState() => _HeroButtonState();
}

class _HeroButtonState extends State<_HeroButton> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 15),
          decoration: BoxDecoration(
            color: widget.filled
                ? (_hovered ? _blueLight : _accent)
                : Colors.white.withOpacity(_hovered ? 0.12 : 0.06),
            borderRadius: BorderRadius.circular(12),
            border: widget.filled
                ? null
                : Border.all(color: Colors.white.withOpacity(0.25)),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Text(widget.label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
            const SizedBox(width: 8),
            Icon(widget.icon, color: Colors.white, size: 16),
          ]),
        ),
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  const _GlowCircle({required this.size, required this.color});
  final double size;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

// ─────────────────────────────────────────────
//  GRID PAINTER (decorative background)
// ─────────────────────────────────────────────
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..strokeWidth = 1;
    const step = 60.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }
  @override
  bool shouldRepaint(_) => false;
}