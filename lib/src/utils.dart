import 'dart:typed_data';

import 'package:base85/base85.dart';
import 'package:pointycastle/export.dart';

class Utils {
  // Helper method for HMAC-SHA512
  static Uint8List hmacSha512(Uint8List key, Uint8List data) {
    final hmac = HMac(SHA512Digest(), 128);
    hmac.init(KeyParameter(key));
    final out = Uint8List(64);
    hmac.update(data, 0, data.length);
    hmac.doFinal(out, 0);
    return out;
  }

  static String base85Encode(Uint8List data) {
    return Base85Codec(Alphabets.IPv6).encode(data);
  }
}
