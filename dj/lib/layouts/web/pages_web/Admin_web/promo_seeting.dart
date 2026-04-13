import 'package:dj/layouts/web/pages_web/Admin_web/admin_models.dart';
import 'package:dj/layouts/web/pages_web/Admin_web/admin_theme.dart';
import 'package:dj/layouts/web/pages_web/Admin_web/admin_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


// ═══════════════════════════════════════════════════════════════════════════════
//  PROMOTIONS PAGE
// ═══════════════════════════════════════════════════════════════════════════════
class PromosPage extends StatefulWidget {
  const PromosPage({super.key});

  @override
  State<PromosPage> createState() => _PromosPageState();
}

class _PromosPageState extends State<PromosPage> {
  PromoStatus? _filter;

  List<PromoModel> get _filtered {
    if (_filter == null) return AdminSampleData.promos;
    return AdminSampleData.promos.where((p) => p.status == _filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
              _Tab('Toutes', null, _filter, (v) => setState(() => _filter = v)),
              const SizedBox(width: 8),
              _Tab('Actives', PromoStatus.active, _filter, (v) => setState(() => _filter = v)),
              const SizedBox(width: 8),
              _Tab('Expirées', PromoStatus.expired, _filter, (v) => setState(() => _filter = v)),
              const Spacer(),
              AdminPrimaryButton(label: '+ Créer une promo', onTap: () => _openForm(context, null), icon: Icons.add),
            ],
          ),
          const SizedBox(height: 16),
          AdminCard(
            padding: const EdgeInsets.all(0),
            child: Column(
              children: [
                _TableHeader(),
                const Divider(height: 1, color: AdminColors.border),
                if (_filtered.isEmpty)
                  const AdminEmptyState(message: 'Aucune promotion')
                else
                  ..._filtered.map((p) => _PromoRow(
                    promo: p,
                    onEdit:   () => _openForm(context, p),
                    onDelete: () => _confirmDelete(context, p),
                    onToggle: () => setState(() {
                      p.status = p.status == PromoStatus.active ? PromoStatus.expired : PromoStatus.active;
                    }),
                  )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openForm(BuildContext context, PromoModel? promo) {
    showDialog(
      context: context,
      builder: (_) => _PromoFormDialog(
        promo: promo,
        onSave: (saved) => setState(() {
          if (promo == null) AdminSampleData.promos.add(saved);
        }),
      ),
    );
  }

  void _confirmDelete(BuildContext context, PromoModel promo) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Supprimer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        content: Text('Supprimer le code "${promo.code}" ?', style: AdminText.body),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AdminColors.red, elevation: 0),
            onPressed: () {
              setState(() => AdminSampleData.promos.removeWhere((p) => p.id == promo.id));
              Navigator.pop(context);
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final PromoStatus? value;
  final PromoStatus? current;
  final ValueChanged<PromoStatus?> onChange;

  const _Tab(this.label, this.value, this.current, this.onChange);

  @override
  Widget build(BuildContext context) {
    final on = current == value;
    return InkWell(
      onTap: () => onChange(value),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: on ? AdminColors.primary : AdminColors.surface,
          border: Border.all(color: on ? AdminColors.primary : AdminColors.border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: on ? Colors.white : AdminColors.text2)),
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(children: const [
        SizedBox(width: 90,  child: Text('Code',         style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AdminColors.text3))),
        Expanded(flex: 3,    child: Text('Description',  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AdminColors.text3))),
        SizedBox(width: 80,  child: Text('Réduction',    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AdminColors.text3))),
        Expanded(flex: 2,    child: Text('Catégorie',    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AdminColors.text3))),
        SizedBox(width: 100, child: Text('Utilisations', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AdminColors.text3))),
        SizedBox(width: 90,  child: Text('Expire',       style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AdminColors.text3))),
        SizedBox(width: 80,  child: Text('Statut',       style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AdminColors.text3))),
        SizedBox(width: 90,  child: Text('Actions',      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AdminColors.text3))),
      ]),
    );
  }
}

class _PromoRow extends StatefulWidget {
  final PromoModel promo;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggle;

  const _PromoRow({required this.promo, required this.onEdit, required this.onDelete, required this.onToggle});

  @override
  State<_PromoRow> createState() => _PromoRowState();
}

class _PromoRowState extends State<_PromoRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.promo;
    final isActive = p.status == PromoStatus.active;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        color: _hovered ? AdminColors.bg : Colors.transparent,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(children: [
              SizedBox(width: 90, child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                decoration: BoxDecoration(color: AdminColors.bg, borderRadius: BorderRadius.circular(4), border: Border.all(color: AdminColors.border)),
                child: Text(p.code, style: AdminText.mono),
              )),
              Expanded(flex: 3, child: Text(p.description, style: AdminText.body, overflow: TextOverflow.ellipsis)),
              SizedBox(width: 80, child: Text('-${p.discount}%', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AdminColors.green))),
              Expanded(flex: 2, child: Text(p.category, style: AdminText.muted)),
              SizedBox(width: 100, child: Text(
                p.maxUsages != null ? '${p.usages} / ${p.maxUsages}' : '${p.usages} / ∞',
                style: AdminText.muted,
              )),
              SizedBox(width: 90, child: Text(p.expiry ?? '—', style: AdminText.tiny)),
              SizedBox(width: 80, child: StatusPill(
                label: isActive ? 'Active' : 'Expirée',
                color: isActive ? AdminColors.green : AdminColors.text3,
                bg: isActive ? AdminColors.greenLight : AdminColors.bg,
              )),
              SizedBox(width: 90, child: Row(children: [
                AdminIconBtn(icon: Icons.edit_outlined, onTap: widget.onEdit),
                const SizedBox(width: 4),
                AdminIconBtn(
                  icon: isActive ? Icons.pause_outlined : Icons.play_arrow_outlined,
                  onTap: widget.onToggle,
                  color: isActive ? AdminColors.amber : AdminColors.green,
                ),
                const SizedBox(width: 4),
                AdminIconBtn(icon: Icons.delete_outline, onTap: widget.onDelete, color: AdminColors.red),
              ])),
            ]),
          ),
          const Divider(height: 1, color: AdminColors.border),
        ]),
      ),
    );
  }
}

// ─── PROMO FORM DIALOG ───────────────────────────────────────────────────────
class _PromoFormDialog extends StatefulWidget {
  final PromoModel? promo;
  final void Function(PromoModel) onSave;

  const _PromoFormDialog({this.promo, required this.onSave});

  @override
  State<_PromoFormDialog> createState() => _PromoFormDialogState();
}

class _PromoFormDialogState extends State<_PromoFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codeCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _discountCtrl;
  late final TextEditingController _maxCtrl;
  late final TextEditingController _expiryCtrl;
  String _category = 'Toutes';

  static const _cats = ['Toutes', 'Électronique', 'Mode', 'Maison', 'Sports'];

  @override
  void initState() {
    super.initState();
    final p = widget.promo;
    _codeCtrl     = TextEditingController(text: p?.code        ?? '');
    _descCtrl     = TextEditingController(text: p?.description ?? '');
    _discountCtrl = TextEditingController(text: p != null ? p.discount.toString() : '');
    _maxCtrl      = TextEditingController(text: p?.maxUsages?.toString() ?? '');
    _expiryCtrl   = TextEditingController(text: p?.expiry ?? '');
    _category     = p?.category ?? 'Toutes';
  }

  @override
  void dispose() {
    _codeCtrl.dispose(); _descCtrl.dispose();
    _discountCtrl.dispose(); _maxCtrl.dispose(); _expiryCtrl.dispose();
    super.dispose();
  }

  InputDecoration _deco(String? hint) => InputDecoration(
    hintText: hint, hintStyle: AdminText.muted, filled: true, fillColor: AdminColors.bg,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AdminColors.border)),
    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AdminColors.border)),
    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AdminColors.primary, width: 1.5)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  );

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final p = widget.promo;
    if (p != null) {
      p.code        = _codeCtrl.text.trim().toUpperCase();
      p.description = _descCtrl.text.trim();
      p.discount    = int.tryParse(_discountCtrl.text) ?? 0;
      p.maxUsages   = _maxCtrl.text.isEmpty ? null : int.tryParse(_maxCtrl.text);
      p.expiry      = _expiryCtrl.text.trim().isEmpty ? null : _expiryCtrl.text.trim();
      p.category    = _category;
      widget.onSave(p);
    } else {
      widget.onSave(PromoModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        code: _codeCtrl.text.trim().toUpperCase(),
        description: _descCtrl.text.trim(),
        discount: int.tryParse(_discountCtrl.text) ?? 0,
        category: _category,
        usages: 0,
        maxUsages: _maxCtrl.text.isEmpty ? null : int.tryParse(_maxCtrl.text),
        expiry: _expiryCtrl.text.trim().isEmpty ? null : _expiryCtrl.text.trim(),
        status: PromoStatus.active,
      ));
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 440,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                Text(widget.promo == null ? 'Créer une promotion' : 'Modifier la promo', style: AdminText.h2),
                const Spacer(),
                IconButton(icon: const Icon(Icons.close, size: 20), onPressed: () => Navigator.pop(context)),
              ]),
              const Divider(color: AdminColors.border),
              const SizedBox(height: 12),
              _F('Code promo *', TextFormField(controller: _codeCtrl, style: AdminText.body, decoration: _deco('FLASH20'), textCapitalization: TextCapitalization.characters, validator: (v) => v!.isEmpty ? 'Requis' : null)),
              const SizedBox(height: 10),
              _F('Description', TextFormField(controller: _descCtrl, style: AdminText.body, decoration: _deco('Flash Deal Électronique'))),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: _F('Réduction % *', TextFormField(controller: _discountCtrl, style: AdminText.body, decoration: _deco('20'), keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly], validator: (v) => v!.isEmpty ? 'Requis' : null))),
                const SizedBox(width: 10),
                Expanded(child: _F('Catégorie', DropdownButtonFormField<String>(
                  value: _category, style: AdminText.body, decoration: _deco(null),
                  items: _cats.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (v) => setState(() => _category = v!),
                ))),
              ]),
              const SizedBox(height: 10),
              Row(children: [
                Expanded(child: _F('Max utilisations', TextFormField(controller: _maxCtrl, style: AdminText.body, decoration: _deco('illimité'), keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly]))),
                const SizedBox(width: 10),
                Expanded(child: _F('Date expiration', TextFormField(controller: _expiryCtrl, style: AdminText.body, decoration: _deco('30 Avr 2026')))),
              ]),
              const SizedBox(height: 20),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                AdminOutlineButton(label: 'Annuler', onTap: () => Navigator.pop(context)),
                const SizedBox(width: 10),
                AdminPrimaryButton(label: widget.promo == null ? 'Créer' : 'Enregistrer', onTap: _submit),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}

class _F extends StatelessWidget {
  final String label;
  final Widget child;
  const _F(this.label, this.child);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: AdminText.muted),
      const SizedBox(height: 5),
      child,
    ]);
  }
}


// ═══════════════════════════════════════════════════════════════════════════════
//  SETTINGS PAGE
// ═══════════════════════════════════════════════════════════════════════════════
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notifOrders   = true;
  bool _notifStock    = true;
  bool _notifReport   = false;
  bool _notifSms      = false;

  final _nameCtrl    = TextEditingController(text: 'DJIBSOUQ');
  final _emailCtrl   = TextEditingController(text: 'hello@djibsouq.dj');
  final _phoneCtrl   = TextEditingController(text: '+253 77 00 00 00');
  final _stockAlertCtrl = TextEditingController(text: '15');

  @override
  void dispose() {
    _nameCtrl.dispose(); _emailCtrl.dispose();
    _phoneCtrl.dispose(); _stockAlertCtrl.dispose();
    super.dispose();
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: LayoutBuilder(builder: (ctx, c) {
        final isMobile = c.maxWidth < 700;
        final cards = [_generalCard(), _notifCard()];
        return isMobile
            ? Column(children: cards.map((w) => Padding(padding: const EdgeInsets.only(bottom: 16), child: w)).toList())
            : Row(crossAxisAlignment: CrossAxisAlignment.start, children: cards.asMap().entries.map((e) =>
                Expanded(child: Padding(padding: EdgeInsets.only(left: e.key == 0 ? 0 : 12), child: e.value))).toList());
      }),
    );
  }

  Widget _generalCard() {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AdminCardHeader(title: 'Informations générales'),
          const SizedBox(height: 16),
          _SF('Nom du site', TextField(controller: _nameCtrl, style: AdminText.body, decoration: _deco(null))),
          const SizedBox(height: 12),
          _SF('Email de contact', TextField(controller: _emailCtrl, style: AdminText.body, decoration: _deco(null))),
          const SizedBox(height: 12),
          _SF('Téléphone', TextField(controller: _phoneCtrl, style: AdminText.body, decoration: _deco(null))),
          const SizedBox(height: 12),
          _SF('Seuil alerte stock', Row(children: [
            Expanded(child: TextField(controller: _stockAlertCtrl, style: AdminText.body, keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly], decoration: _deco(null))),
            const SizedBox(width: 8),
            const Text('unités', style: AdminText.muted),
          ])),
          const SizedBox(height: 12),
          _SF('Devise', Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(color: AdminColors.bg, border: Border.all(color: AdminColors.border), borderRadius: BorderRadius.circular(8)),
            child: const Row(children: [
              Text('FDJ — Franc Djiboutien', style: AdminText.body),
              Spacer(),
              Icon(Icons.keyboard_arrow_down, size: 18, color: AdminColors.text3),
            ]),
          )),
          const SizedBox(height: 20),
          AdminPrimaryButton(
            label: 'Enregistrer',
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Paramètres enregistrés'),
                backgroundColor: AdminColors.green,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            icon: Icons.save_outlined,
          ),
        ],
      ),
    );
  }

  Widget _notifCard() {
    return AdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AdminCardHeader(title: 'Notifications & alertes'),
          const SizedBox(height: 16),
          _NotifToggle(
            label: 'Email — nouvelles commandes',
            sub: 'Recevoir un email à chaque commande',
            value: _notifOrders,
            onChange: (v) => setState(() => _notifOrders = v),
          ),
          const Divider(color: AdminColors.border, height: 1),
          _NotifToggle(
            label: 'Alerte stock bas',
            sub: 'Notification quand stock < seuil défini',
            value: _notifStock,
            onChange: (v) => setState(() => _notifStock = v),
          ),
          const Divider(color: AdminColors.border, height: 1),
          _NotifToggle(
            label: 'Rapport quotidien',
            sub: 'Résumé des ventes chaque matin',
            value: _notifReport,
            onChange: (v) => setState(() => _notifReport = v),
          ),
          const Divider(color: AdminColors.border, height: 1),
          _NotifToggle(
            label: 'SMS — avis clients',
            sub: 'SMS à chaque nouvel avis',
            value: _notifSms,
            onChange: (v) => setState(() => _notifSms = v),
          ),
        ],
      ),
    );
  }
}

class _SF extends StatelessWidget {
  final String label;
  final Widget child;
  const _SF(this.label, this.child);

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: AdminText.muted),
      const SizedBox(height: 5),
      child,
    ]);
  }
}

class _NotifToggle extends StatelessWidget {
  final String label;
  final String sub;
  final bool value;
  final ValueChanged<bool> onChange;

  const _NotifToggle({required this.label, required this.sub, required this.value, required this.onChange});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: AdminText.body),
            Text(sub, style: AdminText.tiny),
          ])),
          Switch(
            value: value,
            onChanged: onChange,
            activeColor: AdminColors.primary,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}