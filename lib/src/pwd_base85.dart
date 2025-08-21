import 'package:bip85/bip85.dart';
import 'package:bip85/src/utils.dart';

String derivePasswordBase85({
  required String xprvBase58,
  required int pwdLen,
  required int index,
}) {
  if (pwdLen < 10 || pwdLen > 80) {
    throw Bip85Exception('Password length must be between 10 and 80');
  }

  try {
    final entropy = Bip85Entropy.derive(
      xprvBase58: xprvBase58,
      application: PasswordBase85Application(),
      path: "$pwdLen'/$index'",
    );
    final base85String = Utils.base85Encode(entropy);
    // Remove any spaces or new lines inserted by Base64 encoding process.
    final trimmedBase85String = base85String.replaceAll(RegExp(r'[\s\n]'), '');
    // Slice base64 result string on index 0 to `pwd_len`.
    return trimmedBase85String.substring(0, pwdLen);
  } catch (e) {
    throw Bip85Exception('Failed to derive Base85 password: $e');
  }
}
