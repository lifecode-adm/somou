import 'package:flutter_test/flutter_test.dart';
import 'package:somou/data/app_database.dart';
import 'package:somou/data/list_item_repository.dart';
import 'package:somou/data/product_history_repository.dart';
import 'package:somou/data/shopping_list_repository.dart';
import 'package:somou/models/form_inputs.dart';
import 'package:somou/models/list_mode.dart';
import 'package:somou/models/unit.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();

  late Database db;
  late ShoppingListRepository lists;
  late ListItemRepository items;
  late ProductHistoryRepository history;
  final now = DateTime(2026, 10, 21);

  setUp(() async {
    db = await AppDatabase.open(
      factory: databaseFactoryFfi,
      path: inMemoryDatabasePath,
    );
    history = ProductHistoryRepository(db);
    lists = ShoppingListRepository(db);
    items = ListItemRepository(db, history);
  });

  tearDown(() => db.close());

  Future<int> addItem(int listId, ItemInput input, {ListMode? mode}) =>
      items.insert(
        input.toNewItem(
          listId: listId,
          mode: mode ?? ListMode.planning,
          now: now,
        ),
        remember: input.hasName,
      );

  test('Home soma totais e contagens sem carregar itens', () async {
    final id = await lists.insert(
      const ListInput(name: 'Compra do mês').toNewList(now),
    );
    await addItem(
      id,
      const ItemInput(name: 'Arroz', quantity: 2, unitPriceCents: 2500),
    );
    final carne = await addItem(
      id,
      const ItemInput(
        name: 'Carne',
        quantity: 1.5,
        unit: Unit.kg,
        unitPriceCents: 3990,
      ),
    );
    final carneItem = (await items.fetchByList(id))
        .firstWhere((i) => i.id == carne);
    await items.setPicked(carneItem.copyWith(picked: true));

    final summary = (await lists.fetchSummaries()).single;
    expect(summary.totalCents, 5000 + 5985);
    expect(summary.cartCents, 5985);
    expect(summary.itemCount, 2);
    expect(summary.pickedCount, 1);
  });

  test('RF04: excluir a lista apaga os itens em cascata', () async {
    final id = await lists.insert(const ListInput().toNewList(now));
    await addItem(id, const ItemInput(name: 'Leite'));
    await lists.delete(id);
    expect(await db.query('list_items'), isEmpty);
  });

  test('RF05: duplicar copia itens desmarcados em Planejamento', () async {
    final id = await lists.insert(
      const ListInput(
        name: 'Churrasco',
        mode: ListMode.shopping,
      ).toNewList(now),
    );
    await addItem(
      id,
      const ItemInput(name: 'Picanha'),
      mode: ListMode.shopping,
    );
    final source = (await lists.fetchById(id))!;

    final copyId = await lists.duplicate(
      source,
      now,
      name: 'Cópia de Churrasco',
    );
    final copy = (await lists.fetchById(copyId))!;
    final copied = await items.fetchByList(copyId);
    expect(copy.name, 'Cópia de Churrasco');
    expect(copy.mode, ListMode.planning);
    expect(copied.single.name, 'Picanha');
    expect(copied.single.picked, isFalse);
  });

  test('RF09 e RN10: histórico guarda o último registro do produto', () async {
    final id = await lists.insert(const ListInput().toNewList(now));
    await addItem(
      id,
      const ItemInput(name: 'Leite integral', unitPriceCents: 459),
    );
    await addItem(
      id,
      const ItemInput(
        name: 'leite  INTEGRAL',
        brand: 'Piracanjuba',
        quantity: 6,
        unitPriceCents: 479,
      ),
    );
    await addItem(id, const ItemInput(name: 'Leite em pó'));
    await addItem(id, const ItemInput()); // "Item sem nome" não entra.

    final found = await history.search('lei');
    expect(
      found.map((p) => p.name),
      unorderedEquals(['leite  INTEGRAL', 'Leite em pó']),
    );
    final leite = found.firstWhere((p) => p.name.startsWith('leite'));
    expect(leite.unitPriceCents, 479);
    expect(leite.brand, 'Piracanjuba');
    expect(await history.search('item sem'), isEmpty);
    expect(await history.search('pó'), hasLength(1));
  });

  test('RF11: desfazer remoção mantém a posição do item', () async {
    final id = await lists.insert(const ListInput().toNewList(now));
    for (final name in ['A', 'B', 'C']) {
      await addItem(id, ItemInput(name: name));
    }
    final b = (await items.fetchByList(id))[1];
    await items.delete(b, now);
    await items.restore(b, now);
    expect((await items.fetchByList(id)).map((i) => i.name), ['A', 'B', 'C']);
  });
}
