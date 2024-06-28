import 'dart:convert';

import 'package:crypto/crypto.dart';

class CryptoService {
  static String encrypt(String data) {
    var key = utf8.encode('Coodesh');
    var bytes = utf8.encode(data);

    var hmacSha256 = Hmac(sha256, key);
    var digest = hmacSha256.convert(bytes);

    return digest.toString();
  }
}
