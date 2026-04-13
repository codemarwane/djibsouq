import 'package:dj/layouts/web/pages_web/Admin_web/admin_models.dart';
import 'package:dj/layouts/web/pages_web/Admin_web/admin_theme.dart';
import 'package:dj/layouts/web/pages_web/Admin_web/admin_widget.dart';
import 'package:flutter/material.dart';

String _fmt(num value) {
  return value.toStringAsFixed(2);
}

class CommandesPage extends StatefulWidget {
  const CommandesPage({super.key});

  @override
  State<CommandesPage> createState() => _CommandesPageState();
}

class _CommandesPageState extends State<CommandesPage> {
  OrderStatus? _filter;
  String _search = '';
  int _page = 0;
  static const int _perPage = 6;

  List<OrderModel> get _filtered {
    return AdminSampleData.orders.where((o) {
      if (_filter != null && o.status != _filter) return false;
      if (_search.isNotEmpty &&
          !o.client.toLowerCase().contains(_search.toLowerCase()) &&
          !o.id.toLowerCase().contains(_search.toLowerCase()) &&
          !o.product.toLowerCase().contains(_search.toLowerCase())) return false;
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered  = _filtered;
    final pageData  = filtered.skip(_page * _perPage).take(_perPage).toList();
    final pageCount = (filtered.length / _perPage).ceil();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Toolbar
          Row(
            children: [
              Expanded(child: _FilterTabs(current: _filter, onChange: (f) => setState(() { _filter = f; _page = 0; }))),
              const SizedBox(width: 12),
              AdminSearchBar(hint: 'Client, produit...', width: 200, onChanged: (v) => setState(() { _search = v; _page = 0; })),
              const SizedBox(width: 10),
              AdminPrimaryButton(label: '+ Nouvelle commande', onTap: () => _showOrderDialog(context, null), icon: Icons.add),
            ],
          ),
          const SizedBox(height: 16),

          AdminCard(
            padding: const EdgeInsets.all(0),
            child: Column(
              children: [
                _TableHeader(),
                const Divider(height: 1, color: AdminColors.border),
                if (pageData.isEmpty)
                  const AdminEmptyState(message: 'Aucune commande trouvée')
                else
                  ...pageData.map((o) => _CommandeRow(
                    order: o,
                    onEdit:   () => _showOrderDialog(context, o),
                    onDelete: () => _confirmDelete(context, o),
                  )),
                // Pagination
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  child: Row(
                    children: [
                      Text('${filtered.length} résultats', style: AdminText.muted),
                      const Spacer(),
                      _PaginationBar(
                        current: _page,
                        total:   pageCount,
                        onChange: (p) => setState(() => _page = p),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, OrderModel o) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Supprimer la commande', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        content: Text('Supprimer la commande ${o.id} de ${o.client} ?', style: AdminText.body),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AdminColors.red, elevation: 0),
            onPressed: () {
              setState(() => AdminSampleData.orders.remove(o));
              Navigator.pop(context);
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showOrderDialog(BuildContext context, OrderModel? order) {
    // For brevity, shows a read-only detail dialog for existing orders
    if (order == null) return;
    showDialog(
      context: context,
      builder: (_) => _OrderDetailDialog(order: order),
    );
  }
}

class _FilterTabs extends StatelessWidget {
  final OrderStatus? current;
  final ValueChanged<OrderStatus?> onChange;

  const _FilterTabs({required this.current, required this.onChange});

  @override
  Widget build(BuildContext context) {
    final tabs = <String, OrderStatus?>{
      'Toutes': null,
      'En attente': OrderStatus.pending,
      'En cours':   OrderStatus.inProgress,
      'Livrées':    OrderStatus.delivered,
      'Annulées':   OrderStatus.cancelled,
    };
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: tabs.entries.map((e) {
          final isOn = current == e.value;
          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: InkWell(
              onTap: () => onChange(e.value),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isOn ? AdminColors.primary : AdminColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: isOn ? AdminColors.primary : AdminColors.border),
                ),
                child: Text(e.key, style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w500,
                  color: isOn ? Colors.white : AdminColors.text2,
                )),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: const [
          SizedBox(width: 70,  child: Text('ID',       style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AdminColors.text3))),
          Expanded(flex: 2,    child: Text('Client',   style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AdminColors.text3))),
          Expanded(flex: 2,    child: Text('Produit',  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AdminColors.text3))),
          SizedBox(width: 100, child: Text('Montant',  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AdminColors.text3))),
          SizedBox(width: 90,  child: Text('Statut',   style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AdminColors.text3))),
          SizedBox(width: 80,  child: Text('Date',     style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AdminColors.text3))),
          SizedBox(width: 80,  child: Text('Actions',  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AdminColors.text3))),
        ],
      ),
    );
  }
}

class _CommandeRow extends StatefulWidget {
  final OrderModel order;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CommandeRow({required this.order, required this.onEdit, required this.onDelete});

  @override
  State<_CommandeRow> createState() => _CommandeRowState();
}

class _CommandeRowState extends State<_CommandeRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final o = widget.order;
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
                  SizedBox(width: 70,  child: Text(o.id, style: AdminText.mono)),
                  Expanded(flex: 2,    child: Text(o.client, style: AdminText.body, overflow: TextOverflow.ellipsis)),
                  Expanded(flex: 2,    child: Text(o.product, style: AdminText.muted, overflow: TextOverflow.ellipsis)),
                  SizedBox(width: 100, child: Text('${_fmt(o.amount)} FDJ', style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500, color: AdminColors.text1))),
                  SizedBox(width: 90,  child: StatusPill(label: o.status.label, color: o.status.color, bg: o.status.bg)),
                  SizedBox(width: 80,  child: Text(o.date, style: AdminText.tiny)),
                  SizedBox(width: 80,  child: Row(
                    children: [
                      AdminIconBtn(icon: Icons.visibility_outlined, onTap: widget.onEdit),
                      const SizedBox(width: 6),
                      AdminIconBtn(icon: Icons.delete_outline, onTap: widget.onDelete, color: AdminColors.red),
                    ],
                  )),
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

class _PaginationBar extends StatelessWidget {
  final int current;
  final int total;
  final ValueChanged<int> onChange;

  const _PaginationBar({required this.current, required this.total, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _PageBtn('←', current > 0, () => onChange(current - 1)),
        ...List.generate(total.clamp(0, 5), (i) => _PageBtn('${i + 1}', true, () => onChange(i), active: i == current)),
        _PageBtn('→', current < total - 1, () => onChange(current + 1)),
      ],
    );
  }
}

class _PageBtn extends StatelessWidget {
  final String label;
  final bool enabled;
  final VoidCallback onTap;
  final bool active;

  const _PageBtn(this.label, this.enabled, this.onTap, {this.active = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          width: 30, height: 30,
          decoration: BoxDecoration(
            color: active ? AdminColors.primary : AdminColors.surface,
            border: Border.all(color: active ? AdminColors.primary : AdminColors.border),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Center(child: Text(label, style: TextStyle(
            fontSize: 12,
            color: active ? Colors.white : enabled ? AdminColors.text1 : AdminColors.text3,
          ))),
        ),
      ),
    );
  }
}

class _OrderDetailDialog extends StatelessWidget {
  final OrderModel order;
  const _OrderDetailDialog({required this.order});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 420,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Text('Commande ${order.id}', style: AdminText.h2),
              const Spacer(),
              IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
            ]),
            const SizedBox(height: 16),
            _DetailRow('Client', order.client),
            _DetailRow('Produit', order.product),
            _DetailRow('Montant', '${_fmt(order.amount)} FDJ'),
            _DetailRow('Date', order.date),
            const SizedBox(height: 12),
            Row(children: [
              const Text('Statut : ', style: AdminText.muted),
              StatusPill(label: order.status.label, color: order.status.color, bg: order.status.bg),
            ]),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: AdminPrimaryButton(label: 'Fermer', onTap: () => Navigator.pop(context)),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text(label, style: AdminText.muted)),
          Expanded(child: Text(value, style: AdminText.body)),
        ],
      ),
    );
  }
}