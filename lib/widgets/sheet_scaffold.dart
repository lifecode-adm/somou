import 'package:flutter/material.dart';

/// Moldura comum dos bottom sheets: título, campos e espaço do teclado e da
/// barra de navegação do sistema.
class SheetScaffold extends StatelessWidget {
  const SheetScaffold({super.key, required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    // Com o teclado aberto o padding da barra vira zero, então não soma duas vezes.
    final navigationBar = MediaQuery.paddingOf(context).bottom;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 24 + keyboard + navigationBar),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        spacing: 14,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          ...children,
        ],
      ),
    );
  }
}
