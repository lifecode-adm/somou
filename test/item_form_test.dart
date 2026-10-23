import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:somou/l10n/l10n.dart';
import 'package:somou/models/form_inputs.dart';
import 'package:somou/models/list_item.dart';
import 'package:somou/models/list_mode.dart';
import 'package:somou/models/shopping_list.dart';
import 'package:somou/models/unit.dart';
import 'package:somou/theme/app_theme.dart';
import 'package:somou/widgets/item_form_sheet.dart';
import 'package:somou/widgets/list_form_sheet.dart';

final _now = DateTime(2026, 10, 22);

/// Abre o formulário a partir de um botão, como no app. Quem chama guarda o
/// resultado do bottom sheet dentro de [show].
Future<void> _open(
  WidgetTester tester,
  Future<Object?> Function(BuildContext context) show,
) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: buildTheme(Brightness.light),
      locale: const Locale('pt'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) => TextButton(
          onPressed: () => show(context),
          child: const Text('abrir'),
        ),
      ),
    ),
  );
  await tester.tap(find.text('abrir'));
  await tester.pumpAndSettle();
}

/// Edita só o campo [label], sem mexer em mais nada, e salva.
Future<void> _editLastAndSave(
  WidgetTester tester,
  String label,
  String text,
) async {
  await tester.enterText(find.widgetWithText(TextField, label), text);
  await tester.tap(find.text('Salvar'));
  await tester.pumpAndSettle();
}

void main() {
  group('edição de item salva o campo alterado por último', () {
    final item = ListItem(
      id: 1,
      listId: 1,
      name: 'Sabão em pó',
      brand: 'Ipe',
      quantity: 1,
      unit: Unit.un,
      unitPriceCents: 800,
      picked: true,
      createdAt: _now,
      updatedAt: _now,
    );

    Future<ItemInput?> edit(
      WidgetTester tester,
      String label,
      String text,
    ) async {
      ItemInput? saved;
      await _open(
        tester,
        (context) async => saved = await showItemFormSheet(
          context,
          search: (_) async => const [],
          initial: item,
        ),
      );
      await _editLastAndSave(tester, label, text);
      return saved;
    }

    testWidgets('marca', (tester) async {
      expect((await edit(tester, 'Marca (opcional)', 'Ypê'))?.brand, 'Ypê');
    });

    testWidgets('produto', (tester) async {
      expect(
        (await edit(tester, 'Produto', 'Sabão líquido'))?.name,
        'Sabão líquido',
      );
    });

    testWidgets('quantidade', (tester) async {
      expect((await edit(tester, 'Quantidade', '3'))?.quantity, 3);
    });

    testWidgets('valor unitário', (tester) async {
      expect(
        (await edit(tester, 'Valor unitário', '1290'))?.unitPriceCents,
        1290,
      );
    });
  });

  group('edição de lista salva o campo alterado por último', () {
    final list = ShoppingList(
      id: 1,
      name: 'Setembro',
      store: 'Atacado',
      mode: ListMode.shopping,
      budgetCents: 50000,
      createdAt: _now,
      updatedAt: _now,
    );

    Future<ListInput?> edit(
      WidgetTester tester,
      String label,
      String text,
    ) async {
      ListInput? saved;
      await _open(
        tester,
        (context) async =>
            saved = await showListFormSheet(context, initial: list),
      );
      await _editLastAndSave(tester, label, text);
      return saved;
    }

    testWidgets('nome', (tester) async {
      expect((await edit(tester, 'Nome da lista', 'Outubro'))?.name, 'Outubro');
    });

    testWidgets('supermercado', (tester) async {
      expect(
        (await edit(tester, 'Supermercado (opcional)', 'Atacadão'))?.store,
        'Atacadão',
      );
    });

    testWidgets('orçamento', (tester) async {
      expect(
        (await edit(tester, 'Orçamento (opcional)', '30000'))?.budgetCents,
        30000,
      );
    });
  });
}
