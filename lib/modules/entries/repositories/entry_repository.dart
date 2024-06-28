import 'dart:convert';

import 'package:dictionary/database/database.dart';
import 'package:dictionary/modules/entries/models/entry_model.dart';
import 'package:sqflite/sqflite.dart';

class EntryRepository {
  DatabaseHelper databaseHelper = DatabaseHelper();

  Future<int> save(Entry entry) async {
    final db = await databaseHelper.database;
    return await db.insert('entries', entry.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Entry>> findAllPaginated(int currentPage, int lengthPage) async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'entries',
      limit: lengthPage,
      offset: currentPage,
    );

    return List.generate(maps.length, (i) {
      return Entry.fromJson(maps[i]);
    });
  }

  Future<int> updateEntry(Entry entry) async {
    final db = await databaseHelper.database;
    return await db.update('entries', entry.toJson(),
        where: 'id = ?', whereArgs: [entry.id]);
  }

  Future<int> deleteEntry(int id) async {
    final db = await databaseHelper.database;
    return await db.delete('entries', where: 'id = ?', whereArgs: [id]);
  }

  Future<String?> findCache(String word) async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'cache',
      where: 'word = ?',
      whereArgs: [word],
    );

    if (maps.isNotEmpty) {
      return maps.first['response'];
    } else {
      return null;
    }
  }

  void saveCache(String word, String response) {
    databaseHelper.database.then((db) {
      db.insert(
          'cache',
          {
            'word': word,
            'response': response,
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
    });
  }

  Future<List<Entry>> findCachePaginated(
      int currentPage, int lengthPage) async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'cache',
      limit: lengthPage,
      offset: currentPage,
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) {
      return Entry.fromJson(jsonDecode(maps[i]['response'])[0]);
    });
  }

  Future<List<Entry>> findFavoritePaginated(
      int userId, int currentPage, int lengthPage) async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT entries.* FROM entries
      INNER JOIN favorites ON entries.id = favorites.entry_id
      WHERE favorites.user_id = ?
      LIMIT ? OFFSET ?
    ''', [userId, lengthPage, currentPage]);

    return List.generate(maps.length, (i) {
      return Entry.fromJson(maps[i]);
    });
  }
}
