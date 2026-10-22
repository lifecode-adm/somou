import 'package:flutter/material.dart';

import '../models/list_mode.dart';
import '../models/list_totals.dart';
import '../models/shopping_list.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import 'budget_bar.dart';

/// Card de uma lista na Home (RF02).
class ListCard extends StatelessWidget {
  const ListCard({
    super.key,
    required this.summary,
    required this.onTap,
    required this.onLongPress,
  });

  final ShoppingListSummary summary;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final theme = Theme.of(context);
    final list = summary.list;
    final muted = TextStyle(fontSize: 13, color: colors.textMuted);
    final budget = BudgetStatus.of(
      list,
      totalCents: summary.totalCents,
      cartCents: summary.cartCents,
    );
    final counts = [
      plural(summary.itemCount, 'item', 'itens'),
      if (list.mode == ListMode.planning && summary.itemCount > 0)
        '${summary.pickedCount} no carrinho',
    ].join(' · ');

    return Material(
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colors.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 8,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      list.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ModeChip(mode: list.mode),
                ],
              ),
              Text(
                '${list.store ?? 'Sem supermercado'} · '
                '${formatDate(list.createdAt)}',
                style: muted,
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      formatMoney(summary.totalCents),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Text(counts, style: muted),
                ],
              ),
              if (budget != null) ...[
                BudgetBar(status: budget),
                Text(
                  '${budget.percentLabel} de '
                  '${formatMoney(budget.budgetCents)}',
                  style: muted.copyWith(fontSize: 12),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class ModeChip extends StatelessWidget {
  const ModeChip({super.key, required this.mode});

  final ListMode mode;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return switch (mode) {
      ListMode.planning => Pill(
        label: mode.label,
        background: colors.primaryContainer,
        foreground: Theme.of(context).colorScheme.primary,
      ),
      ListMode.shopping => Pill(
        label: mode.label,
        background: colors.shoppingChip,
        foreground: colors.onShoppingChip,
      ),
    };
  }
}
