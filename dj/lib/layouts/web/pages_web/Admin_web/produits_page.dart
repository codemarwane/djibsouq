import 'package:dj/layouts/web/pages_web/Admin_web/admin_models.dart';
import 'package:dj/layouts/web/pages_web/Admin_web/admin_theme.dart';
import 'package:dj/layouts/web/pages_web/Admin_web/admin_widget.dart';
import 'package:dj/models/product_models.dart';
import 'package:flutter/material.dart';


class ProduitsPage extends StatefulWidget {
  const ProduitsPage({super.key});

  @override
  State<ProduitsPage> createState() => _ProduitsPageState();
}

class _ProduitsPageState extends State<ProduitsPage> {
  String _search = '';
  String? _categoryFilter;

  static const _categories = ['Électronique', 'Mode', 'Maison', 'Sports'];

  List<ProductModel> get _filtered {
    return AdminSampleData.products.where((p) {
      if (_categoryFilter != null && p.category != _categoryFilter) return false;
      if (_search.isNotEmpty &&
          !p.name.toLowerCase().contains(_search.toLowerCase()) &&
          !p.sku.toLowerCase().contains(_search.toLowerCase())) return false;
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Toolbar
          Row(
            children: [
              AdminSearchBar(hint: 'Nom, SKU...', width: 220, onChanged: (v) => setState(() => _search = v)),
              const SizedBox(width: 10),
              // Category filter chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _CatChip(label: 'Tous', selected: _categoryFilter == null, onTap: () => setState(() => _categoryFilter = null)),
                    ..._categories.map((c) => _CatChip(label: c, selected: _categoryFilter == c, onTap: () => setState(() => _categoryFilter = c))),
                  ],
                ),
              ),
              const Spacer(),
              AdminOutlineButton(label: 'Exporter CSV', onTap: () {}, icon: Icons.download_outlined),
              const SizedBox(width: 10),
              AdminPrimaryButton(label: '+ Ajouter', onTap: () => _openForm(context, null), icon: Icons.add),
            ],
          ),
          const SizedBox(height: 16),

          // Stats
          Row(children: [
            _MiniStat('Total produits', '${AdminSampleData.products.length}', AdminColors.primaryLight, AdminColors.primary),
            const SizedBox(width: 10),
            _MiniStat('Actifs', '${AdminSampleData.products.where((p) => p.status == ProductStatus.active).length}', AdminColors.greenLight, AdminColors.green),
            const SizedBox(width: 10),
            _MiniStat('Bas stock', '${AdminSampleData.products.where((p) => p.status == ProductStatus.lowStock).length}', AdminColors.amberLight, AdminColors.amber),
            const SizedBox(width: 10),
            _MiniStat('Ruptures', '${AdminSampleData.products.where((p) => p.status == ProductStatus.outOfStock).length}', AdminColors.redLight, AdminColors.red),
          ]),
          const SizedBox(height: 16),

          AdminCard(
            padding: const EdgeInsets.all(0),
            child: Column(
              children: [
                _TableHeader(),
                const Divider(height: 1, color: AdminColors.border),
                if (filtered.isEmpty)
                  const AdminEmptyState(message: 'Aucun produit trouvé')
                else
                  ...filtered.map((p) => _ProductRow(
                    product: p,
                    onEdit:   () => _openForm(context, p),
                    onDelete: () => _confirmDelete(context, p),
                  )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openForm(BuildContext context, ProductModel? product) {
    showDialog(
      context: context,
      builder: (_) => ProductFormDialog(
        product: product,
        onSave: (saved) {
          setState(() {
            if (product == null) {
              AdminSampleData.products.add(saved as ProductModel);
            }
            // If editing, the model was mutated in-place
          });
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, ProductModel product) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Supprimer le produit', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        content: Text('Supprimer "${product.name}" définitivement ?', style: AdminText.body),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AdminColors.red, elevation: 0),
            onPressed: () {
              setState(() => AdminSampleData.products.removeWhere((p) => p.id == product.id));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Produit "${product.name}" supprimé'),
                  backgroundColor: AdminColors.text1,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              );
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color bg;
  final Color textColor;

  const _MiniStat(this.label, this.value, this.bg, this.textColor);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: textColor)),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(fontSize: 12, color: textColor.withOpacity(.75))),
          ],
        ),
      ),
    );
  }
}

class _CatChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _CatChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(99),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: selected ? AdminColors.primary : AdminColors.surface,
            border: Border.all(color: selected ? AdminColors.primary : AdminColors.border),
            borderRadius: BorderRadius.circular(99),
          ),
          child: Text(label, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500, color: selected ? Colors.white : AdminColors.text2)),
        ),
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
          SizedBox(width: 80,  child: Text('SKU',        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AdminColors.text3))),
          Expanded(flex: 3,    child: Text('Produit',    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AdminColors.text3))),
          Expanded(flex: 2,    child: Text('Catégorie',  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AdminColors.text3))),
          SizedBox(width: 100, child: Text('Prix',       style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AdminColors.text3))),
          SizedBox(width: 60,  child: Text('Stock',      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AdminColors.text3))),
          SizedBox(width: 60,  child: Text('Ventes',     style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AdminColors.text3))),
          SizedBox(width: 90,  child: Text('Statut',     style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AdminColors.text3))),
          SizedBox(width: 80,  child: Text('Actions',    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AdminColors.text3))),
        ],
      ),
    );
  }
}

class _ProductRow extends StatefulWidget {
  final ProductModel product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ProductRow({required this.product, required this.onEdit, required this.onDelete});

  @override
  State<_ProductRow> createState() => _ProductRowState();
}

class _ProductRowState extends State<_ProductRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        color: _hovered ? AdminColors.bg : Colors.transparent,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
              child: Row(
                children: [
                  SizedBox(width: 80,  child: Text(p.sku,      style: AdminText.mono)),
                  Expanded(flex: 3,    child: Text(p.name,     style: AdminText.body, overflow: TextOverflow.ellipsis)),
                  Expanded(flex: 2,    child: _CategoryBadge(p.category)),
                  SizedBox(width: 100, child: Text(_fmtPrice(p.price), style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500, color: AdminColors.text1))),
                  SizedBox(width: 60,  child: Text('${p.stock}', style: TextStyle(fontSize: 13, color: p.stock == 0 ? AdminColors.red : AdminColors.text1))),
                  SizedBox(width: 60,  child: Text('${p.sales}', style: AdminText.muted)),
                  SizedBox(width: 90,  child: StatusPill(label: p.status.label, color: p.status.color, bg: p.status.bg)),
                  SizedBox(width: 80,  child: Row(
                    children: [
                      AdminIconBtn(icon: Icons.edit_outlined, onTap: widget.onEdit),
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

class _CategoryBadge extends StatelessWidget {
  final String category;
  const _CategoryBadge(this.category);

  @override
  Widget build(BuildContext context) {
    final map = {
      'Électronique': (AdminColors.blueLight,   AdminColors.blue),
      'Mode':          (AdminColors.purpleLight, AdminColors.purple),
      'Maison':        (AdminColors.amberLight,  AdminColors.amber),
      'Sports':        (AdminColors.greenLight,  AdminColors.green),
    };
    final colors = map[category] ?? (AdminColors.bg, AdminColors.text3);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: colors.$1, borderRadius: BorderRadius.circular(99)),
      child: Text(category, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: colors.$2)),
    );
  }
}

String _fmtPrice(int v) {
  final s = v.toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(' ');
    buf.write(s[i]);
  }
  return '${buf.toString()} FDJ';
}