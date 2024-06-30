import 'dart:convert';

import 'package:dictionary/modules/api/services/api_service.dart';
import 'package:dictionary/modules/entries/controllers/cache_controller.dart';
import 'package:dictionary/modules/entries/models/entry_model.dart';
import 'package:dictionary/modules/entries/repositories/entry_repository.dart';
import 'package:get/get.dart';

class EntryService {
  Future<Entry?> findWord(String word) async {
    var cache = await EntryRepository().findCache(word);
    if (cache != null) {
      return Entry.fromJson(jsonDecode(cache)[0]);
    }

    var response = await ApiService().findWord(word);
    return response.fold((l) {
      var error = jsonDecode(l);
      Get.showSnackbar(
        GetSnackBar(
          duration: const Duration(seconds: 5),
          title: error['title'],
          message: error['message'],
        ),
      );
      return null;
    }, (r) {
      Entry entry = Entry.fromJson(r[0]);
      EntryRepository().saveCache(word, jsonEncode(r));
      Get.find<CacheController>().entries.insert(0, entry);
      return entry;
    });
  }

  Future<List<Entry>> findAllPaginated(int currentPage, int lengthPage) {
    return EntryRepository().findAllPaginated(currentPage, lengthPage);
  }

  Future<List<Entry>> findCachePaginated(int currentPage, int lengthPage) {
    return EntryRepository().findCachePaginated(currentPage, lengthPage);
  }

  Future<List<Entry>> findFavoritePaginated(int currentPage, int lengthPage) {
    return EntryRepository().findFavoritePaginated(currentPage, lengthPage);
  }

  Future<void> toggleFavorite(Entry entry) async {
    return await EntryRepository().toggleFavorite(entry);
  }
}
