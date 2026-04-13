import 'package:flutter/material.dart';
import 'package:dj/widgets/product__widget/shared.dart';


// cette classe représente une puce de guide pour les catégories de produits dans la page des produits. 
//Elle affiche le nom de la catégorie, le nombre de produits dans cette catégorie, et change d'apparence
// lorsqu'elle est active ou survolée. Lorsqu'on clique dessus, elle déclenche une action définie par 
//le callback onTap.

class ProductsWebGuideChip extends StatefulWidget {
  final String cat;
  final int count;
  final bool active;
  final VoidCallback onTap;

  const ProductsWebGuideChip({
    required this.cat,
    required this.count,
    required this.active,
    required this.onTap,
  });

  @override
  State<ProductsWebGuideChip> createState() => _ProductsWebGuideChipState();
}

class _ProductsWebGuideChipState extends State<ProductsWebGuideChip> {
  bool _hov = false;

  @override
  Widget build(BuildContext context) {
    final m = metaFor(widget.cat);
    final on = widget.active || _hov;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hov = true),
      onExit: (_) => setState(() => _hov = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 170),
          margin: const EdgeInsets.only(right: 8),
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
          decoration: BoxDecoration(
            color: widget.active
                ? m.fg
                : on
                    ? m.bg
                    : kBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.active
                  ? m.fg
                  : on
                      ? m.fg.withOpacity(0.3)
                      : kBorder,
              width: widget.active ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                m.icon,
                size: 15,
                color: widget.active ? Colors.white : m.fg,
              ),
              const SizedBox(width: 7),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 100),
                child: Text(
                  widget.cat,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: widget.active
                        ? FontWeight.w700
                        : FontWeight.w500,
                    color: widget.active ? Colors.white : kInk,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: widget.active ? Colors.white.withOpacity(0.22) : m.bg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${widget.count}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: widget.active ? Colors.white : m.fg,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
