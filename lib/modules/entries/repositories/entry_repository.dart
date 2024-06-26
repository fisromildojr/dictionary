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

  Future<List<Entry>> findAll() async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('entries');

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
}
