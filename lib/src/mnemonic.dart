import 'package:bip85/bip85.dart';
import 'utils.dart';

String deriveMnemonic(
  String xprvBase58,
  Language language,
  MnemonicLength length,
  int index,
) {
  try {
    final entropy = Bip85Entropy.derive(
      xprvBase58,
      MnemonicApplication(),
      "${Utils.languageToBip85Code(language)}'/${length.words}'/$index'",
    );

    // Truncate to required entropy length
    final truncatedEntropy = entropy.sublist(0, length.bytes);

    // Generate mnemonic from entropy
    final mnemonic = Mnemonic(truncatedEntropy, language);
    return mnemonic.sentence;
  } catch (e) {
    throw Bip85Exception('Failed to derive BIP39 mnemonic: $e');
  }
}
