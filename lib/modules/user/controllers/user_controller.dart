import 'dart:developer';

import 'package:dictionary/modules/entries/controllers/cache_controller.dart';
import 'package:dictionary/modules/entries/controllers/entry_controller.dart';
import 'package:dictionary/modules/entries/controllers/favorite_controller.dart';
import 'package:dictionary/modules/user/models/user_model.dart';
import 'package:dictionary/modules/user/services/user_service.dart';
import 'package:dictionary/routes/route_names.dart';
import 'package:dictionary/storage/app_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserController extends GetxController {
  final UserService _service;
  UserController(this._service);

  final formMode = 'Login'.obs;
  final isLoading = false.obs;
  final nameController = TextEditingController();
  final loginController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> register(GlobalKey<FormState> formKey) async {
    try {
      if (formKey.currentState?.validate() ?? false) {
        isLoading(true);
        User user = User(
          name: nameController.text,
          login: loginController.text,
          password: passwordController.text,
        );
        User? newUser = await _service.save(user);
        if (newUser != null) {
          Get.offAllNamed(RouteHomePage);
        }
      }
    } catch (e) {
      log(e.toString());
      Get.showSnackbar(GetSnackBar(
        title: 'Error',
        message: e.toString(),
      ));
    } finally {
      isLoading(false);
    }
  }

  Future<void> login(GlobalKey<FormState> formKey) async {
    try {
      isLoading(true);
      if (formKey.currentState?.validate() ?? false) {
        if (await _service.login(
            loginController.text, passwordController.text)) {
          Get.offAllNamed(RouteHomePage);
        }
      }
    } catch (e) {
      log(e.toString());
      Get.showSnackbar(GetSnackBar(
        duration: const Duration(seconds: 3),
        title: 'Error',
        message: e.toString(),
      ));
    } finally {
      isLoading(false);
    }
  }

  Future<void> logout() async {
    try {
      isLoading(true);
      AppStorage.instance.setUser(null);
      Get.offAllNamed(RouteLoginPage);
      Get.find<EntryController>().entries.clear();
      Get.find<CacheController>().entries.clear();
      Get.find<FavoriteController>().entries.clear();
    } catch (e) {
      log(e.toString());
    } finally {
      isLoading(false);
    }
  }
}
