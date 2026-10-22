import 'unit.dart';

/// RN02: nome dado a um item sem nome quando não há tradução à mão.
const kDefaultItemName = 'Item sem nome';

class ListItem {
  const ListItem({
    this.id,
    required this.listId,
    required this.name,
    this.brand,
    required this.quantity,
    required this.unit,
    required this.unitPriceCents,
    required this.picked,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ListItem.fromMap(Map<String, Object?> map) => ListItem(
    id: map['id'] as int?,
    listId: map['list_id'] as int,
    name: map['name'] as String,
    brand: map['brand'] as String?,
    quantity: (map['quantity'] as num).toDouble(),
    unit: Unit.fromDb(map['unit'] as String),
    unitPriceCents: map['unit_price_cents'] as int,
    picked: map['picked'] == 1,
    createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
    updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
  );

  final int? id;
  final int listId;
  final String name;
  final String? brand;
  final double quantity;
  final Unit unit;
  final int unitPriceCents;
  final bool picked;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// RN03: quantidade × valor unitário, arredondado ao centavo.
  int get subtotalCents => (quantity * unitPriceCents).round();

  Map<String, Object?> toMap() => {
    if (id != null) 'id': id,
    'list_id': listId,
    'name': name,
    'brand': brand,
    'quantity': quantity,
    'unit': unit.symbol,
    'unit_price_cents': unitPriceCents,
    'picked': picked ? 1 : 0,
    'created_at': createdAt.millisecondsSinceEpoch,
    'updated_at': updatedAt.millisecondsSinceEpoch,
  };

  ListItem copyWith({
    int? id,
    String? name,
    String? brand,
    bool clearBrand = false,
    double? quantity,
    Unit? unit,
    int? unitPriceCents,
    bool? picked,
    DateTime? updatedAt,
  }) => ListItem(
    id: id ?? this.id,
    listId: listId,
    name: name ?? this.name,
    brand: clearBrand ? null : brand ?? this.brand,
    quantity: quantity ?? this.quantity,
    unit: unit ?? this.unit,
    unitPriceCents: unitPriceCents ?? this.unitPriceCents,
    picked: picked ?? this.picked,
    createdAt: createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}
