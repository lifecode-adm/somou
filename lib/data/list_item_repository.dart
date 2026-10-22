import 'package:sqflite/sqflite.dart';

import '../models/list_item.dart';
import 'product_history_repository.dart';

class ListItemRepository {
  ListItemRepository(this._db, this._history);

  final Database _db;
  final ProductHistoryRepository _history;

  /// RF12: a ordem de inclusão é a ordem do id.
  Future<List<ListItem>> fetchByList(int listId) async {
    final rows = await _db.query(
      'list_items',
      where: 'list_id = ?',
      whereArgs: [listId],
      orderBy: 'id',
    );
    return rows.map(ListItem.fromMap).toList();
  }

  /// Inclui o item e atualiza o histórico do produto, se ele tiver nome
  /// ([remember]); item sem nome não entra no histórico (RN02).
  Future<int> insert(ListItem item, {bool remember = true}) =>
      _db.transaction((txn) async {
        final id = await txn.insert('list_items', item.toMap());
        if (remember) await _history.save(item, executor: txn);
        await _touchList(txn, item);
        return id;
      });

  /// Salva a edição e atualiza o histórico do produto, como em [insert].
  Future<void> update(ListItem item, {bool remember = true}) =>
      _db.transaction((txn) async {
        await _updateRow(txn, item);
        if (remember) await _history.save(item, executor: txn);
        await _touchList(txn, item);
      });

  /// Marcar "já peguei" não mexe no histórico.
  Future<void> setPicked(ListItem item) => _db.transaction((txn) async {
    await _updateRow(txn, item);
    await _touchList(txn, item);
  });

  Future<void> delete(ListItem item, DateTime now) =>
      _db.transaction((txn) async {
        await txn.delete('list_items', where: 'id = ?', whereArgs: [item.id]);
        await _touchList(txn, item, now);
      });

  /// Desfaz uma remoção mantendo o mesmo id, e com ele a posição na lista.
  Future<void> restore(ListItem item, DateTime now) =>
      _db.transaction((txn) async {
        await txn.insert('list_items', item.toMap());
        await _touchList(txn, item, now);
      });

  Future<void> _updateRow(DatabaseExecutor db, ListItem item) => db.update(
    'list_items',
    item.toMap(),
    where: 'id = ?',
    whereArgs: [item.id],
  );

  Future<void> _touchList(DatabaseExecutor db, ListItem item, [DateTime? at]) =>
      db.update(
        'shopping_lists',
        {'updated_at': (at ?? item.updatedAt).millisecondsSinceEpoch},
        where: 'id = ?',
        whereArgs: [item.listId],
      );
}
