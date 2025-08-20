import 'package:bip32_keys/bip32_keys.dart';
import 'package:bip85/bip85.dart';

String deriveXprv(String xprvBase58, int index) {
  try {
    final entropy = Bip85Entropy.derive(
      xprvBase58,
      XprvApplication(),
      "$index'",
    );
    final chainCode = entropy.sublist(0, 32);
    final privateKey = entropy.sublist(32, 64);

    // Create new BIP32 key with derived entropy
    final derivedBip32 = Bip32Keys(
      privateKey,
      null,
      chainCode,
      Slip132Format.xpub.network,
    );

    return derivedBip32.toBase58();
  } catch (e) {
    throw Bip85Exception('Failed to derive XPRV: $e');
  }
}
