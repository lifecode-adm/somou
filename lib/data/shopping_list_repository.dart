import 'package:sqflite/sqflite.dart';

import '../models/list_mode.dart';
import '../models/shopping_list.dart';

class ShoppingListRepository {
  ShoppingListRepository(this._db);

  final Database _db;

  /// RF02: listas da Home com total e contagens, sem carregar os itens.
  Future<List<ShoppingListSummary>> fetchSummaries() async {
    final rows = await _db.rawQuery('''
      SELECT l.*,
        COALESCE(t.total_cents, 0)  AS total_cents,
        COALESCE(t.cart_cents, 0)   AS cart_cents,
        COALESCE(t.item_count, 0)   AS item_count,
        COALESCE(t.picked_count, 0) AS picked_count
      FROM shopping_lists l
      LEFT JOIN (
        SELECT list_id,
          SUM(CAST(ROUND(quantity * unit_price_cents) AS INTEGER)) AS total_cents,
          SUM(CASE WHEN picked = 1
            THEN CAST(ROUND(quantity * unit_price_cents) AS INTEGER)
            ELSE 0 END) AS cart_cents,
          COUNT(*)    AS item_count,
          SUM(picked) AS picked_count
        FROM list_items
        GROUP BY list_id
      ) t ON t.list_id = l.id
      ORDER BY l.created_at DESC, l.id DESC
    ''');
    return rows
        .map(
          (row) => ShoppingListSummary(
            list: ShoppingList.fromMap(row),
            totalCents: row['total_cents'] as int,
            cartCents: row['cart_cents'] as int,
            itemCount: row['item_count'] as int,
            pickedCount: row['picked_count'] as int,
          ),
        )
        .toList();
  }

  Future<ShoppingList?> fetchById(int id) async {
    final rows = await _db.query(
      'shopping_lists',
      where: 'id = ?',
      whereArgs: [id],
    );
    return rows.isEmpty ? null : ShoppingList.fromMap(rows.first);
  }

  Future<int> insert(ShoppingList list) =>
      _db.insert('shopping_lists', list.toMap());

  Future<void> update(ShoppingList list) => _db.update(
    'shopping_lists',
    list.toMap(),
    where: 'id = ?',
    whereArgs: [list.id],
  );

  /// RF04: os itens saem junto pela exclusão em cascata.
  Future<void> delete(int id) =>
      _db.delete('shopping_lists', where: 'id = ?', whereArgs: [id]);

  /// RF05: copia os itens desmarcados, com "Cópia de …" e modo Planejamento.
  Future<int> duplicate(ShoppingList source, DateTime now) =>
      _db.transaction((txn) async {
        final copy = ShoppingList(
          name: 'Cópia de ${source.name}',
          store: source.store,
          mode: ListMode.planning,
          budgetCents: source.budgetCents,
          createdAt: now,
          updatedAt: now,
        );
        final id = await txn.insert('shopping_lists', copy.toMap());
        final millis = now.millisecondsSinceEpoch;
        await txn.rawInsert(
          '''
          INSERT INTO list_items (list_id, name, brand, quantity, unit,
            unit_price_cents, picked, created_at, updated_at)
          SELECT ?, name, brand, quantity, unit, unit_price_cents, 0, ?, ?
          FROM list_items
          WHERE list_id = ?
          ORDER BY id
          ''',
          [id, millis, millis, source.id],
        );
        return id;
      });
}
