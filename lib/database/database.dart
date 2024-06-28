import 'dart:convert';
import 'dart:developer';

import 'package:dictionary/modules/entries/controllers/entry_controller.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
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
        user_id INTEGER,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        UNIQUE(word)
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

    await _insertInitialData(db);
  }

  Future<void> _insertInitialData(Database db) async {
    try {
      final entryController = Get.find<EntryController>();
      entryController.isLoadingSync(true);
      final String response =
          await rootBundle.loadString('assets/words_dictionary.json');
      final Map<String, dynamic> data = json.decode(response);
      final int totalEntries = data.length;
      int insertedEntries = 0;

      for (var entry in data.entries.take(20)) {
        log('Inserindo entrada: ${entry.key}');
        await db.insert('entries', {'word': entry.key});
        insertedEntries++;
        entryController.progressSync((insertedEntries / totalEntries) * 100);
      }

      entryController.isLoadingSync(false);

      _insertRemainingEntries(db, data, 20, totalEntries, entryController);
    } catch (e) {
    } finally {
      Get.find<EntryController>().isLoadingSync(false);
    }
  }

  Future<void> _insertRemainingEntries(Database db, Map<String, dynamic> data,
      int start, int totalEntries, EntryController entryController) async {
    for (var i = start; i < data.length; i++) {
      var entry = data.entries.elementAt(i);
      await db.insert('entries', {'word': entry.key});
      entryController.progressSync(((i + 1) / totalEntries) * 100);
    }
  }
}
