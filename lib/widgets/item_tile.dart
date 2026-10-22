import 'package:flutter/material.dart';

import '../models/list_item.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';

/// Linha de um item: checkbox "já peguei", nome, detalhe e subtotal.
class ItemTile extends StatelessWidget {
  const ItemTile({
    super.key,
    required this.item,
    required this.onTap,
    required this.onPickedChanged,
  });

  final ListItem item;
  final VoidCallback onTap;
  final VoidCallback onPickedChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final done = item.picked;
    final detail = [
      ?item.brand,
      '${formatQuantity(item.quantity)} ${item.unit.symbol} × '
          '${formatMoney(item.unitPriceCents)}',
    ].join(' · ');

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(4, 6, 16, 6),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: colors.border)),
        ),
        child: Row(
          children: [
            Checkbox(
              value: done,
              onChanged: (_) => onPickedChanged(),
              semanticLabel: 'Já peguei',
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 2,
                children: [
                  Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 15,
                      color: done ? colors.textMuted : null,
                      decoration: done ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  Text(
                    detail,
                    style: TextStyle(fontSize: 12, color: colors.textMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              formatMoney(item.subtotalCents),
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: done ? colors.textMuted : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
