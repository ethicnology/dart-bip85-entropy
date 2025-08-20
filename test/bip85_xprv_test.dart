import 'package:bip85/bip85.dart';
import 'package:test/test.dart';

import '_test_values.dart';

void main() {
  group('XPRV Tests', () {
    test('derive XPRV', () {
      final xprv = Bip85Entropy.deriveXprv(TestValues.masterKey, 0);
      expect(xprv, isA<String>());
      expect(xprv.startsWith('xprv'), isTrue);
    });

    test('different indices produce different XPRV keys', () {
      final xprv1 = Bip85Entropy.deriveXprv(TestValues.masterKey, 0);
      final xprv2 = Bip85Entropy.deriveXprv(TestValues.masterKey, 1);
      expect(xprv1, isNot(equals(xprv2)));
    });

    test('BIP85 test vector - XPRV', () {
      final xprv = Bip85Entropy.deriveXprv(TestValues.masterKey, 0);
      expect(xprv, equals(TestValues.xprv));
    });
  });
}
