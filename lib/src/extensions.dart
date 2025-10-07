import 'package:bip85_entropy/bip85_entropy.dart' as bip39;

/// Extension on [bip39.MnemonicLength] to convert between mnemonic length and BIP85 code.
extension Bip39MnemonicLengthExtension on bip39.MnemonicLength {
  /// Converts the mnemonic length to its BIP85 code representation.
  /// Returns the number of words in the mnemonic.
  int toBip85Code() => words;

  /// Creates a [bip39.MnemonicLength] from a BIP85 code.
  /// The [code] represents the number of words in the mnemonic.
  static bip39.MnemonicLength fromBip85Code(int code) =>
      bip39.MnemonicLength.fromWords(code);
}

/// Extension on [bip39.Language] to convert between language and BIP85 code.
extension Bip39LanguageExtension on bip39.Language {
  /// Converts the language to its BIP85 code representation.
  /// Returns an integer code according to BIP85 specification.
  int toBip85Code() => switch (this) {
    bip39.Language.english => 0,
    bip39.Language.japanese => 1,
    bip39.Language.korean => 2,
    bip39.Language.spanish => 3,
    bip39.Language.simplifiedChinese => 4,
    bip39.Language.traditionalChinese => 5,
    bip39.Language.french => 6,
    bip39.Language.italian => 7,
    bip39.Language.czech => 8,
    bip39.Language.portuguese => 9,
  };

  /// Creates a [bip39.Language] from a BIP85 code.
  /// The [code] should be a valid BIP85 language code (0-9).
  /// Throws [UnsupportedError] if the code is not supported.
  static bip39.Language fromBip85Code(int code) => switch (code) {
    0 => bip39.Language.english,
    1 => bip39.Language.japanese,
    2 => bip39.Language.korean,
    3 => bip39.Language.spanish,
    4 => bip39.Language.simplifiedChinese,
    5 => bip39.Language.traditionalChinese,
    6 => bip39.Language.french,
    7 => bip39.Language.italian,
    8 => bip39.Language.czech,
    9 => bip39.Language.portuguese,
    _ => throw UnsupportedError('Unsupported BIP85 language code: $code'),
  };
}
