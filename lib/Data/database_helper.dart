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
        await db.execute('''
          CREATE TABLE activities(
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            single INTEGER NOT NULL,
            source TEXT NOT NULL,
            source_type TEXT NOT NULL
          );

          CREATE TABLE commutes(
            id INTEGER PRIMARY KEY,
            name TEXT NOT NULL,
            start_minute INT NOT NULL,
            end_minute INT NOT NULL
          );

          
          CREATE TABLE activity_commute(
            activity_id INTEGER NOT NULL,
            commute_id INTEGER NOT NULL,
            PRIMARY KEY (activity_id, commute_id),
            FOREIGN KEY (activity_id) REFERENCES activities(id),
            FOREIGN KEY (commute_id) REFERENCES commutes(id)
          );

          CREATE TABLE day_commutes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            day INTEGER NOT NULL,
            commute_id INTEGER NOT NULL,
            start_minute INTEGER NOT NULL,
            end_minute INTEGER NOT NULL,

            FOREIGN KEY (commute_id) REFERENCES commutes(id),

            CHECK(start_minute < end_minute)
        );

        ''');
      },
    );
  }
}
