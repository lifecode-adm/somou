import 'package:flutter/foundation.dart';

import '../data/shopping_list_repository.dart';
import '../models/form_inputs.dart';
import '../models/shopping_list.dart';

class HomeController extends ChangeNotifier {
  HomeController(this._lists);

  final ShoppingListRepository _lists;

  List<ShoppingListSummary> _summaries = const [];
  bool _loading = true;

  List<ShoppingListSummary> get summaries => _summaries;
  bool get loading => _loading;

  Future<void> load() async {
    _summaries = await _lists.fetchSummaries();
    _loading = false;
    notifyListeners();
  }

  /// RF01: devolve o id da lista criada.
  Future<int> createList(ListInput input) async {
    final id = await _lists.insert(input.toNewList(DateTime.now()));
    await load();
    return id;
  }

  Future<void> updateList(ShoppingList list, ListInput input) async {
    await _lists.update(input.applyTo(list, DateTime.now()));
    await load();
  }

  Future<void> deleteList(ShoppingList list) async {
    await _lists.delete(list.id!);
    await load();
  }

  Future<int> duplicateList(ShoppingList list) async {
    final id = await _lists.duplicate(list, DateTime.now());
    await load();
    return id;
  }
}
