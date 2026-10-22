import '../utils/formatters.dart';
import 'list_mode.dart';

class ShoppingList {
  const ShoppingList({
    this.id,
    required this.name,
    this.store,
    required this.mode,
    this.budgetCents,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ShoppingList.fromMap(Map<String, Object?> map) => ShoppingList(
    id: map['id'] as int?,
    name: map['name'] as String,
    store: map['store'] as String?,
    mode: ListMode.fromDb(map['mode'] as String),
    budgetCents: map['budget_cents'] as int?,
    createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
    updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
  );

  final int? id;
  final String name;
  final String? store;
  final ListMode mode;

  /// Nulo = sem orçamento.
  final int? budgetCents;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// RN01: nome usado quando o usuário não informa um.
  static String defaultName(DateTime createdAt) =>
      'Lista ${formatDate(createdAt)}';

  Map<String, Object?> toMap() => {
    if (id != null) 'id': id,
    'name': name,
    'store': store,
    'mode': mode.dbValue,
    'budget_cents': budgetCents,
    'created_at': createdAt.millisecondsSinceEpoch,
    'updated_at': updatedAt.millisecondsSinceEpoch,
  };

  ShoppingList copyWith({
    int? id,
    String? name,
    String? store,
    bool clearStore = false,
    int? budgetCents,
    bool clearBudget = false,
    DateTime? updatedAt,
  }) => ShoppingList(
    id: id ?? this.id,
    name: name ?? this.name,
    store: clearStore ? null : store ?? this.store,
    mode: mode,
    budgetCents: clearBudget ? null : budgetCents ?? this.budgetCents,
    createdAt: createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}

/// Lista com os totais calculados pela consulta agregada da Home.
class ShoppingListSummary {
  const ShoppingListSummary({
    required this.list,
    required this.totalCents,
    required this.cartCents,
    required this.itemCount,
    required this.pickedCount,
  });

  final ShoppingList list;
  final int totalCents;
  final int cartCents;
  final int itemCount;
  final int pickedCount;
}
