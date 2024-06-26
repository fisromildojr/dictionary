import 'package:dictionary/modules/entries/controllers/entry_controller.dart';
import 'package:get/get.dart';

class EntryBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EntryController());
  }
}