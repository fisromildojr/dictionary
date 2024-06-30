import 'dart:convert';

import 'package:dictionary/database/database.dart';
import 'package:dictionary/modules/entries/controllers/favorite_controller.dart';
import 'package:dictionary/modules/entries/models/entry_model.dart';
import 'package:dictionary/storage/app_storage.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';

class EntryRepository {
  DatabaseHelper databaseHelper = DatabaseHelper();

  Future<int> save(Entry entry) async {
    final db = await databaseHelper.database;
    try {
      return await db.insert('entries', entry.toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Entry>> findAllPaginated(int currentPage, int lengthPage) async {
    final db = await databaseHelper.database;
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        'entries',
        limit: lengthPage,
        offset: currentPage * lengthPage, // Corrigido o offset
      );

      return List.generate(maps.length, (i) {
        return Entry.fromJson(maps[i]);
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<int> updateEntry(Entry entry) async {
    final db = await databaseHelper.database;
    try {
      return await db.update('entries', entry.toJson(),
          where: 'id = ?', whereArgs: [entry.id]);
    } catch (e) {
      rethrow;
    }
  }

  Future<int> deleteEntry(int id) async {
    final db = await databaseHelper.database;
    try {
      return await db.delete('entries', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> findCache(String word) async {
    final db = await databaseHelper.database;
    final int userId = AppStorage.instance.user?.id ?? 0;
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        'cache',
        where: 'word = ? AND user_id = ?',
        whereArgs: [word, userId],
      );

      if (maps.isNotEmpty) {
        return maps.first['response'];
      } else {
        return null;
      }
    } catch (e) {
      rethrow;
    }
  }

  void saveCache(String word, String response) async {
    final db = await databaseHelper.database;
    final int userId = AppStorage.instance.user?.id ?? 0;
    try {
      await db.insert(
          'cache',
          {
            'word': word,
            'response': response,
            'user_id': userId,
          },
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Entry>> findCachePaginated(
      int currentPage, int lengthPage) async {
    final db = await databaseHelper.database;
    final int userId = AppStorage.instance.user?.id ?? 0;
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        'cache',
        limit: lengthPage,
        offset: currentPage * lengthPage,
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'created_at DESC',
      );

      return List.generate(maps.length, (i) {
        return Entry.fromJson(jsonDecode(maps[i]['response'])[0]);
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Entry>> findFavoritePaginated(
      int currentPage, int lengthPage) async {
    final db = await databaseHelper.database;
    final int userId = AppStorage.instance.user?.id ?? 0;
    try {
      final List<Map<String, dynamic>> maps = await db.rawQuery('''
    SELECT entries.* FROM entries
    INNER JOIN favorites ON entries.id = favorites.entry_id
    WHERE favorites.user_id = ?
    ORDER BY favorites.created_at DESC
    LIMIT ? OFFSET ?
  ''', [userId, lengthPage, currentPage * lengthPage]);

      return List.generate(maps.length, (i) {
        return Entry.fromJson(maps[i]);
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> toggleFavorite(Entry entry) async {
    final db = await databaseHelper.database;
    final int userId = AppStorage.instance.user?.id ?? 0;
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        'favorites',
        where: 'entry_id = ? AND user_id = ?',
        whereArgs: [entry.id, userId],
        limit: 1,
      );

      if (maps.isNotEmpty) {
        await db.delete(
          'favorites',
          where: 'id = ?',
          whereArgs: [maps.first['id']],
        );
        Get.find<FavoriteController>()
            .entries
            .removeWhere((e) => e.id == entry.id);
      } else {
        await db.insert('favorites', {
          'entry_id': entry.id,
          'user_id': userId,
        });
        Get.find<FavoriteController>().entries.insert(0, entry);
        Get.find<FavoriteController>().hasMoreItems(true);
      }
    } catch (e) {
      rethrow;
    }
  }
}
