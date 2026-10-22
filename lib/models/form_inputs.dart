import 'list_item.dart';
import 'list_mode.dart';
import 'shopping_list.dart';
import 'unit.dart';

/// Valores digitados no formulário de lista. Nenhum é obrigatório (RN01).
class ListInput {
  const ListInput({
    this.name,
    this.store,
    this.budgetCents,
    this.mode = ListMode.shopping,
  });

  final String? name;
  final String? store;
  final int? budgetCents;
  final ListMode mode;

  ShoppingList toNewList(DateTime now) => ShoppingList(
    name: _nameOr(ShoppingList.defaultName(now)),
    store: _blankToNull(store),
    mode: mode,
    budgetCents: budgetCents,
    createdAt: now,
    updatedAt: now,
  );

  /// RF03: o modo não muda depois da criação.
  ShoppingList applyTo(ShoppingList list, DateTime now) => list.copyWith(
    name: _nameOr(ShoppingList.defaultName(list.createdAt)),
    store: _blankToNull(store),
    clearStore: _blankToNull(store) == null,
    budgetCents: budgetCents,
    clearBudget: budgetCents == null,
    updatedAt: now,
  );

  String _nameOr(String fallback) => _blankToNull(name) ?? fallback;
}

/// Valores digitados no formulário de item, com os padrões da RN02.
class ItemInput {
  const ItemInput({
    this.name,
    this.brand,
    this.quantity,
    this.unit = Unit.un,
    this.unitPriceCents,
  });

  final String? name;
  final String? brand;
  final double? quantity;
  final Unit unit;
  final int? unitPriceCents;

  String get effectiveName => _blankToNull(name) ?? kDefaultItemName;

  /// RN02 e RN11: sem quantidade = 1; até 3 casas decimais.
  double get effectiveQuantity {
    final value = quantity;
    if (value == null || value <= 0) return 1;
    return (value * 1000).round() / 1000;
  }

  int get effectiveUnitPriceCents {
    final value = unitPriceCents ?? 0;
    return value < 0 ? 0 : value;
  }

  int get subtotalCents =>
      (effectiveQuantity * effectiveUnitPriceCents).round();

  /// RN07: no Planejamento entra desmarcado; Em compra entra marcado.
  ListItem toNewItem({
    required int listId,
    required ListMode mode,
    required DateTime now,
  }) => ListItem(
    listId: listId,
    name: effectiveName,
    brand: _blankToNull(brand),
    quantity: effectiveQuantity,
    unit: unit,
    unitPriceCents: effectiveUnitPriceCents,
    picked: mode == ListMode.shopping,
    createdAt: now,
    updatedAt: now,
  );

  ListItem applyTo(ListItem item, DateTime now) => item.copyWith(
    name: effectiveName,
    brand: _blankToNull(brand),
    clearBrand: _blankToNull(brand) == null,
    quantity: effectiveQuantity,
    unit: unit,
    unitPriceCents: effectiveUnitPriceCents,
    updatedAt: now,
  );
}

String? _blankToNull(String? value) {
  final trimmed = value?.trim();
  return trimmed == null || trimmed.isEmpty ? null : trimmed;
}
