import 'unit.dart';

/// Último registro de um produto, usado pelo autocompletar (RF09, RN10).
class ProductHistory {
  const ProductHistory({
    required this.name,
    this.brand,
    required this.quantity,
    required this.unit,
    required this.unitPriceCents,
  });

  factory ProductHistory.fromMap(Map<String, Object?> map) => ProductHistory(
    name: map['name'] as String,
    brand: map['brand'] as String?,
    quantity: (map['quantity'] as num).toDouble(),
    unit: Unit.fromDb(map['unit'] as String),
    unitPriceCents: map['unit_price_cents'] as int,
  );

  final String name;
  final String? brand;
  final double quantity;
  final Unit unit;
  final int unitPriceCents;
}
