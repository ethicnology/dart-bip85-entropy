import 'package:bip32_keys/bip32_keys.dart' as bip32;
import 'package:bip85_entropy/bip85_entropy.dart';

String deriveWif({required String xprvBase58, required int index}) {
  try {
    final root = bip32.Bip32Keys.fromBase58(xprvBase58);
    final entropy = Bip85Entropy.derive(
      xprvBase58: xprvBase58,
      application: WifApplication(),
      path: "$index'",
    );
    final privateKeyBytes = entropy.sublist(0, 32);

    final tempKey = bip32.Bip32Keys(
      privateKeyBytes,
      null, // No public key needed
      root.chainCode, // Dummy chain code since we just need WIF
      root.network,
    );

    return tempKey.toWIF();
  } catch (e) {
    throw Bip85Exception('Failed to derive HD-Seed WIF: $e');
  }
}
