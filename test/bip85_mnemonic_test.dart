import 'package:bip85/bip85.dart';
import 'package:convert/convert.dart';
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

      expect(
        hex.encode(mnemonic.entropy),
        equals(TestValues.bip39_12words_entropy),
      );
      expect(mnemonic.sentence, equals(TestValues.bip39_12words_mnemonic));
    });

    test('derive 18-word English mnemonic', () {
      final mnemonic = Bip85Entropy.deriveMnemonic(
        TestValues.masterKey,
        Language.english,
        MnemonicLength.words18,
        0,
      );

      expect(
        hex.encode(mnemonic.entropy),
        equals(TestValues.bip39_18words_entropy),
      );
      expect(mnemonic.sentence, equals(TestValues.bip39_18words_mnemonic));
    });

    test('derive 24-word English mnemonic', () {
      final mnemonic = Bip85Entropy.deriveMnemonic(
        TestValues.masterKey,
        Language.english,
        MnemonicLength.words24,
        0,
      );

      expect(
        hex.encode(mnemonic.entropy),
        equals(TestValues.bip39_24words_entropy),
      );
      expect(mnemonic.sentence, equals(TestValues.bip39_24words_mnemonic));
    });
  });
}
