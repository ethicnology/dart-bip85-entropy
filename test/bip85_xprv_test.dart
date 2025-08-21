import 'package:bip85/bip85.dart';
import 'package:test/test.dart';

import '_test_values.dart';

void main() {
  group('XPRV Tests', () {
    test('BIP85 test vector - XPRV', () {
      final xprv = Bip85Entropy.deriveXprv(TestValues.masterKey, 0);
      expect(xprv, TestValues.xprv);
    });
  });
}
