import 'package:bip85/bip85.dart';

Mnemonic deriveMnemonic(
  String xprvBase58,
  Language language,
  MnemonicLength length,
  int index,
) {
  try {
    final entropy = Bip85Entropy.derive(
      xprvBase58,
      MnemonicApplication(),
      "${language.toBip85Code()}'/${length.toBip85Code()}'/$index'",
    );

    // Truncate to required entropy length
    final truncatedEntropy = entropy.sublist(0, length.bytes);

    // Generate mnemonic from entropy
    return Mnemonic(truncatedEntropy, language);
  } catch (e) {
    throw Bip85Exception('Failed to derive BIP39 mnemonic: $e');
  }
}
