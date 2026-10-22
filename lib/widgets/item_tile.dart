import 'package:flutter/material.dart';

import '../models/list_item.dart';
import '../models/list_mode.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';

/// Linha de um item: ação à esquerda, nome, detalhe e subtotal.
///
/// No Planejamento a ação é o checkbox "já peguei" e o item pego fica
/// riscado. Em compra tudo já está no carrinho, então a ação é remover.
class ItemTile extends StatelessWidget {
  const ItemTile({
    super.key,
    required this.item,
    required this.mode,
    required this.onTap,
    required this.onPickedChanged,
    required this.onRemove,
  });

  final ListItem item;
  final ListMode mode;
  final VoidCallback onTap;
  final VoidCallback onPickedChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final planning = mode == ListMode.planning;
    final done = planning && item.picked;
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
            if (planning)
              Checkbox(
                value: done,
                onChanged: (_) => onPickedChanged(),
                semanticLabel: 'Já peguei',
              )
            else
              IconButton(
                onPressed: onRemove,
                icon: Icon(Icons.delete_outline, color: colors.textMuted),
                tooltip: 'Remover',
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
