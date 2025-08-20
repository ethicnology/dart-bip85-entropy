import 'package:bip85/bip85.dart' as bip39;

extension Bip39MnemonicLengthExtension on bip39.MnemonicLength {
  int toBip85Code() => words;
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
}
