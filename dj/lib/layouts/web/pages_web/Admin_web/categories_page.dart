import 'package:dj/layouts/web/pages_web/Admin_web/admin_models.dart';
import 'package:dj/layouts/web/pages_web/Admin_web/admin_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'admin_theme.dart';



class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('${AdminSampleData.categories.length} catégories', style: AdminText.muted),
              const Spacer(),
              AdminPrimaryButton(label: '+ Ajouter catégorie', onTap: () => _openForm(context, null), icon: Icons.add),
            ],
          ),
          const SizedBox(height: 16),
          LayoutBuilder(builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 600;
            final crossAxis = isMobile ? 1 : (constraints.maxWidth < 900 ? 2 : 3);
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxis,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 2.0,
              ),
              itemCount: AdminSampleData.categories.length + 1,
              itemBuilder: (context, i) {
                if (i == AdminSampleData.categories.length) {
                  return _AddCategoryCard(onTap: () => _openForm(context, null));
                }
                return _CategoryCard(
                  category: AdminSampleData.categories[i],
                  onEdit:   () => _openForm(context, AdminSampleData.categories[i]),
                  onDelete: () => _confirmDelete(context, AdminSampleData.categories[i]),
                );
              },
            );
          }),
          const SizedBox(height: 24),
          // Sales bar chart
          AdminCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AdminCardHeader(title: 'Ventes par catégorie', subtitle: 'Pourcentage du total'),
                const SizedBox(height: 16),
                ...AdminSampleData.categories.map((c) => _CatBarRow(cat: c)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openForm(BuildContext context, CategoryModel? category) {
    showDialog(
      context: context,
      builder: (_) => _CategoryFormDialog(
        category: category,
        onSave: (saved) {
          setState(() {
            if (category == null) {
              AdminSampleData.categories.add(saved);
            }
            // Editing mutates in place
          });
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, CategoryModel cat) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Supprimer la catégorie', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        content: Text('Supprimer "${cat.name}" ?', style: AdminText.body),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AdminColors.red, elevation: 0),
            onPressed: () {
              setState(() => AdminSampleData.categories.removeWhere((c) => c.name == cat.name));
              Navigator.pop(context);
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatefulWidget {
  final CategoryModel category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CategoryCard({required this.category, required this.onEdit, required this.onDelete});

  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<_CategoryCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.category;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AdminColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _hovered ? c.color.withOpacity(.5) : AdminColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: c.color.withOpacity(.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: Text(c.emoji, style: const TextStyle(fontSize: 22))),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(c.name, style: AdminText.h3),
                  Text('${c.products} produits · ${c.salesPercent}% des ventes', style: AdminText.tiny),
                ],
              ),
            ),
            Column(
              children: [
                AdminIconBtn(icon: Icons.edit_outlined, onTap: widget.onEdit),
                const SizedBox(height: 4),
                AdminIconBtn(icon: Icons.delete_outline, onTap: widget.onDelete, color: AdminColors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AddCategoryCard extends StatefulWidget {
  final VoidCallback onTap;
  const _AddCategoryCard({required this.onTap});

  @override
  State<_AddCategoryCard> createState() => _AddCategoryCardState();
}

class _AddCategoryCardState extends State<_AddCategoryCard> {
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
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: _hovered ? AdminColors.primaryLight : AdminColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _hovered ? AdminColors.primary : AdminColors.border,
              style: _hovered ? BorderStyle.solid : BorderStyle.solid,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_circle_outline, size: 28, color: _hovered ? AdminColors.primary : AdminColors.text3),
              const SizedBox(height: 8),
              Text('Nouvelle catégorie', style: TextStyle(fontSize: 13, color: _hovered ? AdminColors.primary : AdminColors.text3)),
            ],
          ),
        ),
      ),
    );
  }
}

class _CatBarRow extends StatelessWidget {
  final CategoryModel cat;
  const _CatBarRow({required this.cat});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(cat.emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 10),
          SizedBox(width: 100, child: Text(cat.name, style: AdminText.body)),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: Stack(
                children: [
                  Container(height: 8, color: AdminColors.bg),
                  FractionallySizedBox(
                    widthFactor: cat.salesPercent / 100,
                    child: Container(height: 8, color: cat.color),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(width: 35, child: Text('${cat.salesPercent}%', style: AdminText.muted, textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}

// ─── CATEGORY FORM DIALOG ────────────────────────────────────────────────────
class _CategoryFormDialog extends StatefulWidget {
  final CategoryModel? category;
  final void Function(CategoryModel) onSave;

  const _CategoryFormDialog({this.category, required this.onSave});

  @override
  State<_CategoryFormDialog> createState() => _CategoryFormDialogState();
}

class _CategoryFormDialogState extends State<_CategoryFormDialog> {
  final _formKey   = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emojiCtrl;
  late final TextEditingController _productsCtrl;
  late final TextEditingController _salesCtrl;
  Color _color = AdminColors.blue;

  static const _palette = [
    AdminColors.blue, AdminColors.green, AdminColors.amber,
    AdminColors.purple, AdminColors.red, AdminColors.primary,
  ];

  @override
  void initState() {
    super.initState();
    final c = widget.category;
    _nameCtrl     = TextEditingController(text: c?.name     ?? '');
    _emojiCtrl    = TextEditingController(text: c?.emoji    ?? '');
    _productsCtrl = TextEditingController(text: c != null ? c.products.toString() : '');
    _salesCtrl    = TextEditingController(text: c != null ? c.salesPercent.toString() : '');
    _color        = c?.color ?? AdminColors.blue;
  }

  @override
  void dispose() {
    _nameCtrl.dispose(); _emojiCtrl.dispose();
    _productsCtrl.dispose(); _salesCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final c = widget.category;
    if (c != null) {
      c.name         = _nameCtrl.text.trim();
      c.emoji        = _emojiCtrl.text.trim();
      c.products     = int.tryParse(_productsCtrl.text) ?? 0;
      c.salesPercent = int.tryParse(_salesCtrl.text) ?? 0;
      c.color        = _color;
      widget.onSave(c);
    } else {
      widget.onSave(CategoryModel(
        name: _nameCtrl.text.trim(), emoji: _emojiCtrl.text.trim(),
        products: int.tryParse(_productsCtrl.text) ?? 0,
        salesPercent: int.tryParse(_salesCtrl.text) ?? 0,
        color: _color,
      ));
    }
    Navigator.pop(context);
  }

  InputDecoration _deco(String? hint) => InputDecoration(
    hintText: hint, hintStyle: AdminText.muted, filled: true, fillColor: AdminColors.bg,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AdminColors.border)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AdminColors.border)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AdminColors.primary, width: 1.5)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  );

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text(widget.category == null ? 'Ajouter catégorie' : 'Modifier catégorie', style: AdminText.h2),
                const Spacer(),
                IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () => Navigator.pop(context)),
              ]),
              const Divider(color: AdminColors.border),
              const SizedBox(height: 12),
              _Lbl('Nom *', TextFormField(controller: _nameCtrl, style: AdminText.body, decoration: _deco('ex: Électronique'), validator: (v) => v!.isEmpty ? 'Requis' : null)),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: _Lbl('Emoji', TextFormField(controller: _emojiCtrl, style: AdminText.body, decoration: _deco('📱')))),
                const SizedBox(width: 10),
                Expanded(child: _Lbl('Nb produits', TextFormField(controller: _productsCtrl, style: AdminText.body, decoration: _deco('0'), keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly]))),
              ]),
              const SizedBox(height: 10),
              _Lbl('% Ventes', TextFormField(controller: _salesCtrl, style: AdminText.body, decoration: _deco('0-100'), keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly])),
              const SizedBox(height: 12),
              const Text('Couleur', style: AdminText.muted),
              const SizedBox(height: 6),
              Row(
                children: _palette.map((c) => GestureDetector(
                  onTap: () => setState(() => _color = c),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    width: 28, height: 28,
                    decoration: BoxDecoration(
                      color: c, shape: BoxShape.circle,
                      border: Border.all(color: _color == c ? AdminColors.text1 : Colors.transparent, width: 2),
                    ),
                  ),
                )).toList(),
              ),
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                AdminOutlineButton(label: 'Annuler', onTap: () => Navigator.pop(context)),
                const SizedBox(width: 10),
                AdminPrimaryButton(label: widget.category == null ? 'Ajouter' : 'Enregistrer', onTap: _submit),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

class _Lbl extends StatelessWidget {
  final String label;
  final Widget child;
  const _Lbl(this.label, this.child);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: AdminText.muted),
      const SizedBox(height: 5),
      child,
    ]);
  }
}