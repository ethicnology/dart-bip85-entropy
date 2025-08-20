import 'dart:convert';

import 'package:bip85/bip85.dart';

String derivePasswordBase64(String xprvBase58, int pwdLen, int index) {
  if (pwdLen < 20 || pwdLen > 86) {
    throw Bip85Exception('Password length must be between 20 and 86');
  }

  try {
    final entropy = Bip85Entropy.derive(
      xprvBase58,
      PasswordBase64Application(),
      "$pwdLen'/$index'",
    );
    final base64String = base64Encode(entropy);

    // Remove any spaces or new lines inserted by Base64 encoding process.
    final trimmedBase64String = base64String.replaceAll(RegExp(r'[\s\n]'), '');
    // Slice base64 result string on index 0 to `pwd_len`.
    return trimmedBase64String.substring(0, pwdLen);
  } catch (e) {
    throw Bip85Exception('Failed to derive Base64 password: $e');
  }
}
