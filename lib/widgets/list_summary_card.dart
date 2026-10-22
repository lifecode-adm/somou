import 'package:flutter/material.dart';

import '../models/list_mode.dart';
import '../models/list_totals.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import 'budget_bar.dart';

/// Resumo fixo no topo do detalhe da lista (RF14–RF16).
class ListSummaryCard extends StatelessWidget {
  const ListSummaryCard({
    super.key,
    required this.mode,
    required this.totals,
    this.budget,
  });

  final ListMode mode;
  final ListTotals totals;
  final BudgetStatus? budget;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final budget = this.budget;
    final muted = TextStyle(fontSize: 12, color: colors.textMuted);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 10,
        children: [
          Row(
            children: [
              Expanded(child: Text('Total da lista', style: muted)),
              if (budget != null) BudgetChip(status: budget),
            ],
          ),
          Text(
            formatMoney(totals.totalCents),
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              height: 34 / 30,
            ),
          ),
          Row(
            spacing: 8,
            children: [
              _Metric(
                value: '${totals.itemCount}',
                label: totals.itemCount == 1 ? 'item' : 'itens',
              ),
              _Metric(
                value: formatQuantity(totals.productCount),
                label: totals.productCount == 1 ? 'produto' : 'produtos',
              ),
              // RF15: só o Planejamento separa o que já está no carrinho.
              if (mode == ListMode.planning)
                _Metric(
                  value: formatMoney(totals.cartCents),
                  label: 'no carrinho',
                  flex: 16,
                ),
            ],
          ),
          if (budget != null) ...[
            BudgetBar(status: budget),
            Text(
              '${formatMoney(budget.referenceCents)} de '
              '${formatMoney(budget.budgetCents)}',
              style: muted,
            ),
            if (budget.isOver)
              Row(
                spacing: 6,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 16,
                    color: colors.danger,
                  ),
                  Expanded(
                    child: Text(
                      'Passou ${formatMoney(budget.overCents)} do orçamento',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: colors.danger,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.value, required this.label, this.flex = 10});

  final String value;
  final String label;
  final int flex;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: colors.metricBackground,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              label,
              style: TextStyle(fontSize: 11, color: colors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
