import 'package:bip85/bip85.dart' as bip39;

extension Bip39MnemonicLengthExtension on bip39.MnemonicLength {
  int toBip85Code() => words;

  static bip39.MnemonicLength fromBip85Code(int code) =>
      bip39.MnemonicLength.fromWords(code);
}

extension Bip39LanguageExtension on bip39.Language {
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
