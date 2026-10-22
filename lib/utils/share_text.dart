import '../models/list_item.dart';
import '../models/list_totals.dart';
import '../models/shopping_list.dart';
import 'formatters.dart';

const _divider = '━━━━━━━━━━━━';

/// Texto da lista para o WhatsApp (RF06).
String buildShareText(ShoppingList list, List<ListItem> items) {
  final totals = ListTotals.fromItems(items);
  final store = list.store;
  final lines = <String>[
    '🛒 ${list.name}${store == null ? '' : ' — $store'}',
    _divider,
    for (final item in items) _itemLine(item),
    _divider,
    'Itens: ${totals.itemCount} · '
        'Produtos: ${formatQuantity(totals.productCount)}',
    'Total: ${formatMoney(totals.totalCents)}',
  ];
  return lines.join('\n');
}

String _itemLine(ListItem item) {
  final check = item.picked ? '✅' : '⬜';
  final brand = item.brand == null ? '' : ' (${item.brand})';
  return '$check ${formatQuantity(item.quantity)} ${item.unit.symbol} '
      '${item.name}$brand — ${formatMoney(item.subtotalCents)}';
}

Uri whatsAppUri(String text) => Uri.https('wa.me', '/', {'text': text});
