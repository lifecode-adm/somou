import 'package:flutter/material.dart';

import '../models/list_totals.dart';
import '../theme/app_theme.dart';

/// RF16: barra verde, amarela ou vermelha conforme o uso do orçamento.
class BudgetBar extends StatelessWidget {
  const BudgetBar({super.key, required this.status});

  final BudgetStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final over = status.level == BudgetLevel.over;
    return ClipRRect(
      borderRadius: BorderRadius.circular(3),
      child: LinearProgressIndicator(
        value: status.ratio.clamp(0, 1).toDouble(),
        minHeight: 6,
        color: colors.budgetColor(status.level),
        backgroundColor: over
            ? colors.dangerContainer
            : colors.primaryContainer,
        semanticsLabel: status.percentLabel,
      ),
    );
  }
}

/// Selo "82% do orçamento" com a cor do nível.
class BudgetChip extends StatelessWidget {
  const BudgetChip({super.key, required this.status});

  final BudgetStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final (background, foreground) = switch (status.level) {
      BudgetLevel.ok => (
        colors.primaryContainer,
        Theme.of(context).colorScheme.primary,
      ),
      BudgetLevel.warning => (
        colors.warningContainer,
        colors.onWarningContainer,
      ),
      BudgetLevel.over => (colors.dangerContainer, colors.danger),
    };
    return Pill(
      label: status.percentLabel,
      background: background,
      foreground: foreground,
    );
  }
}

class Pill extends StatelessWidget {
  const Pill({
    super.key,
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
    decoration: BoxDecoration(
      color: background,
      borderRadius: BorderRadius.circular(999),
    ),
    child: Text(
      label,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: foreground,
      ),
    ),
  );
}
