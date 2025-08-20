import 'package:bip85/bip85.dart';
import 'package:test/test.dart';

import '_test_values.dart';

void main() {
  group('BIP39 Mnemonic Tests', () {
    test('derive 12-word English mnemonic', () {
      final mnemonic = Bip85Entropy.deriveMnemonic(
        TestValues.masterKey,
        Language.english,
        MnemonicLength.words12,
        0,
      );
      expect(mnemonic.split(' ').length, equals(12));
      expect(mnemonic, isA<String>());
    });

    test('derive 24-word English mnemonic', () {
      final mnemonic = Bip85Entropy.deriveMnemonic(
        TestValues.masterKey,
        Language.english,
        MnemonicLength.words24,
        0,
      );
      expect(mnemonic.split(' ').length, equals(24));
      expect(mnemonic, isA<String>());
    });

    test('different indices produce different mnemonics', () {
      final mnemonic1 = Bip85Entropy.deriveMnemonic(
        TestValues.masterKey,
        Language.english,
        MnemonicLength.words12,
        0,
      );
      final mnemonic2 = Bip85Entropy.deriveMnemonic(
        TestValues.masterKey,
        Language.english,
        MnemonicLength.words12,
        1,
      );
      expect(mnemonic1, isNot(equals(mnemonic2)));
    });

    test('BIP85 test vector - 12 English words', () {
      final mnemonic = Bip85Entropy.deriveMnemonic(
        TestValues.masterKey,
        Language.english,
        MnemonicLength.words12,
        0,
      );
      expect(mnemonic, equals(TestValues.bip39_12words_mnemonic));
    });

    test('BIP85 test vector - 18 English words', () {
      final mnemonic = Bip85Entropy.deriveMnemonic(
        TestValues.masterKey,
        Language.english,
        MnemonicLength.words18,
        0,
      );
      expect(mnemonic, equals(TestValues.bip39_18words_mnemonic));
    });

    test('BIP85 test vector - 24 English words', () {
      final mnemonic = Bip85Entropy.deriveMnemonic(
        TestValues.masterKey,
        Language.english,
        MnemonicLength.words24,
        0,
      );
      expect(mnemonic, equals(TestValues.bip39_24words_mnemonic));
    });
  });
}
