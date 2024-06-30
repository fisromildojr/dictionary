import 'dart:developer';

import 'package:dictionary/modules/entries/models/entry_model.dart';
import 'package:dictionary/modules/entries/services/entry_service.dart';
import 'package:dictionary/routes/route_names.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EntryController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final currentPage = 0.obs;
  final lengthPage = 20.obs;
  final isLoadingSync = false.obs;
  final progressSync = 0.0.obs;
  final isLoadingButtonSearch = false.obs;
  final isLoadingPage = false.obs;
  final entries = <Entry>[].obs;
  final hasMoreItems = true.obs;

  @override
  void onInit() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        findAllPaginated();
      }
    });
    super.onInit();
  }

  void reload() {
    currentPage(0);
    entries.clear();
    findAllPaginated();
  }

  Future<Entry?> findWord(String word) async {
    try {
      isLoadingButtonSearch(true);
      return await EntryService().findWord(word);
    } catch (e) {
      log(e.toString());
      return null;
    } finally {
      isLoadingButtonSearch(false);
    }
  }

  Future<void> findAllPaginated() async {
    if (!isLoadingPage.value && hasMoreItems.value) {
      try {
        isLoadingPage(true);
        var newEntries = await EntryService()
            .findAllPaginated(currentPage.value, lengthPage.value);

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

  showDetails(Entry entry) async {
    Get.toNamed(RouteEntryDetailsPage, arguments: entry);
  }
}
