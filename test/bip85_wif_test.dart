import 'package:bip85/bip85.dart';
import 'package:test/test.dart';

import '_test_values.dart';

void main() {
  group('HD-Seed WIF Tests', () {
    test('derive WIF key', () {
      final wif = Bip85Entropy.deriveWif(TestValues.masterKey, 0);
      expect(wif, isA<String>());
      expect(wif.startsWith('K') || wif.startsWith('L'), isTrue);
    });

    test('different indices produce different WIF keys', () {
      final wif1 = Bip85Entropy.deriveWif(TestValues.masterKey, 0);
      final wif2 = Bip85Entropy.deriveWif(TestValues.masterKey, 1);
      expect(wif1, isNot(equals(wif2)));
    });

    test('BIP85 test vector - WIF', () {
      final wif = Bip85Entropy.deriveWif(TestValues.masterKey, 0);
      expect(wif, equals(TestValues.hdSeedWif));
    });
  });
}
