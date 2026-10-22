import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../controllers/home_controller.dart';
import '../models/shopping_list.dart';
import '../theme/app_theme.dart';
import '../widgets/dialogs.dart';
import '../widgets/list_card.dart';
import '../widgets/list_form_sheet.dart';
import 'list_detail_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _openList(BuildContext context, int listId) async {
    final controller = context.read<HomeController>();
    final copyId = await Navigator.of(context).push(
      ListDetailPage.route(listId),
    );
    // O detalhe pode ter mudado itens, totais ou excluído a lista.
    await controller.load();
    // Duplicada no detalhe: abre a cópia.
    if (copyId != null && context.mounted) await _openList(context, copyId);
  }

  Future<void> _createList(BuildContext context) async {
    final controller = context.read<HomeController>();
    final input = await showListFormSheet(context);
    if (input == null || !context.mounted) return;
    final id = await controller.createList(input);
    if (context.mounted) await _openList(context, id);
  }

  Future<void> _showActions(BuildContext context, ShoppingList list) async {
    final controller = context.read<HomeController>();
    final action = await showModalBottomSheet<_ListAction>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Editar'),
              onTap: () => Navigator.of(context).pop(_ListAction.edit),
            ),
            ListTile(
              leading: const Icon(Icons.copy_outlined),
              title: const Text('Duplicar'),
              onTap: () => Navigator.of(context).pop(_ListAction.duplicate),
            ),
            ListTile(
              leading: Icon(Icons.delete_outline, color: context.colors.danger),
              title: Text(
                'Excluir',
                style: TextStyle(color: context.colors.danger),
              ),
              onTap: () => Navigator.of(context).pop(_ListAction.delete),
            ),
          ],
        ),
      ),
    );
    if (action == null || !context.mounted) return;

    switch (action) {
      case _ListAction.edit:
        final input = await showListFormSheet(context, initial: list);
        if (input != null) await controller.updateList(list, input);
      case _ListAction.duplicate:
        await controller.duplicateList(list);
        if (context.mounted) showMessage(context, 'Lista duplicada.');
      case _ListAction.delete:
        if (await confirmDeleteList(context, list)) {
          await controller.deleteList(list);
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HomeController>();
    final colors = context.colors;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ColoredBox(
              color: colors.header,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 2,
                    children: [
                      Row(
                        spacing: 10,
                        children: [
                          Image.asset(
                            'assets/splash/logo.png',
                            height: 30,
                            excludeFromSemantics: true,
                          ),
                          Text(
                            'Somou',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                              color: colors.onHeader,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Lista de compras com total na hora',
                        style: TextStyle(
                          fontSize: 13,
                          color: colors.onHeaderMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: switch (controller) {
                HomeController(loading: true) => const Center(
                  child: CircularProgressIndicator(),
                ),
                HomeController(summaries: []) => const _EmptyHome(),
                _ => ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                  itemCount: controller.summaries.length + 1,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Text(
                        'Suas listas',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.2,
                          color: colors.textMuted,
                        ),
                      );
                    }
                    final summary = controller.summaries[index - 1];
                    return ListCard(
                      summary: summary,
                      onTap: () => _openList(context, summary.list.id!),
                      onLongPress: () => _showActions(context, summary.list),
                    );
                  },
                ),
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _createList(context),
          icon: const Icon(Icons.add),
          label: const Text('Nova lista'),
        ),
      ),
    );
  }
}

enum _ListAction { edit, duplicate, delete }

class _EmptyHome extends StatelessWidget {
  const _EmptyHome();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 8,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 56,
              color: colors.textMuted,
            ),
            const Text(
              'Nenhuma lista ainda',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            Text(
              'Toque em "Nova lista" e veja o total subir a cada item.',
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
