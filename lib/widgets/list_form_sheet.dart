import 'package:flutter/material.dart';

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
  late ListMode _mode = widget.initial?.mode ?? ListMode.planning;

  bool get _isEditing => widget.initial != null;

  @override
  void dispose() {
    _name.dispose();
    _store.dispose();
    _budget.dispose();
    super.dispose();
  }

  void _submit() {
    Navigator.of(context).pop(
      ListInput(
        name: _name.text,
        store: _store.text,
        budgetCents: parseMoney(_budget.text),
        mode: _mode,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SheetScaffold(
      title: _isEditing ? 'Editar lista' : 'Nova lista',
      children: [
        TextField(
          controller: _name,
          autofocus: !_isEditing,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'Nome da lista',
            hintText: 'Ex.: Compra do mês',
          ),
        ),
        TextField(
          controller: _store,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'Supermercado (opcional)',
          ),
        ),
        TextField(
          controller: _budget,
          keyboardType: TextInputType.number,
          inputFormatters: [MoneyInputFormatter()],
          decoration: const InputDecoration(
            labelText: 'Orçamento (opcional)',
            hintText: r'R$ 0,00',
          ),
        ),
        if (!_isEditing) ...[
          Text(
            'Como você vai usar esta lista?',
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
                title: 'Vou planejar',
                description: 'Monto antes e marco "já peguei" no mercado',
                selected: _mode == ListMode.planning,
                onTap: () => setState(() => _mode = ListMode.planning),
              ),
              _ModeOption(
                title: 'Já estou comprando',
                description: 'Cada item entra como pego',
                selected: _mode == ListMode.shopping,
                onTap: () => setState(() => _mode = ListMode.shopping),
              ),
            ],
          ),
        ],
        FilledButton(
          onPressed: _submit,
          child: Text(_isEditing ? 'Salvar' : 'Criar lista'),
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
