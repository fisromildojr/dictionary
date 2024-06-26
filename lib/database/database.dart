import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'dictionary.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        entry TEXT NOT NULL,
        phonetics TEXT,
        meanings TEXT,
        etymology TEXT,
        examples TEXT,
        synonyms TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    ''');
    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        entry_id INTEGER NOT NULL,
        user_id INTEGER,
        FOREIGN KEY (entry_id) REFERENCES entries (id),
        FOREIGN KEY (user_id) REFERENCES users (id),
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    ''');
    await db.execute('''
      CREATE TABLE cache (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        entry TEXT NOT NULL,
        response TEXT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        UNIQUE(entry)
      );
    ''');
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    ''');
  }
}
