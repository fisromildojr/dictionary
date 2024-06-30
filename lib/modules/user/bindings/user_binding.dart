import 'package:dictionary/modules/user/controllers/user_controller.dart';
import 'package:dictionary/modules/user/repositories/user_repository.dart';
import 'package:dictionary/modules/user/services/user_service.dart';
import 'package:get/get.dart';

class UserBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserRepository());
    Get.lazyPut(() => UserService(Get.find()));
    Get.lazyPut(() => UserController(Get.find()));
  }
}
