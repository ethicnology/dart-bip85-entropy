import 'package:bip85/bip85.dart';
import 'package:test/test.dart';

import '_test_values.dart';

void main() {
  group('HD-Seed WIF Tests', () {
    test('BIP85 test vector - WIF', () {
      final wif = Bip85Entropy.deriveWif(TestValues.masterKey, 0);
      expect(wif, TestValues.wif);
    });
  });
}
