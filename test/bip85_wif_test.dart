import 'package:bip85_entropy/bip85_entropy.dart';
import 'package:test/test.dart';

import '_test_values.dart';

void main() {
  group('HD-Seed WIF Tests', () {
    const application = WifApplication();
    const index = 0;

    test('BIP85 test vector - WIF', () {
      final wif = Bip85Entropy.deriveWif(
        xprvBase58: TestValues.masterKey,
        index: index,
      );
      expect(wif, TestValues.wif);
    });

    test('WIF from full path', () {
      final wifFromFullPath = Bip85Entropy.deriveFromRawPath(
        xprvBase58: TestValues.masterKey,
        path: "${Bip85Entropy.pathPrefix}/${application.number}'/$index'",
      );
      expect(wifFromFullPath, TestValues.wif);
    });

    test('WIF from partial path', () {
      final wifFromPartialPath = Bip85Entropy.deriveFromRawPath(
        xprvBase58: TestValues.masterKey,
        path: "${application.number}'/$index'",
      );
      expect(wifFromPartialPath, TestValues.wif);
    });
  });
}
