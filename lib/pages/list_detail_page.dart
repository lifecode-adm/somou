import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../controllers/list_detail_controller.dart';
import '../data/list_item_repository.dart';
import '../data/product_history_repository.dart';
import '../data/shopping_list_repository.dart';
import '../models/list_item.dart';
import '../theme/app_theme.dart';
import '../widgets/dialogs.dart';
import '../widgets/item_form_sheet.dart';
import '../widgets/item_tile.dart';
import '../widgets/list_form_sheet.dart';
import '../widgets/list_summary_card.dart';

class ListDetailPage extends StatelessWidget {
  const ListDetailPage({super.key});

  static Route<void> route(int listId) => MaterialPageRoute(
    builder: (context) => ChangeNotifierProvider(
      create: (context) => ListDetailController(
        listId: listId,
        lists: context.read<ShoppingListRepository>(),
        itemRepo: context.read<ListItemRepository>(),
        history: context.read<ProductHistoryRepository>(),
      )..load(),
      child: const ListDetailPage(),
    ),
  );

  Future<void> _addItem(BuildContext context) async {
    final controller = context.read<ListDetailController>();
    final input = await showItemFormSheet(
      context,
      search: controller.searchProducts,
    );
    if (input != null) await controller.addItem(input);
  }

  Future<void> _editItem(BuildContext context, ListItem item) async {
    final controller = context.read<ListDetailController>();
    final input = await showItemFormSheet(
      context,
      search: controller.searchProducts,
      initial: item,
    );
    if (input != null) await controller.updateItem(item, input);
  }

  Future<void> _removeItem(BuildContext context, ListItem item) async {
    final controller = context.read<ListDetailController>();
    final messenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();
    await controller.removeItem(item);
    messenger.showSnackBar(
      SnackBar(
        content: Text('"${item.name}" removido.'),
        action: SnackBarAction(
          label: 'Desfazer',
          onPressed: () => controller.restoreItem(item),
        ),
      ),
    );
  }

  Future<void> _onMenu(BuildContext context, _DetailAction action) async {
    final controller = context.read<ListDetailController>();
    final navigator = Navigator.of(context);
    final list = controller.list!;
    switch (action) {
      case _DetailAction.edit:
        final input = await showListFormSheet(context, initial: list);
        if (input != null) await controller.updateList(input);
      case _DetailAction.duplicate:
        final id = await controller.duplicate();
        await navigator.pushReplacement(ListDetailPage.route(id));
      case _DetailAction.delete:
        if (await confirmDeleteList(context, list)) {
          await controller.delete();
          navigator.pop();
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ListDetailController>();
    final list = controller.list;
    final colors = context.colors;

    if (list == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: controller.loading
              ? const CircularProgressIndicator()
              : const Text('Lista não encontrada.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleSpacing: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              list.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              [?list.store, list.mode.label].join(' · '),
              style: TextStyle(fontSize: 13, color: colors.onHeaderMuted),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Compartilhar no WhatsApp',
            icon: const Icon(Icons.share_outlined),
            onPressed: () => shareOnWhatsApp(context, controller.shareText()),
          ),
          PopupMenuButton<_DetailAction>(
            onSelected: (action) => _onMenu(context, action),
            itemBuilder: (context) => const [
              PopupMenuItem(value: _DetailAction.edit, child: Text('Editar')),
              PopupMenuItem(
                value: _DetailAction.duplicate,
                child: Text('Duplicar'),
              ),
              PopupMenuItem(
                value: _DetailAction.delete,
                child: Text('Excluir'),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Resumo fixo, sobreposto à faixa verde do cabeçalho.
          Stack(
            children: [
              Container(height: 24, color: colors.header),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                child: ListSummaryCard(
                  mode: list.mode,
                  totals: controller.totals,
                  budget: controller.budget,
                ),
              ),
            ],
          ),
          Expanded(
            child: controller.items.isEmpty
                ? const _EmptyList()
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 4, bottom: 96),
                    itemCount: controller.items.length,
                    itemBuilder: (context, index) {
                      final item = controller.items[index];
                      return Dismissible(
                        key: ValueKey(item.id),
                        background: const _DeleteBackground(
                          alignment: Alignment.centerLeft,
                        ),
                        secondaryBackground: const _DeleteBackground(
                          alignment: Alignment.centerRight,
                        ),
                        onDismissed: (_) => _removeItem(context, item),
                        child: ItemTile(
                          item: item,
                          onTap: () => _editItem(context, item),
                          onPickedChanged: () => controller.togglePicked(item),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addItem(context),
        icon: const Icon(Icons.add),
        label: const Text('Item'),
      ),
    );
  }
}

enum _DetailAction { edit, duplicate, delete }

class _DeleteBackground extends StatelessWidget {
  const _DeleteBackground({required this.alignment});

  final Alignment alignment;

  @override
  Widget build(BuildContext context) => Container(
    color: context.colors.danger,
    alignment: alignment,
    padding: const EdgeInsets.symmetric(horizontal: 20),
    child: const Icon(Icons.delete_outline, color: Colors.white),
  );
}

class _EmptyList extends StatelessWidget {
  const _EmptyList();

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Text(
        'Nenhum item ainda. Toque em "Item" para adicionar.',
        textAlign: TextAlign.center,
        style: TextStyle(color: context.colors.textMuted),
      ),
    ),
  );
}
