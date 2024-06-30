import 'dart:developer';

import 'package:dictionary/modules/entries/models/entry_model.dart';
import 'package:dictionary/modules/entries/services/entry_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CacheController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final currentPage = 0.obs;
  final lengthPage = 20.obs;
  final isLoadingPage = false.obs;
  final entries = <Entry>[].obs;
  final hasMoreItems = true.obs;

  @override
  void onInit() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        findCachePaginated();
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
    findCachePaginated();
  }

  Future<void> findCachePaginated() async {
    if (!isLoadingPage.value && hasMoreItems.value) {
      try {
        isLoadingPage(true);
        var newEntries = await EntryService()
            .findCachePaginated(currentPage.value, lengthPage.value);

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
}
