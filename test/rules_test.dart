import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:somou/l10n/l10n.dart';
import 'package:somou/models/form_inputs.dart';
import 'package:somou/models/list_item.dart';
import 'package:somou/models/list_mode.dart';
import 'package:somou/models/list_totals.dart';
import 'package:somou/models/shopping_list.dart';
import 'package:somou/models/unit.dart';
import 'package:somou/utils/formatters.dart';
import 'package:somou/utils/share_text.dart';

final _now = DateTime(2026, 10, 21, 9, 41);
final _pt = lookupAppLocalizations(const Locale('pt'));
final _en = lookupAppLocalizations(const Locale('en'));

ListItem _item(
  String name,
  double quantity,
  Unit unit,
  int priceCents, {
  bool picked = false,
  String? brand,
}) => ListItem(
  listId: 1,
  name: name,
  brand: brand,
  quantity: quantity,
  unit: unit,
  unitPriceCents: priceCents,
  picked: picked,
  createdAt: _now,
  updatedAt: _now,
);

ShoppingList _list({ListMode mode = ListMode.planning, int? budget}) =>
    ShoppingList(
      id: 1,
      name: 'Compra do mês',
      store: 'Atacadão',
      mode: mode,
      budgetCents: budget,
      createdAt: _now,
      updatedAt: _now,
    );

void main() {
  setUpAll(initializeDateFormatting);

  group('formatação', () {
    test('moeda em pt_BR', () {
      expect(formatMoney(16396), r'R$ 163,96');
      expect(formatMoney(123456), r'R$ 1.234,56');
      expect(formatMoney(0), r'R$ 0,00');
    });

    test('quantidade sem zeros sobrando', () {
      expect(formatQuantity(1.5), '1,5');
      expect(formatQuantity(2), '2');
      expect(formatQuantity(0.125), '0,125');
    });

    test('parse de quantidade e dinheiro', () {
      expect(parseQuantity('1,5'), 1.5);
      expect(parseQuantity(''), isNull);
      expect(parseMoney(r'R$ 4,79'), 479);
      expect(parseMoney(''), isNull);
    });

    test('RN10: nome normalizado', () {
      expect(normalizeName('  Feijão   CARIOCA '), 'feijao carioca');
      expect(normalizeName('Pão de Açúcar'), 'pao de acucar');
    });
  });

  group('regras de negócio', () {
    test('RN01: lista sem nome recebe a data', () {
      final list = const ListInput(name: '  ').toNewList(_now);
      expect(list.name, 'Lista 21/10/2026');
      expect(list.store, isNull);
    });

    test('lista nova começa em Em compra', () {
      expect(const ListInput().toNewList(_now).mode, ListMode.shopping);
    });

    test('RN02: padrões do item', () {
      const input = ItemInput();
      final item = input.toNewItem(
        listId: 1,
        mode: ListMode.planning,
        now: _now,
      );
      expect(item.name, kDefaultItemName);
      expect(item.quantity, 1);
      expect(item.unit, Unit.un);
      expect(item.unitPriceCents, 0);
    });

    test('RN03 e RN11: subtotal arredondado e quantidade com 3 casas', () {
      expect(_item('Banana', 1.2, Unit.kg, 699).subtotalCents, 839);
      expect(const ItemInput(quantity: 1.23456).effectiveQuantity, 1.235);
      expect(const ItemInput(quantity: 0).effectiveQuantity, 1);
    });

    test('RN07: modo decide se o item entra marcado', () {
      const input = ItemInput(name: 'Arroz');
      expect(
        input.toNewItem(listId: 1, mode: ListMode.planning, now: _now).picked,
        isFalse,
      );
      expect(
        input.toNewItem(listId: 1, mode: ListMode.shopping, now: _now).picked,
        isTrue,
      );
    });

    test('RN04–RN06: totais, carrinho, itens e produtos', () {
      final totals = ListTotals.fromItems([
        _item('Arroz', 2, Unit.un, 2500, picked: true),
        _item('Carne', 1.5, Unit.kg, 3990),
        _item('Leite', 6, Unit.un, 479, picked: true),
        _item('Biscoito', 3, Unit.pct, 350),
      ]);
      expect(totals.totalCents, 5000 + 5985 + 2874 + 1050);
      expect(totals.cartCents, 5000 + 2874);
      expect(totals.itemCount, 4);
      expect(totals.productCount, 2 + 1 + 6 + 3);
    });

    test('RN08: referência do orçamento depende do modo', () {
      final planning = BudgetStatus.of(
        _list(budget: 20000),
        totalCents: 16396,
        cartCents: 7874,
      )!;
      expect(planning.referenceCents, 16396);
      final shopping = BudgetStatus.of(
        _list(mode: ListMode.shopping, budget: 20000),
        totalCents: 16396,
        cartCents: 7874,
      )!;
      expect(shopping.referenceCents, 7874);
      expect(BudgetStatus.of(_list(), totalCents: 1, cartCents: 1), isNull);
    });

    test('RN09: cores do orçamento', () {
      BudgetLevel level(int ref) =>
          BudgetStatus(referenceCents: ref, budgetCents: 10000).level;
      expect(level(8000), BudgetLevel.ok);
      expect(level(8001), BudgetLevel.warning);
      expect(level(10000), BudgetLevel.warning);
      expect(level(10001), BudgetLevel.over);
      expect(
        const BudgetStatus(
          referenceCents: 16396,
          budgetCents: 20000,
        ).percentLabel(_pt),
        '82% do orçamento',
      );
    });
  });

  test('RF06: texto para WhatsApp', () {
    final text = buildShareText(_list(), [
      _item('Arroz', 2, Unit.un, 2500, picked: true, brand: 'Tio João'),
      _item('Carne', 1.5, Unit.kg, 3990),
    ], _pt);
    expect(
      text,
      '🛒 Compra do mês — Atacadão\n'
      '━━━━━━━━━━━━\n'
      r'✅ 2 un Arroz (Tio João) — R$ 50,00'
      '\n'
      r'⬜ 1,5 kg Carne — R$ 59,85'
      '\n'
      '━━━━━━━━━━━━\n'
      'Itens: 2 · Produtos: 3\n'
      r'Total: R$ 109,85',
    );
  });

  group('idioma e região', () {
    // Volta ao padrão do app para não afetar os outros testes.
    tearDown(() => configureFormatters(const Locale('pt', 'BR')));

    test('português para qualquer pt; inglês para o resto', () {
      expect(resolveAppLocale(const Locale('pt', 'BR')), const Locale('pt'));
      expect(resolveAppLocale(const Locale('pt', 'PT')), const Locale('pt'));
      expect(resolveAppLocale(const Locale('en', 'US')), const Locale('en'));
      expect(resolveAppLocale(const Locale('es', 'ES')), const Locale('en'));
      expect(resolveAppLocale(null), const Locale('en'));
    });

    test('moeda vem da região, formato vem do idioma', () {
      configureFormatters(const Locale('en', 'US'));
      expect(formatMoney(123456), r'$1,234.56');
      expect(formatQuantity(1.5), '1.5');
      expect(formatQuantityInput(1234.5), '1234.5');
      expect(formatDate(_now), '10/21/2026');

      configureFormatters(const Locale('en', 'BR'));
      expect(formatMoney(479), r'R$4.79');

      configureFormatters(const Locale('de', 'DE'));
      expect(formatMoney(479), '4,79 €');

      configureFormatters(const Locale('pt', 'BR'));
      expect(formatMoney(123456), r'R$ 1.234,56');
      expect(formatDate(_now), '21/10/2026');
    });

    test('textos e unidades em inglês', () {
      expect(Unit.un.label(_en), 'pc');
      expect(Unit.kg.label(_en), 'kg');
      expect(ListMode.shopping.label(_en), 'Shopping');
      expect(_en.itemCount(1), '1 item');
      expect(_en.itemCount(3), '3 items');
      expect(
        const BudgetStatus(referenceCents: 1, budgetCents: 0).percentLabel(_en),
        'Over budget',
      );
    });

    test('lista e item sem nome usam o nome traduzido', () {
      final list = ListInput(
        defaultName: (date) => _en.defaultListName(formatDate(date)),
      ).toNewList(_now);
      expect(list.name, 'List 21/10/2026');
      final input = ItemInput(defaultName: _en.unnamedItem);
      expect(input.effectiveName, 'Unnamed item');
      expect(input.hasName, isFalse);
    });
  });
}
