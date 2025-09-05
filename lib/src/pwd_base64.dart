import 'dart:convert';

import 'package:bip85_entropy/bip85_entropy.dart';

String derivePasswordBase64({
  required String xprvBase58,
  required int pwdLen,
  required int index,
}) {
  if (pwdLen < 20 || pwdLen > 86) {
    throw Bip85Exception('Password length must be between 20 and 86');
  }

  try {
    final entropy = Bip85Entropy.derive(
      xprvBase58: xprvBase58,
      application: PasswordBase64Application(),
      path: "$pwdLen'/$index'",
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
