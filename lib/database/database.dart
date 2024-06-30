import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

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
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final db = await openDatabase(
      join(await getDatabasesPath(), 'dictionary.db'),
      onCreate: _onCreate,
      onOpen: (db) {
        log('Database opened...');
      },
      version: 1,
    );
    return db;
  }

  Future<void> _onCreate(Database db, int version) async {
    log('Creating database...');
    await db.execute('''
      CREATE TABLE entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        word TEXT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    ''');

    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        entry_id INTEGER NOT NULL,
        user_id INTEGER NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (entry_id) REFERENCES entries (id),
        FOREIGN KEY (user_id) REFERENCES users (id)
      );
    ''');
    await db.execute('''
      CREATE TABLE cache (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        word TEXT NOT NULL,
        response TEXT NOT NULL,
        user_id INTEGER NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        UNIQUE(word),
        FOREIGN KEY (user_id) REFERENCES users (id)
      );
    ''');
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        login TEXT NOT NULL UNIQUE,
        password TEXT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    ''');

    _insertData();
  }

  static Future<void> _insertData() async {
    final db = await DatabaseHelper().database;
    final String response =
        await rootBundle.loadString('assets/words_dictionary.json');
    final Map<String, dynamic> data = json.decode(response);

    try {
      for (var entry in data.entries) {
        await db.transaction((txn) async {
          await txn.insert('entries', {'word': entry.key});
        });
      }
    } catch (e) {
      log(e.toString());
    } finally {
      await db.close();
    }
  }
}
