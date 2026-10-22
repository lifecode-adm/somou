import 'package:flutter/foundation.dart';

import '../data/list_item_repository.dart';
import '../data/product_history_repository.dart';
import '../data/shopping_list_repository.dart';
import '../models/form_inputs.dart';
import '../models/list_item.dart';
import '../models/list_totals.dart';
import '../models/product_history.dart';
import '../models/shopping_list.dart';
import '../utils/share_text.dart';

class ListDetailController extends ChangeNotifier {
  ListDetailController({
    required this.listId,
    required this._lists,
    required this._itemRepo,
    required this._history,
  });

  final int listId;
  final ShoppingListRepository _lists;
  final ListItemRepository _itemRepo;
  final ProductHistoryRepository _history;

  ShoppingList? _list;
  List<ListItem> _items = const [];
  ListTotals _totals = ListTotals.fromItems(const []);
  bool _loading = true;

  ShoppingList? get list => _list;
  List<ListItem> get items => _items;
  bool get loading => _loading;

  /// RF14–RF17: recalculado a cada mudança nos itens.
  ListTotals get totals => _totals;

  BudgetStatus? get budget {
    final list = _list;
    if (list == null) return null;
    return BudgetStatus.of(
      list,
      totalCents: _totals.totalCents,
      cartCents: _totals.cartCents,
    );
  }

  Future<void> load() async {
    _list = await _lists.fetchById(listId);
    _setItems(await _itemRepo.fetchByList(listId));
    _loading = false;
    notifyListeners();
  }

  /// RN07: o modo da lista decide se o item entra marcado.
  Future<void> addItem(ItemInput input) async {
    final item = input.toNewItem(
      listId: listId,
      mode: _list!.mode,
      now: DateTime.now(),
    );
    final id = await _itemRepo.insert(item);
    _setItems([..._items, item.copyWith(id: id)]);
    notifyListeners();
  }

  Future<void> updateItem(ListItem item, ItemInput input) async {
    final updated = input.applyTo(item, DateTime.now());
    await _itemRepo.update(updated);
    _replace(updated);
  }

  Future<void> togglePicked(ListItem item) async {
    final updated = item.copyWith(
      picked: !item.picked,
      updatedAt: DateTime.now(),
    );
    _replace(updated);
    await _itemRepo.setPicked(updated);
  }

  /// Tira o item da tela na hora (o Dismissible exige) e depois do banco.
  Future<void> removeItem(ListItem item) async {
    _setItems(_items.where((i) => i.id != item.id).toList());
    notifyListeners();
    await _itemRepo.delete(item, DateTime.now());
  }

  /// RF11: desfazer a remoção devolve o item à mesma posição.
  Future<void> restoreItem(ListItem item) async {
    await _itemRepo.restore(item, DateTime.now());
    _setItems([..._items, item]..sort((a, b) => a.id!.compareTo(b.id!)));
    notifyListeners();
  }

  Future<void> updateList(ListInput input) async {
    final updated = input.applyTo(_list!, DateTime.now());
    await _lists.update(updated);
    _list = updated;
    notifyListeners();
  }

  Future<int> duplicate() => _lists.duplicate(_list!, DateTime.now());

  Future<void> delete() => _lists.delete(listId);

  Future<List<ProductHistory>> searchProducts(String query) =>
      _history.search(query);

  String shareText() => buildShareText(_list!, _items);

  void _replace(ListItem updated) {
    _setItems([
      for (final item in _items) item.id == updated.id ? updated : item,
    ]);
    notifyListeners();
  }

  void _setItems(List<ListItem> items) {
    _items = items;
    _totals = ListTotals.fromItems(items);
  }
}
