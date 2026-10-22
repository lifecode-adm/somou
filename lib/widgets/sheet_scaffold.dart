import 'package:flutter/material.dart';

/// Moldura comum dos bottom sheets: título, campos e espaço do teclado.
class SheetScaffold extends StatelessWidget {
  const SheetScaffold({super.key, required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 24 + keyboard),
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
