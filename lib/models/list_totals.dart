import 'list_item.dart';
import 'list_mode.dart';
import 'shopping_list.dart';

/// Campos calculados da lista (não são salvos).
class ListTotals {
  const ListTotals({
    required this.totalCents,
    required this.cartCents,
    required this.itemCount,
    required this.productCount,
  });

  factory ListTotals.fromItems(Iterable<ListItem> items) {
    var total = 0;
    var cart = 0;
    var count = 0;
    var products = 0.0;
    for (final item in items) {
      final subtotal = item.subtotalCents;
      total += subtotal;
      if (item.picked) cart += subtotal;
      count++;
      products += item.unit.countsQuantity ? item.quantity : 1;
    }
    return ListTotals(
      totalCents: total,
      cartCents: cart,
      itemCount: count,
      productCount: products,
    );
  }

  /// RN04: soma dos subtotais de todos os itens.
  final int totalCents;

  /// RN04: soma dos subtotais dos itens marcados.
  final int cartCents;

  /// RN05: número de linhas.
  final int itemCount;

  /// RN06: un e pct somam a quantidade; peso e volume contam 1.
  final double productCount;
}

enum BudgetLevel { ok, warning, over }

/// Uso do orçamento de uma lista (RN08, RN09).
class BudgetStatus {
  const BudgetStatus({required this.referenceCents, required this.budgetCents});

  final int referenceCents;
  final int budgetCents;

  /// Nulo quando a lista não tem orçamento.
  static BudgetStatus? of(
    ShoppingList list, {
    required int totalCents,
    required int cartCents,
  }) {
    final budget = list.budgetCents;
    if (budget == null) return null;
    return BudgetStatus(
      referenceCents: list.mode == ListMode.planning ? totalCents : cartCents,
      budgetCents: budget,
    );
  }

  bool get isOver => referenceCents > budgetCents;

  double get ratio {
    if (budgetCents == 0) return isOver ? double.infinity : 0;
    return referenceCents / budgetCents;
  }

  /// Verde até 80%, amarela de 80% a 100%, vermelha acima de 100%.
  BudgetLevel get level {
    if (isOver) return BudgetLevel.over;
    if (ratio > 0.8) return BudgetLevel.warning;
    return BudgetLevel.ok;
  }

  int get overCents => isOver ? referenceCents - budgetCents : 0;

  String get percentLabel => ratio.isFinite
      ? '${(ratio * 100).round()}% do orçamento'
      : 'Acima do orçamento';
}
