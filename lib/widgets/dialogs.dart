import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/shopping_list.dart';
import '../theme/app_theme.dart';
import '../utils/share_text.dart';

/// RF04: confirma antes de excluir a lista e seus itens.
Future<bool> confirmDeleteList(BuildContext context, ShoppingList list) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Excluir lista?'),
      content: Text(
        '"${list.name}" e todos os itens dela serão apagados. '
        'Não dá para desfazer.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: TextButton.styleFrom(foregroundColor: context.colors.danger),
          child: const Text('Excluir'),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}

/// RF06: abre o WhatsApp com o texto pronto.
Future<void> shareOnWhatsApp(BuildContext context, String text) async {
  final messenger = ScaffoldMessenger.of(context);
  final opened = await launchUrl(
    whatsAppUri(text),
    mode: LaunchMode.externalApplication,
  );
  if (!opened) {
    messenger.showSnackBar(
      const SnackBar(content: Text('Não foi possível abrir o WhatsApp.')),
    );
  }
}

void showMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}
