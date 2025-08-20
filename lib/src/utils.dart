import 'dart:math';
import 'dart:typed_data';

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

  // Helper method for Base58 encoding
  static String base58Encode(Uint8List input) {
    const alphabet =
        '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz';
    if (input.isEmpty) return '';

    // Count leading zeros
    int leadingZeros = 0;
    for (int byte in input) {
      if (byte == 0) {
        leadingZeros++;
      } else {
        break;
      }
    }

    // Convert to base58
    var num = BigInt.zero;
    for (int byte in input) {
      num = num * BigInt.from(256) + BigInt.from(byte);
    }

    var encoded = '';
    while (num > BigInt.zero) {
      final remainder = num % BigInt.from(58);
      num = num ~/ BigInt.from(58);
      encoded = alphabet[remainder.toInt()] + encoded;
    }

    // Add leading 1s for leading zeros
    encoded = '1' * leadingZeros + encoded;

    return encoded;
  }

  // Helper method for Base85 encoding
  static String base85Encode(Uint8List input) {
    const alphabet =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz!#\$%&()*+-;<=>?@^_`{|}~';

    var result = '';
    for (int i = 0; i < input.length; i += 4) {
      var chunk = BigInt.zero;
      final end = min(i + 4, input.length);

      for (int j = i; j < end; j++) {
        chunk = chunk << 8 | BigInt.from(input[j]);
      }

      // Pad if necessary
      final padding = 4 - (end - i);
      chunk = chunk << (padding * 8);

      var encoded = '';
      for (int k = 0; k < 5; k++) {
        encoded = alphabet[(chunk % BigInt.from(85)).toInt()] + encoded;
        chunk = chunk ~/ BigInt.from(85);
      }

      // Remove padding characters
      if (padding > 0) {
        encoded = encoded.substring(0, 5 - padding);
      }

      result += encoded;
    }

    return result;
  }
}
