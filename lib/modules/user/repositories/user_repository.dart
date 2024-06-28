import 'package:dictionary/database/database.dart';
import 'package:dictionary/modules/user/models/user_model.dart';
import 'package:sqflite/sqflite.dart';

class UserRepository {
  DatabaseHelper databaseHelper = DatabaseHelper();

  Future<User?> save(User user) async {
    try {
      final db = await databaseHelper.database;
      await db.transaction((txn) async {
        int id = await txn.insert('users', user.toJson(),
            conflictAlgorithm: ConflictAlgorithm.abort);
        return findById(id);
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> login(String login, String password) async {
    try {
      final db = await databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'users',
        where: 'login = ? AND password = ?',
        limit: 1,
        whereArgs: [login, password],
      );

      return maps.isNotEmpty
          ? User.fromJson(maps[0])
          : throw Exception(
              ['Login or Password not found...'],
            );
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> findById(int id) async {
    final db = await databaseHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    } else {
      return null;
    }
  }
}