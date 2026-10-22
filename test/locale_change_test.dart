import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:somou/data/app_database.dart';
import 'package:somou/data/shopping_list_repository.dart';
import 'package:somou/main.dart';
import 'package:somou/models/form_inputs.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();

  testWidgets('trocar o idioma com o app aberto', (tester) async {
    await initializeDateFormatting();
    final db = await tester.runAsync(
      () => AppDatabase.open(
        factory: databaseFactoryFfi,
        path: inMemoryDatabasePath,
      ),
    );
    await tester.runAsync(
      () => ShoppingListRepository(db!).insert(
        const ListInput(name: 'Feira', budgetCents: 10000)
            .toNewList(DateTime(2026, 10, 21)),
      ),
    );
    tester.platformDispatcher.localesTestValue = const [Locale('pt', 'BR')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);

    await tester.pumpWidget(SomouApp(database: db!));
    await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 200)));
    await tester.pumpAndSettle();
    expect(find.text('Suas listas'), findsOneWidget);

    tester.platformDispatcher.localesTestValue = const [Locale('en', 'US')];
    await tester.pumpAndSettle();
    expect(find.text('Your lists'), findsOneWidget);

    tester.platformDispatcher.localesTestValue = const [Locale('pt', 'BR')];
    await tester.pumpAndSettle();
    expect(find.text('Suas listas'), findsOneWidget);

    await tester.runAsync(db.close);
  });
}
