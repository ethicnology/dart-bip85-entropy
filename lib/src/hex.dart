import 'package:bip85_entropy/bip85_entropy.dart';
import 'package:convert/convert.dart';

String deriveHex({
  required String xprvBase58,
  required int numBytes,
  required int index,
}) {
  if (numBytes < 16 || numBytes > 64) {
    throw Bip85Exception('Number of bytes must be between 16 and 64');
  }

  try {
    final entropy = Bip85Entropy.derive(
      xprvBase58: xprvBase58,
      application: HexApplication(),
      path: "$numBytes'/$index'",
    );
    return hex.encode(entropy.sublist(0, numBytes));
  } catch (e) {
    throw Bip85Exception('Failed to derive hex entropy: $e');
  }
}
