import 'package:bip85_entropy/bip85_entropy.dart';
import 'package:convert/convert.dart';
import 'package:test/test.dart';

import '_test_values.dart';

void main() {
  group('BIP39 Mnemonic Tests', () {
    const application = MnemonicApplication();
    final languageCode = Language.english.toBip85Code();
    final lengthCode = MnemonicLength.words12.toBip85Code();
    const index = 0;

    test('derive 12-word English mnemonic', () {
      final mnemonic = Bip85Entropy.deriveMnemonic(
        xprvBase58: TestValues.masterKey,
        language: Language.english,
        length: MnemonicLength.words12,
        index: 0,
      );

      expect(
        hex.encode(mnemonic.entropy),
        equals(TestValues.bip39_12words_entropy),
      );
      expect(mnemonic.sentence, equals(TestValues.bip39_12words_mnemonic));
    });

    test('Mnemonic from full path', () {
      final mnemonicFromFullPath = Bip85Entropy.deriveFromPath(
        xprvBase58: TestValues.masterKey,
        path:
            "${Bip85Entropy.pathPrefix}/${application.number}'/$languageCode'/$lengthCode'/$index'",
      );
      expect(mnemonicFromFullPath, TestValues.bip39_12words_mnemonic);
    });

    test('Mnemonic from partial path', () {
      final mnemonicFromPartialPath = Bip85Entropy.deriveFromPath(
        xprvBase58: TestValues.masterKey,
        path: "${application.number}'/$languageCode'/$lengthCode'/$index'",
      );
      expect(mnemonicFromPartialPath, TestValues.bip39_12words_mnemonic);
    });

    test('derive 18-word English mnemonic', () {
      final mnemonic = Bip85Entropy.deriveMnemonic(
        xprvBase58: TestValues.masterKey,
        language: Language.english,
        length: MnemonicLength.words18,
        index: 0,
      );

      expect(
        hex.encode(mnemonic.entropy),
        equals(TestValues.bip39_18words_entropy),
      );
      expect(mnemonic.sentence, equals(TestValues.bip39_18words_mnemonic));
    });

    test('derive 24-word English mnemonic', () {
      final mnemonic = Bip85Entropy.deriveMnemonic(
        xprvBase58: TestValues.masterKey,
        language: Language.english,
        length: MnemonicLength.words24,
        index: 0,
      );

      expect(
        hex.encode(mnemonic.entropy),
        equals(TestValues.bip39_24words_entropy),
      );
      expect(mnemonic.sentence, equals(TestValues.bip39_24words_mnemonic));
    });
  });
}
