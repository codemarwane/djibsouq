import 'package:flutter/material.dart';
import 'package:dj/widgets/product__widget/shared.dart';

class ProductsWebSideItem extends StatefulWidget {
  final String cat;
  final int count;
  final bool active;
  final VoidCallback onTap;

  const ProductsWebSideItem({
    required this.cat,
    required this.count,
    required this.active,
    required this.onTap,
  });

  @override
  State<ProductsWebSideItem> createState() => _ProductsWebSideItemState();
}

class _ProductsWebSideItemState extends State<ProductsWebSideItem> {
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
          duration: const Duration(milliseconds: 160),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: on ? Colors.white.withOpacity(0.09) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border(
              left: BorderSide(
                color: widget.active ? m.fg : Colors.transparent,
                width: 3,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                m.icon,
                size: 16,
                color: on ? Colors.white : Colors.white.withOpacity(0.45),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.cat,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight:
                        widget.active ? FontWeight.w700 : FontWeight.w400,
                    color: on ? Colors.white : Colors.white.withOpacity(0.55),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(on ? 0.14 : 0.07),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${widget.count}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Colors.white.withOpacity(on ? 0.9 : 0.4),
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
