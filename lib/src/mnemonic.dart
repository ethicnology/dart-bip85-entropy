import 'package:bip85/bip85.dart';

Mnemonic deriveMnemonic({
  required String xprvBase58,
  required Language language,
  required MnemonicLength length,
  required int index,
}) {
  try {
    final entropy = Bip85Entropy.derive(
      xprvBase58: xprvBase58,
      application: MnemonicApplication(),
      path: "${language.toBip85Code()}'/${length.toBip85Code()}'/$index'",
    );

    // Truncate to required entropy length
    final truncatedEntropy = entropy.sublist(0, length.bytes);

    // Generate mnemonic from entropy
    return Mnemonic(truncatedEntropy, language);
  } catch (e) {
    throw Bip85Exception('Failed to derive BIP39 mnemonic: $e');
  }
}
