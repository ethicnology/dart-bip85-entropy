import 'package:bip85/bip85.dart';
import 'package:test/test.dart';

import '_test_values.dart';

void main() {
  group('HD-Seed WIF Tests', () {
    const application = WifApplication();
    const index = 0;

    test('BIP85 test vector - WIF', () {
      final wif = Bip85Entropy.deriveWif(TestValues.masterKey, index);
      expect(wif, TestValues.wif);
    });

    test('WIF from full path', () {
      final wifFromFullPath = Bip85Entropy.deriveFromPath(
        TestValues.masterKey,
        "${Bip85Entropy.pathPrefix}/${application.number}'/$index'",
      );
      expect(wifFromFullPath, TestValues.wif);
    });

    test('WIF from partial path', () {
      final wifFromPartialPath = Bip85Entropy.deriveFromPath(
        TestValues.masterKey,
        "${application.number}'/$index'",
      );
      expect(wifFromPartialPath, TestValues.wif);
    });
  });
}
