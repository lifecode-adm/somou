import 'package:sqflite/sqflite.dart';

import '../models/list_item.dart';
import '../models/product_history.dart';
import '../utils/formatters.dart';

class ProductHistoryRepository {
  ProductHistoryRepository(this._db);

  final Database _db;

  /// RF09: produtos já usados cujo nome contém [query], os que começam
  /// com ela primeiro e depois os usados mais recentemente.
  Future<List<ProductHistory>> search(String query, {int limit = 5}) async {
    final key = _escapeLike(normalizeName(query));
    if (key.isEmpty) return const [];
    final rows = await _db.rawQuery(
      r'''
      SELECT name, brand, quantity, unit, unit_price_cents
      FROM product_history
      WHERE name_key LIKE ? ESCAPE '\'
      ORDER BY name_key LIKE ? ESCAPE '\' DESC, last_used_at DESC
      LIMIT ?
      ''',
      ['%$key%', '$key%', limit],
    );
    return rows.map(ProductHistory.fromMap).toList();
  }

  /// Guarda o item como último registro do produto. Usa UPDATE seguido de
  /// INSERT porque o SQLite de Androids antigos não tem ON CONFLICT DO UPDATE.
  Future<void> save(ListItem item, {DatabaseExecutor? executor}) async {
    if (item.name == kDefaultItemName) return;
    final db = executor ?? _db;
    final values = {
      'name_key': normalizeName(item.name),
      'name': item.name,
      'brand': item.brand,
      'quantity': item.quantity,
      'unit': item.unit.symbol,
      'unit_price_cents': item.unitPriceCents,
      'last_used_at': item.updatedAt.millisecondsSinceEpoch,
    };
    final updated = await db.update(
      'product_history',
      values,
      where: 'name_key = ?',
      whereArgs: [values['name_key']],
    );
    if (updated == 0) await db.insert('product_history', values);
  }

  String _escapeLike(String value) =>
      value.replaceAllMapped(RegExp(r'[\\%_]'), (m) => '\\${m[0]}');
}
