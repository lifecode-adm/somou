import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../models/form_inputs.dart';
import '../models/list_mode.dart';
import '../models/shopping_list.dart';
import '../theme/app_theme.dart';
import '../utils/formatters.dart';
import 'sheet_scaffold.dart';

/// RF01 e RF03: cria a lista, ou edita uma existente quando [initial] vem.
Future<ListInput?> showListFormSheet(
  BuildContext context, {
  ShoppingList? initial,
}) => showModalBottomSheet<ListInput>(
  context: context,
  isScrollControlled: true,
  useSafeArea: true,
  builder: (_) => ListFormSheet(initial: initial),
);

class ListFormSheet extends StatefulWidget {
  const ListFormSheet({super.key, this.initial});

  final ShoppingList? initial;

  @override
  State<ListFormSheet> createState() => _ListFormSheetState();
}

class _ListFormSheetState extends State<ListFormSheet> {
  late final _name = TextEditingController(text: widget.initial?.name);
  late final _store = TextEditingController(text: widget.initial?.store);
  late final _budget = TextEditingController(
    text: switch (widget.initial?.budgetCents) {
      final cents? when cents > 0 => formatMoney(cents),
      _ => '',
    },
  );
  late ListMode _mode = widget.initial?.mode ?? ListMode.shopping;

  bool get _isEditing => widget.initial != null;

  @override
  void dispose() {
    _name.dispose();
    _store.dispose();
    _budget.dispose();
    super.dispose();
  }

  void _submit() {
    final l10n = context.l10n;
    Navigator.of(context).pop(
      ListInput(
        name: _name.text,
        store: _store.text,
        budgetCents: parseMoney(_budget.text),
        mode: _mode,
        defaultName: (date) => l10n.defaultListName(formatDate(date)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return SheetScaffold(
      title: _isEditing ? l10n.editList : l10n.newList,
      children: [
        TextField(
          controller: _name,
          autofocus: !_isEditing,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            labelText: l10n.listName,
            hintText: l10n.listNameHint,
          ),
        ),
        TextField(
          controller: _store,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(labelText: l10n.storeOptional),
        ),
        TextField(
          controller: _budget,
          keyboardType: TextInputType.number,
          inputFormatters: [MoneyInputFormatter()],
          decoration: InputDecoration(
            labelText: l10n.budgetOptional,
            hintText: formatMoney(0),
          ),
        ),
        if (!_isEditing) ...[
          Text(
            l10n.modeQuestion,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: context.colors.textMuted,
            ),
          ),
          Row(
            spacing: 12,
            children: [
              _ModeOption(
                title: l10n.modeShoppingOption,
                description: l10n.modeShoppingDescription,
                selected: _mode == ListMode.shopping,
                onTap: () => setState(() => _mode = ListMode.shopping),
              ),
              _ModeOption(
                title: l10n.modePlanningOption,
                description: l10n.modePlanningDescription,
                selected: _mode == ListMode.planning,
                onTap: () => setState(() => _mode = ListMode.planning),
              ),
            ],
          ),
        ],
        FilledButton(
          onPressed: _submit,
          child: Text(_isEditing ? l10n.save : l10n.createList),
        ),
      ],
    );
  }
}

class _ModeOption extends StatelessWidget {
  const _ModeOption({
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final colors = context.colors;
    return Expanded(
      child: Semantics(
        selected: selected,
        button: true,
        child: Material(
          color: selected ? colors.primaryContainer : scheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(
              color: selected ? scheme.primary : scheme.outline,
              width: selected ? 2 : 1,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 12,
                      height: 16 / 12,
                      color: colors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
