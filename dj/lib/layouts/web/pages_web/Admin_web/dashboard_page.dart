import 'package:dj/layouts/web/pages_web/Admin_web/admin_widget.dart';
import 'package:flutter/material.dart';
import 'admin_models.dart';
import 'admin_theme.dart';


class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Metrics
          _MetricsRow(),
          const SizedBox(height: 16),
          // Charts row
          _ChartsRow(),
          const SizedBox(height: 16),
          // Bottom row
          _BottomRow(),
        ],
      ),
    );
  }
}

// ─── METRICS ─────────────────────────────────────────────────────────────────
class _MetricsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 700;
      final metrics = [
        {'label': 'Revenus du mois',    'value': '4 820 000 FDJ', 'sub': '18% vs mois dernier', 'up': true},
        {'label': 'Commandes totales',  'value': '1 247',          'sub': '231 nouvelles',        'up': true},
        {'label': 'Utilisateurs actifs','value': '3 890',          'sub': '12% ce mois',          'up': true},
        {'label': 'Produits en stock',  'value': '842',            'sub': '14 ruptures',          'up': false},
      ];
      return isMobile
          ? Column(
              children: metrics.map((m) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: MetricCard(label: m['label'] as String, value: m['value'] as String, sub: m['sub'] as String, isUp: m['up'] as bool),
              )).toList())
          : Row(
              children: metrics.asMap().entries.map((e) => Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: e.key < metrics.length - 1 ? 12 : 0),
                  child: MetricCard(label: e.value['label'] as String, value: e.value['value'] as String, sub: e.value['sub'] as String, isUp: e.value['up'] as bool),
                ),
              )).toList());
    });
  }
}

// ─── CHARTS ROW ──────────────────────────────────────────────────────────────
class _ChartsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 800;
      final charts = [
        Expanded(flex: 3, child: _RevenueChart()),
        if (!isMobile) const SizedBox(width: 12),
        if (!isMobile) Expanded(flex: 2, child: _StatusDonut()),
      ];
      return isMobile
          ? Column(children: [_RevenueChart(), const SizedBox(height: 12), _StatusDonut()])
          : Row(crossAxisAlignment: CrossAxisAlignment.start, children: charts);
    });
  }
}

class _RevenueChart extends StatelessWidget {
  final data = const [
    _BarData('Nov', 3200, false),
    _BarData('Déc', 3800, false),
    _BarData('Jan', 4100, false),
    _BarData('Fév', 3600, false),
    _BarData('Mar', 4400, false),
    _BarData('Avr', 4820, true),
  ];
  final int maxVal = 5500;

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminCardHeader(
            title: 'Revenus mensuels',
            subtitle: '6 derniers mois — en FDJ',
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.asMap().entries.map((e) {
                final d = e.value;
                final pct = d.value / maxVal;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 400 + e.key * 80),
                          curve: Curves.easeOutCubic,
                          height: 150 * pct,
                          decoration: BoxDecoration(
                            color: d.highlight ? AdminColors.primary : AdminColors.primaryLight,
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(5)),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(d.label, style: AdminText.tiny),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _BarData {
  final String label;
  final int value;
  final bool highlight;
  const _BarData(this.label, this.value, this.highlight);
}

class _StatusDonut extends StatelessWidget {
  const _StatusDonut();

  @override
  Widget build(BuildContext context) {
    final items = [
      _DonutItem('Livrées',    58, AdminColors.green),
      _DonutItem('En cours',   24, AdminColors.blue),
      _DonutItem('En attente', 12, AdminColors.amber),
      _DonutItem('Annulées',    6, AdminColors.red),
    ];
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AdminCardHeader(title: 'Commandes par statut', subtitle: 'Ce mois'),
          const SizedBox(height: 16),
          Center(
            child: SizedBox(
              width: 120, height: 120,
              child: CustomPaint(painter: _DonutPainter(items)),
            ),
          ),
          const SizedBox(height: 16),
          ...items.map((item) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Container(width: 10, height: 10, decoration: BoxDecoration(color: item.color, borderRadius: BorderRadius.circular(2))),
                const SizedBox(width: 8),
                Expanded(child: Text(item.label, style: AdminText.muted)),
                Text('${item.percent}%', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AdminColors.text1)),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

class _DonutItem {
  final String label;
  final int percent;
  final Color color;
  const _DonutItem(this.label, this.percent, this.color);
}

class _DonutPainter extends CustomPainter {
  final List<_DonutItem> items;
  const _DonutPainter(this.items);

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final outerR = cx - 4;
    final innerR = cx * 0.56;
    double startAngle = -1.5707963267948966;

    final paint = Paint()..style = PaintingStyle.fill;

    for (final item in items) {
      final sweep = 2 * 3.14159265358979 * item.percent / 100;
      paint.color = item.color;
      final path = Path()
        ..moveTo(cx + innerR * _cos(startAngle), cy + innerR * _sin(startAngle))
        ..lineTo(cx + outerR * _cos(startAngle), cy + outerR * _sin(startAngle))
        ..arcTo(Rect.fromCircle(center: Offset(cx, cy), radius: outerR), startAngle, sweep, false)
        ..lineTo(cx + innerR * _cos(startAngle + sweep), cy + innerR * _sin(startAngle + sweep))
        ..arcTo(Rect.fromCircle(center: Offset(cx, cy), radius: innerR), startAngle + sweep, -sweep, false)
        ..close();
      canvas.drawPath(path, paint);
      startAngle += sweep + 0.02;
    }
  }

  double _cos(double a) => (a - 0).abs() < 1e-9 ? 1 : (a == 1.5707963267948966 ? 0 : (a == 3.14159265358979 ? -1 : (a < 0 ? (1 - (a / (-1.5707963267948966))) : (a < 1.5707963267948966 ? 1 - a / 1.5707963267948966 : -(a - 1.5707963267948966) / 1.5707963267948966))));
  double _sin(double a) => _cos(a - 1.5707963267948966);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ─── BOTTOM ROW ──────────────────────────────────────────────────────────────
class _BottomRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 800;
      return isMobile
          ? Column(children: [_RecentOrdersCard(), const SizedBox(height: 12), _ActivityCard()])
          : Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(flex: 3, child: _RecentOrdersCard()),
              const SizedBox(width: 12),
              Expanded(flex: 2, child: _ActivityCard()),
            ]);
    });
  }
}

class _RecentOrdersCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final orders = AdminSampleData.orders.take(5).toList();
    return AdminCard(
      padding: const EdgeInsets.all(0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: AdminCardHeader(
              title: 'Dernières commandes',
              action: TextButton(
                onPressed: () {},
                child: const Text('Voir tout →', style: TextStyle(fontSize: 12, color: AdminColors.primary)),
              ),
            ),
          ),
          const Divider(height: 1, color: AdminColors.border),
          // Table header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: const [
                SizedBox(width: 70,  child: Text('ID',      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AdminColors.text3))),
                Expanded(flex: 2,    child: Text('Client',  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AdminColors.text3))),
                Expanded(flex: 2,    child: Text('Produit', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AdminColors.text3))),
                SizedBox(width: 90,  child: Text('Montant', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AdminColors.text3))),
                SizedBox(width: 80,  child: Text('Statut',  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AdminColors.text3))),
                SizedBox(width: 70,  child: Text('Date',    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AdminColors.text3))),
              ],
            ),
          ),
          const Divider(height: 1, color: AdminColors.border),
          ...orders.map((o) => _OrderRow(order: o)),
        ],
      ),
    );
  }
}

class _OrderRow extends StatefulWidget {
  final OrderModel order;
  const _OrderRow({required this.order});

  @override
  State<_OrderRow> createState() => _OrderRowState();
}

class _OrderRowState extends State<_OrderRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        color: _hovered ? AdminColors.bg : Colors.transparent,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  SizedBox(width: 70, child: Text(widget.order.id, style: AdminText.mono)),
                  Expanded(flex: 2, child: Text(widget.order.client, style: AdminText.body, overflow: TextOverflow.ellipsis)),
                  Expanded(flex: 2, child: Text(widget.order.product, style: AdminText.muted, overflow: TextOverflow.ellipsis)),
                  SizedBox(width: 90, child: Text(
                    '${_fmt(widget.order.amount)} FDJ',
                    style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500, color: AdminColors.text1),
                  )),
                  SizedBox(width: 80, child: StatusPill(
                    label: widget.order.status.label,
                    color: widget.order.status.color,
                    bg: widget.order.status.bg,
                  )),
                  SizedBox(width: 70, child: Text(widget.order.date, style: AdminText.tiny)),
                ],
              ),
            ),
            const Divider(height: 1, color: AdminColors.border),
          ],
        ),
      ),
    );
  }
}

String _fmt(int v) {
  final s = v.toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(' ');
    buf.write(s[i]);
  }
  return buf.toString();
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard();

  final _items = const [
    _Activity('Nouvelle inscription — Rahma M.',         '3 min',  AdminColors.green),
    _Activity('Commande #5501 marquée livrée',           '12 min', AdminColors.blue),
    _Activity('Stock iPhone 15 Pro — critique (12 u.)', '28 min', AdminColors.amber),
    _Activity('Promo "Flash Deal" activée',              '1h',     AdminColors.purple),
    _Activity('Commande #5497 annulée — remboursement', '2h',     AdminColors.red),
    _Activity('127 nouveaux abonnés newsletter',         '09:15',  AdminColors.text3),
  ];

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AdminCardHeader(title: 'Activité récente'),
          const SizedBox(height: 16),
          ..._items.map((item) => _ActivityRow(item: item)),
        ],
      ),
    );
  }
}

class _Activity {
  final String text;
  final String time;
  final Color color;
  const _Activity(this.text, this.time, this.color);
}

class _ActivityRow extends StatelessWidget {
  final _Activity item;
  const _ActivityRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8, height: 8,
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(color: item.color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.text, style: AdminText.body),
                Text('Il y a ${item.time}', style: AdminText.tiny),
              ],
            ),
          ),
        ],
      ),
    );
  }
}