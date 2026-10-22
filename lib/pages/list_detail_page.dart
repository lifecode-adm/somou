import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../controllers/list_detail_controller.dart';
import '../data/list_item_repository.dart';
import '../data/product_history_repository.dart';
import '../data/shopping_list_repository.dart';
import '../l10n/l10n.dart';
import '../models/list_item.dart';
import '../theme/app_theme.dart';
import '../widgets/dialogs.dart';
import '../widgets/item_form_sheet.dart';
import '../widgets/item_tile.dart';
import '../widgets/list_form_sheet.dart';
import '../widgets/list_summary_card.dart';

class ListDetailPage extends StatelessWidget {
  const ListDetailPage({super.key});

  /// Ao duplicar, a tela fecha devolvendo o id da cópia para quem a abriu.
  static Route<int> route(int listId) => MaterialPageRoute(
    builder: (context) => ChangeNotifierProvider(
      create: (context) => ListDetailController(
        listId: listId,
        lists: context.read<ShoppingListRepository>(),
        itemRepo: context.read<ListItemRepository>(),
        history: context.read<ProductHistoryRepository>(),
      )..load(),
      // Avisos desta tela (como o "Desfazer") somem junto com ela, em vez de
      // continuarem na Home.
      child: const ScaffoldMessenger(child: ListDetailPage()),
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
    final l10n = context.l10n;
    final messenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();
    await controller.removeItem(item);
    messenger.showSnackBar(
      SnackBar(
        content: Text(l10n.itemRemoved(item.name)),
        // Com ação, o padrão do Flutter é ficar na tela até alguém tocar.
        persist: false,
        action: SnackBarAction(
          label: l10n.undo,
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
        // A Home abre a cópia, assim recarrega os totais ao voltar dela.
        navigator.pop(
          await controller.duplicate(name: context.l10n.copyOf(list.name)),
        );
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
    final l10n = context.l10n;

    if (list == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: controller.loading
              ? const CircularProgressIndicator()
              : Text(l10n.listNotFound),
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
              [?list.store, list.mode.label(l10n)].join(' · '),
              style: TextStyle(fontSize: 13, color: colors.onHeaderMuted),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: l10n.shareOnWhatsApp,
            icon: const Icon(Icons.share_outlined),
            onPressed: () =>
                shareOnWhatsApp(context, controller.shareText(l10n)),
          ),
          PopupMenuButton<_DetailAction>(
            onSelected: (action) => _onMenu(context, action),
            itemBuilder: (context) => [
              PopupMenuItem(value: _DetailAction.edit, child: Text(l10n.edit)),
              PopupMenuItem(
                value: _DetailAction.duplicate,
                child: Text(l10n.duplicate),
              ),
              PopupMenuItem(
                value: _DetailAction.delete,
                child: Text(l10n.delete),
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
                          mode: list.mode,
                          onTap: () => _editItem(context, item),
                          onPickedChanged: () => controller.togglePicked(item),
                          onRemove: () => _removeItem(context, item),
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
        label: Text(l10n.addItemButton),
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
        context.l10n.emptyListMessage,
        textAlign: TextAlign.center,
        style: TextStyle(color: context.colors.textMuted),
      ),
    ),
  );
}
