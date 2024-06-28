// ignore_for_file: file_names
import 'dart:convert';

import 'package:dictionary/modules/user/models/user_model.dart';
import 'package:get_storage/get_storage.dart';

class AppStorage {
  AppStorage._internal();
  static final AppStorage instance = AppStorage._internal();
  factory AppStorage() {
    return instance;
  }

  final _storage = GetStorage();

  User? get user => _storage.read('user') == null || _storage.read('user') == ''
      ? null
      : User.fromJson(jsonDecode(_storage.read('user')));

  void setUser(User? user) => (user == null)
      ? _storage.remove('user')
      : _storage.write('user', jsonEncode(user.toJson()));
}
