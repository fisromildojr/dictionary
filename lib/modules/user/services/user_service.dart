import 'package:dictionary/modules/user/models/user_model.dart';
import 'package:dictionary/modules/user/repositories/user_repository.dart';
import 'package:dictionary/modules/user/services/crypto_service.dart';
import 'package:dictionary/storage/app_storage.dart';

class UserService {
  UserRepository _repository = UserRepository();
  UserService(this._repository);
  Future<User?> save(User user) async {
    try {
      user.password = CryptoService.encrypt(user.password!);
      User? newUser = await _repository.save(user);
      if (newUser != null) {
        AppStorage.instance.setUser(newUser);
      }
      return newUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> login(String login, String password) async {
    try {
      User? loggedUser =
          await _repository.login(login, CryptoService.encrypt(password));
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
