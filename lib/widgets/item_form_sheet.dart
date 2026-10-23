import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../models/form_inputs.dart';
import '../models/list_item.dart';
import '../models/product_history.dart';
import '../models/unit.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import 'sheet_scaffold.dart';

typedef ProductSearch = Future<List<ProductHistory>> Function(String query);

/// RF07–RF10: adiciona um item, ou edita um existente quando [initial] vem.
Future<ItemInput?> showItemFormSheet(
  BuildContext context, {
  required ProductSearch search,
  ListItem? initial,
}) => showModalBottomSheet<ItemInput>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (_) => ItemFormSheet(search: search, initial: initial),
);

class ItemFormSheet extends StatefulWidget {
  const ItemFormSheet({super.key, required this.search, this.initial});

  final ProductSearch search;
  final ListItem? initial;

  @override
  State<ItemFormSheet> createState() => _ItemFormSheetState();
}

class _ItemFormSheetState extends State<ItemFormSheet> {
  late final _name = TextEditingController(text: widget.initial?.name);
  late final _brand = TextEditingController(text: widget.initial?.brand);
  late final _quantity = TextEditingController(
    text: switch (widget.initial) {
      final item? => formatQuantityInput(item.quantity),
      null => '',
    },
  );
  late final _price = TextEditingController(
    text: switch (widget.initial?.unitPriceCents) {
      final cents? when cents > 0 => formatMoney(cents),
      _ => '',
    },
  );
  late Unit _unit = widget.initial?.unit ?? Unit.un;
  final _nameFocus = FocusNode();
  final _quantityFocus = FocusNode();

  List<ProductHistory> _suggestions = const [];
  bool _filledFromHistory = false;
  int _searchId = 0;

  bool get _isEditing => widget.initial != null;

  @override
  void initState() {
    super.initState();
    _nameFocus.addListener(() {
      if (!_nameFocus.hasFocus) setState(() => _suggestions = const []);
    });
  }

  @override
  void dispose() {
    for (final controller in [_name, _brand, _quantity, _price]) {
      controller.dispose();
    }
    _nameFocus.dispose();
    _quantityFocus.dispose();
    super.dispose();
  }

  ItemInput get _input => ItemInput(
    name: _name.text,
    brand: _brand.text,
    quantity: parseQuantity(_quantity.text),
    unit: _unit,
    unitPriceCents: parseMoney(_price.text),
    defaultName: context.l10n.unnamedItem,
  );

  /// Ignora respostas que chegam depois de uma busca mais nova.
  Future<void> _onNameChanged(String text) async {
    final id = ++_searchId;
    setState(() => _filledFromHistory = false);
    final results = text.trim().isEmpty
        ? const <ProductHistory>[]
        : await widget.search(text);
    if (!mounted || id != _searchId) return;
    setState(() => _suggestions = results);
  }

  /// RF09: preenche com o último registro do produto.
  void _pick(ProductHistory product) {
    _searchId++;
    setState(() {
      _name.text = product.name;
      _brand.text = product.brand ?? '';
      _quantity.text = formatQuantityInput(product.quantity);
      _unit = product.unit;
      _price.text = product.unitPriceCents > 0
          ? formatMoney(product.unitPriceCents)
          : '';
      _suggestions = const [];
      _filledFromHistory = true;
    });
    _quantityFocus.requestFocus();
    _quantity.selection = TextSelection(
      baseOffset: 0,
      extentOffset: _quantity.text.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final input = _input;
    return SheetScaffold(
      title: _isEditing ? l10n.editItem : l10n.addItem,
      children: [
        TextField(
          controller: _name,
          focusNode: _nameFocus,
          autofocus: !_isEditing,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.next,
          onChanged: _onNameChanged,
          decoration: InputDecoration(
            labelText: l10n.product,
            hintText: l10n.productHint,
          ),
        ),
        if (_suggestions.isNotEmpty)
          _Suggestions(
            query: _name.text,
            products: _suggestions,
            onPick: _pick,
          ),
        if (_filledFromHistory)
          Row(
            spacing: 6,
            children: [
              Icon(
                Icons.history,
                size: 14,
                color: Theme.of(context).colorScheme.primary,
              ),
              Text(
                l10n.filledFromHistory,
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        TextField(
          controller: _brand,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: l10n.brandOptional,
            hintText: l10n.brandHint,
          ),
        ),
        Row(
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TextField(
                controller: _quantity,
                focusNode: _quantityFocus,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [QuantityInputFormatter()],
                textInputAction: TextInputAction.next,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  labelText: l10n.quantity,
                  hintText: '1',
                ),
              ),
            ),
            Expanded(
              child: DropdownButtonFormField<Unit>(
                initialValue: _unit,
                decoration: InputDecoration(labelText: l10n.unit),
                items: [
                  for (final unit in Unit.values)
                    DropdownMenuItem(
                      value: unit,
                      child: Text(unit.label(l10n)),
                    ),
                ],
                onChanged: (unit) => setState(() => _unit = unit ?? _unit),
              ),
            ),
          ],
        ),
        TextField(
          controller: _price,
          keyboardType: TextInputType.number,
          inputFormatters: [MoneyInputFormatter()],
          onChanged: (_) => setState(() {}),
          decoration: InputDecoration(
            labelText: l10n.unitPrice,
            hintText: formatMoney(0),
          ),
        ),
        // RF08: subtotal ao vivo, antes de confirmar.
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: colors.primaryContainer,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.subtotal,
                      style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      '${formatQuantity(input.effectiveQuantity)} × '
                      '${formatMoney(input.effectiveUnitPriceCents)}',
                      style: TextStyle(fontSize: 13, color: colors.textMuted),
                    ),
                  ],
                ),
              ),
              Text(
                formatMoney(input.subtotalCents),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        FilledButton(
          // Lê os campos na hora do toque: a marca não redesenha a tela ao
          // mudar, então o `input` do último build pode estar desatualizado.
          onPressed: () => Navigator.of(context).pop(_input),
          child: Text(_isEditing ? l10n.save : l10n.add),
        ),
      ],
    );
  }
}

class _Suggestions extends StatelessWidget {
  const _Suggestions({
    required this.query,
    required this.products,
    required this.onPick,
  });

  final String query;
  final List<ProductHistory> products;
  final ValueChanged<ProductHistory> onPick;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (final (index, product) in products.indexed)
            InkWell(
              onTap: () => onPick(product),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  border: index == products.length - 1
                      ? null
                      : Border(bottom: BorderSide(color: colors.border)),
                ),
                child: Row(
                  spacing: 10,
                  children: [
                    Icon(Icons.history, size: 18, color: colors.textMuted),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(fontSize: 15),
                          ),
                          Text(
                            [
                              ?product.brand,
                              '${formatQuantity(product.quantity)} '
                                  '${product.unit.label(l10n)}',
                              formatMoney(product.unitPriceCents),
                            ].join(' · '),
                            style: TextStyle(
                              fontSize: 12,
                              color: colors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
