import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import 'controllers/home_controller.dart';
import 'data/app_database.dart';
import 'data/list_item_repository.dart';
import 'data/product_history_repository.dart';
import 'data/shopping_list_repository.dart';
import 'l10n/l10n.dart';
import 'pages/home_page.dart';
import 'theme/app_theme.dart';
import 'utils/formatters.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  final database = await AppDatabase.open();
  runApp(SomouApp(database: database));
}

class SomouApp extends StatelessWidget {
  const SomouApp({super.key, required this.database});

  final Database database;

  @override
  Widget build(BuildContext context) {
    final history = ProductHistoryRepository(database);
    final lists = ShoppingListRepository(database);
    return MultiProvider(
      providers: [
        Provider.value(value: lists),
        Provider.value(value: history),
        Provider.value(value: ListItemRepository(database, history)),
        ChangeNotifierProvider(create: (_) => HomeController(lists)..load()),
      ],
      child: MaterialApp(
        title: 'Somou',
        debugShowCheckedModeBanner: false,
        theme: buildTheme(Brightness.light),
        darkTheme: buildTheme(Brightness.dark),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        // Chamado ao abrir e quando o usuário troca o idioma do aparelho.
        localeListResolutionCallback: (locales, _) {
          final device = locales?.firstOrNull;
          if (device != null) configureFormatters(device);
          return resolveAppLocale(device);
        },
        home: const HomePage(),
      ),
    );
  }
}
