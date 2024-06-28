import 'dart:convert';

import 'package:either_dart/either.dart';
import 'package:get/get.dart';

class ApiService extends GetConnect {
  final String url = 'https://api.dictionaryapi.dev/api/v2/entries/en/';

  Future<Either<String, dynamic>> findWord(String word) async {
    final response = await super.get(url + word);
    if (response.statusCode == 200) {
      return Right(jsonDecode(response.bodyString!));
    }

    return Left(response.bodyString ??
        "'title': 'Error', 'message': 'Sorry pal, we couldn\'t find definitions for the word you were looking for.'");
  }
}
