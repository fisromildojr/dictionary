import 'dart:developer';

import 'package:dictionary/modules/entries/models/entry_model.dart';
import 'package:dictionary/modules/entries/services/entry_service.dart';
import 'package:dictionary/routes/route_names.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CacheController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final currentPage = 0.obs;
  final lengthPage = 20.obs;
  final isLoadingPage = false.obs;
  final entries = <Entry>[].obs;

  @override
  void onInit() {
    findCachePaginated();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        findCachePaginated();
      }
    });
    super.onInit();
  }

  void reload() {
    currentPage(0);
    entries.clear();
    findCachePaginated();
  }

  Future<void> findCachePaginated() async {
    try {
      isLoadingPage(true);
      var newEntries = await EntryService()
          .findCachePaginated(currentPage.value, lengthPage.value);
      currentPage.value++;
      entries.addAll(newEntries);
    } catch (e) {
      log(e.toString());
    } finally {
      isLoadingPage(false);
    }
  }

  showDetails(Entry entry) async {
    var entryDB = await EntryService().findWord(entry.word!);
    inspect(entryDB);
    Get.toNamed(RouteEntryDetailsPage, arguments: entryDB);
  }
}
