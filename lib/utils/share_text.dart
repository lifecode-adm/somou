import '../l10n/l10n.dart';
import '../models/list_item.dart';
import '../models/list_mode.dart';
import '../models/list_totals.dart';
import '../models/shopping_list.dart';
import 'formatters.dart';

const _divider = '━━━━━━━━━━━━';

/// Texto da lista para o WhatsApp (RF06).
String buildShareText(
  ShoppingList list,
  List<ListItem> items,
  AppLocalizations l10n,
) {
  final totals = ListTotals.fromItems(items);
  final store = list.store;
  final picked = items.where((item) => item.picked).length;
  final lines = <String>[
    '🛒 ${list.name}${store == null ? '' : ' — $store'}',
    _divider,
    for (final item in items) _itemLine(item, l10n),
    _divider,
    l10n.shareSummary(totals.itemCount, formatQuantity(totals.productCount)),
    // No Planejamento, quem recebe precisa saber quanto já foi pego e quanto
    // falta; Em compra tudo já está no carrinho e o total basta.
    if (list.mode == ListMode.planning) ...[
      '✅ ${l10n.shareInCart(formatMoney(totals.cartCents), picked)}',
      '⬜ ${l10n.shareRemaining(formatMoney(totals.totalCents - totals.cartCents), totals.itemCount - picked)}',
    ],
    l10n.shareTotal(formatMoney(totals.totalCents)),
  ];
  return lines.join('\n');
}

String _itemLine(ListItem item, AppLocalizations l10n) {
  final check = item.picked ? '✅' : '⬜';
  final brand = item.brand == null ? '' : ' (${item.brand})';
  return '$check ${formatQuantity(item.quantity)} ${item.unit.label(l10n)} '
      '${item.name}$brand — ${formatMoney(item.subtotalCents)}';
}

Uri whatsAppUri(String text) => Uri.https('wa.me', '/', {'text': text});
