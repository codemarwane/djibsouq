import 'package:dj/layouts/web/pages_web/Admin_web/admin_models.dart';
import 'package:dj/layouts/web/pages_web/Admin_web/admin_theme.dart';
import 'package:dj/layouts/web/pages_web/Admin_web/admin_widget.dart';
import 'package:flutter/material.dart';


class UtilisateursPage extends StatefulWidget {
  const UtilisateursPage({super.key});

  @override
  State<UtilisateursPage> createState() => _UtilisateursPageState();
}

class _UtilisateursPageState extends State<UtilisateursPage> {
  String _search = '';
  UserRole? _roleFilter;

  List<UserModel> get _filtered {
    return AdminSampleData.users.where((u) {
      if (_roleFilter != null && u.role != _roleFilter) return false;
      if (_search.isNotEmpty &&
          !u.name.toLowerCase().contains(_search.toLowerCase()) &&
          !u.email.toLowerCase().contains(_search.toLowerCase())) return false;
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
              AdminSearchBar(hint: 'Nom, email...', width: 220, onChanged: (v) => setState(() => _search = v)),
              const SizedBox(width: 10),
              _RoleFilter(current: _roleFilter, onChange: (r) => setState(() => _roleFilter = r)),
              const Spacer(),
              AdminPrimaryButton(label: '+ Nouvel utilisateur', onTap: () {}, icon: Icons.person_add_outlined),
            ],
          ),
          const SizedBox(height: 16),

          AdminCard(
            padding: const EdgeInsets.all(0),
            child: Column(
              children: [
                _TableHeader(),
                const Divider(height: 1, color: AdminColors.border),
                if (filtered.isEmpty)
                  const AdminEmptyState(message: 'Aucun utilisateur trouvé')
                else
                  ...filtered.map((u) => _UserRow(
                    user: u,
                    onToggleBan: () => _toggleBan(u),
                  )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _toggleBan(UserModel user) {
    if (user.role == UserRole.superAdmin) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Impossible de bannir un super admin.'),
          backgroundColor: AdminColors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    setState(() => user.isBanned = !user.isBanned);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(user.isBanned ? '${user.name} a été banni.' : '${user.name} a été débanni.'),
        backgroundColor: AdminColors.text1,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
          Expanded(flex: 3, child: Text('Utilisateur',    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AdminColors.text3))),
          Expanded(flex: 3, child: Text('Email',          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AdminColors.text3))),
          SizedBox(width: 70,  child: Text('Cmdes',       style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AdminColors.text3))),
          SizedBox(width: 120, child: Text('Total dépensé', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AdminColors.text3))),
          SizedBox(width: 90,  child: Text('Rôle',        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AdminColors.text3))),
          SizedBox(width: 80,  child: Text('Inscrit',     style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AdminColors.text3))),
          SizedBox(width: 80,  child: Text('Actions',     style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AdminColors.text3))),
        ],
      ),
    );
  }
}

class _RoleFilter extends StatelessWidget {
  final UserRole? current;
  final ValueChanged<UserRole?> onChange;

  const _RoleFilter({required this.current, required this.onChange});

  @override
  Widget build(BuildContext context) {
    final tabs = <String, UserRole?>{
      'Tous':    null,
      'Clients': UserRole.client,
      'Vendeurs': UserRole.vendor,
      'Admins':  UserRole.admin,
    };
    return Row(
      children: tabs.entries.map((e) {
        final isOn = current == e.value;
        return Padding(
          padding: const EdgeInsets.only(right: 6),
          child: InkWell(
            onTap: () => onChange(e.value),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: isOn ? AdminColors.primary : AdminColors.surface,
                border: Border.all(color: isOn ? AdminColors.primary : AdminColors.border),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(e.key, style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w500, color: isOn ? Colors.white : AdminColors.text2)),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _UserRow extends StatefulWidget {
  final UserModel user;
  final VoidCallback onToggleBan;

  const _UserRow({required this.user, required this.onToggleBan});

  @override
  State<_UserRow> createState() => _UserRowState();
}

class _UserRowState extends State<_UserRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final u = widget.user;
    final initials = u.initials;
    final bgColor = u.role.bg;
    final textColor = u.role.color;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 120),
        color: u.isBanned ? AdminColors.redLight.withOpacity(.4) : (_hovered ? AdminColors.bg : Colors.transparent),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Expanded(flex: 3, child: Row(
                    children: [
                      UserAvatar(initials: initials, bg: bgColor, textColor: textColor, size: 32),
                      const SizedBox(width: 10),
                      Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(u.name, style: AdminText.body, overflow: TextOverflow.ellipsis),
                          if (u.isBanned)
                            const Text('Banni', style: TextStyle(fontSize: 10, color: AdminColors.red, fontWeight: FontWeight.w600)),
                        ],
                      )),
                    ],
                  )),
                  Expanded(flex: 3, child: Text(u.email, style: AdminText.muted, overflow: TextOverflow.ellipsis)),
                  SizedBox(width: 70,  child: Text(u.orders > 0 ? '${u.orders}' : '—', style: AdminText.body)),
                  SizedBox(width: 120, child: Text(u.totalSpent > 0 ? '${_fmt(u.totalSpent)} FDJ' : '—', style: AdminText.muted)),
                  SizedBox(width: 90,  child: StatusPill(label: u.role.label, color: u.role.color, bg: u.role.bg)),
                  SizedBox(width: 80,  child: Text(u.joinDate, style: AdminText.tiny)),
                  SizedBox(width: 80,  child: Row(
                    children: [
                      AdminIconBtn(icon: Icons.edit_outlined, onTap: () {}),
                      const SizedBox(width: 6),
                      AdminIconBtn(
                        icon: u.isBanned ? Icons.lock_open_outlined : Icons.block_outlined,
                        onTap: widget.onToggleBan,
                        color: u.isBanned ? AdminColors.green : AdminColors.red,
                      ),
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

String _fmt(int v) {
  final s = v.toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) buf.write(' ');
    buf.write(s[i]);
  }
  return buf.toString();
}