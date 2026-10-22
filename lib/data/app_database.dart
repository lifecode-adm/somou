import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Abre o banco local e cria as tabelas (versão 1).
class AppDatabase {
  AppDatabase._();

  static const _version = 1;
  static const _fileName = 'somou.db';

  static Future<Database> open({DatabaseFactory? factory, String? path}) async {
    final dbFactory = factory ?? databaseFactory;
    final dbPath =
        path ?? p.join(await dbFactory.getDatabasesPath(), _fileName);
    return dbFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: _version,
        onConfigure: _onConfigure,
        onCreate: _onCreate,
      ),
    );
  }

  /// Sem isso a exclusão em cascata dos itens não funciona.
  static Future<void> _onConfigure(Database db) =>
      db.execute('PRAGMA foreign_keys = ON');

  static Future<void> _onCreate(Database db, int version) async {
    final batch = db.batch()
      ..execute('''
        CREATE TABLE shopping_lists (
          id            INTEGER PRIMARY KEY AUTOINCREMENT,
          name          TEXT    NOT NULL,
          store         TEXT,
          mode          TEXT    NOT NULL CHECK (mode IN ('planning', 'shopping')),
          budget_cents  INTEGER CHECK (budget_cents >= 0),
          created_at    INTEGER NOT NULL,
          updated_at    INTEGER NOT NULL
        )
      ''')
      ..execute('''
        CREATE TABLE list_items (
          id                INTEGER PRIMARY KEY AUTOINCREMENT,
          list_id           INTEGER NOT NULL REFERENCES shopping_lists(id) ON DELETE CASCADE,
          name              TEXT    NOT NULL,
          brand             TEXT,
          quantity          REAL    NOT NULL DEFAULT 1 CHECK (quantity > 0),
          unit              TEXT    NOT NULL DEFAULT 'un'
                            CHECK (unit IN ('un', 'pct', 'kg', 'g', 'L', 'ml')),
          unit_price_cents  INTEGER NOT NULL DEFAULT 0 CHECK (unit_price_cents >= 0),
          picked            INTEGER NOT NULL DEFAULT 0 CHECK (picked IN (0, 1)),
          created_at        INTEGER NOT NULL,
          updated_at        INTEGER NOT NULL
        )
      ''')
      ..execute('CREATE INDEX idx_list_items_list_id ON list_items(list_id)')
      ..execute('''
        CREATE TABLE product_history (
          id                INTEGER PRIMARY KEY AUTOINCREMENT,
          name_key          TEXT    NOT NULL UNIQUE,
          name              TEXT    NOT NULL,
          brand             TEXT,
          quantity          REAL    NOT NULL,
          unit              TEXT    NOT NULL,
          unit_price_cents  INTEGER NOT NULL,
          last_used_at      INTEGER NOT NULL
        )
      ''');
    await batch.commit(noResult: true);
  }
}
