import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../l10n/l10n.dart';
import '../models/shopping_list.dart';
import '../theme/app_theme.dart';
import '../utils/share_text.dart';

/// RF04: confirma antes de excluir a lista e seus itens.
Future<bool> confirmDeleteList(BuildContext context, ShoppingList list) async {
  final l10n = context.l10n;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.deleteListTitle),
      content: Text(l10n.deleteListMessage(list.name)),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(foregroundColor: context.colors.danger),
          child: Text(l10n.delete),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}

/// RF06: abre o WhatsApp com o texto pronto.
Future<void> shareOnWhatsApp(BuildContext context, String text) async {
  final messenger = ScaffoldMessenger.of(context);
  final error = context.l10n.whatsAppError;
  final opened = await launchUrl(
    whatsAppUri(text),
    mode: LaunchMode.externalApplication,
  );
  if (!opened) {
    messenger.showSnackBar(SnackBar(content: Text(error)));
  }
}

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
