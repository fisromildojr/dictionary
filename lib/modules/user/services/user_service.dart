import 'package:dictionary/modules/user/models/user_model.dart';
import 'package:dictionary/modules/user/repositories/user_repository.dart';
import 'package:dictionary/modules/user/services/crypto_service.dart';
import 'package:dictionary/storage/app_storage.dart';

class UserService {
  Future<User?> save(User user) async {
    try {
      user.password = CryptoService.encrypt(user.password!);
      User? newUser = await UserRepository().save(user);
      if (newUser != null) {
        AppStorage.instance.setUser(user);
      }
      return newUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> login(String login, String password) async {
    try {
      User? loggedUser =
          await UserRepository().login(login, CryptoService.encrypt(password));
      if (loggedUser != null) {
        AppStorage.instance.setUser(loggedUser);
        return true;
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }
}
