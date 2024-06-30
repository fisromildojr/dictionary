import 'dart:developer';

import 'package:dictionary/modules/entries/controllers/cache_controller.dart';
import 'package:dictionary/modules/entries/controllers/entry_controller.dart';
import 'package:dictionary/modules/entries/models/entry_model.dart';
import 'package:dictionary/modules/entries/services/entry_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FavoriteController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final currentPage = 0.obs;
  final lengthPage = 20.obs;
  final isLoadingPage = false.obs;
  final entries = <Entry>[].obs;
  final hasMoreItems = true.obs;

  @override
  void onInit() {
    findFavoritePaginated();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        findFavoritePaginated();
      }
    });
    ever(entries, (_) {
      if (_.length % lengthPage.value == 0) {
        hasMoreItems(true);
      }
    });
    super.onInit();
  }

  void reload() {
    currentPage(0);
    entries.clear();
    hasMoreItems(true);
    findFavoritePaginated();
  }

  Future<void> findFavoritePaginated() async {
    if (!isLoadingPage.value && hasMoreItems.value) {
      try {
        isLoadingPage(true);
        var newEntries = await EntryService()
            .findFavoritePaginated(currentPage.value, lengthPage.value);

        if (newEntries.length < lengthPage.value) {
          hasMoreItems(false);
        } else {
          currentPage.value++;
        }

        entries.addAll(newEntries);
      } catch (e) {
        log(e.toString());
      } finally {
        isLoadingPage(false);
      }
    }
  }

  Future<void> toggleFavorite(Entry entry) async {
    await EntryService().toggleFavorite(entry);

    Get.find<EntryController>().update();
    Get.find<CacheController>().update();

    update();
  }

  bool isFavorite(int entryId) {
    return entries.any((entry) => entry.id == entryId);
  }
}
