import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "routelearn.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, verison) async {
        await db.execute('PRAGMA foreign_keys = ON');
        await db.execute('''
            CREATE TABLE activities(
                id INTEGER PRIMARY KEY,
                name TEXT NOT NULL,
                single INTEGER NOT NULL,
                source TEXT NOT NULL,
                source_type TEXT NOT NULL
            );

        ''');

        await db.execute('''
          CREATE TABLE commutes(
              id INTEGER PRIMARY KEY,
              name TEXT NOT NULL,
              start_minute INTEGER NOT NULL,
              end_minute INTEGER NOT NULL,
              CHECK(start_minute < end_minute)
          );
        ''');

        await db.execute('''
        CREATE TABLE day_commutes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            commute_id INTEGER NOT NULL,
            day INTEGER NOT NULL,
            activity_id INTEGER NOT NULL,

            FOREIGN KEY(commute_id) REFERENCES commutes(id),
            FOREIGN KEY(activity_id) REFERENCES activities(id),

            UNIQUE(commute_id, day)
          );
          ''');
      },
    );
  }

  Future<int> insert(Map<String, Object?> values, String table) async {
    final db = await database;
    return await db.insert(table, values);
  }

  Future<int> update(
    Map<String, Object?> values,
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final db = await database;
    return await db.update(table, values, where: where, whereArgs: whereArgs);
  }

  Future<int> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final db = await database;
    return db.delete(table, where: where, whereArgs: whereArgs);
  }

  Future<List<Map<String, Object?>>> query(
    String table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) async {
    final db = await database;
    return db.query(
      table,
      distinct: distinct,
      columns: columns,
      where: where,
      whereArgs: whereArgs,
      groupBy: groupBy,
      having: having,
      orderBy: orderBy,
      limit: limit,
      offset: offset,
    );
  }
}
