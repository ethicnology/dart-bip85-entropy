import 'package:bip85/bip85.dart';
import 'package:test/test.dart';

import '_test_values.dart';

void main() {
  group('XPRV Tests', () {
    const application = XprvApplication();
    const index = 0;

    test('BIP85 test vector - XPRV', () {
      final xprv = Bip85Entropy.deriveXprv(TestValues.masterKey, 0);
      expect(xprv, TestValues.xprv);
    });

    test('XPRV from full path', () {
      final xprvFromFullPath = Bip85Entropy.deriveFromPath(
        TestValues.masterKey,
        "${Bip85Entropy.pathPrefix}/${application.number}'/$index'",
      );
      expect(xprvFromFullPath, TestValues.xprv);
    });

    test('XPRV from partial path', () {
      final xprvFromPartialPath = Bip85Entropy.deriveFromPath(
        TestValues.masterKey,
        "${application.number}'/$index'",
      );
      expect(xprvFromPartialPath, TestValues.xprv);
    });
  });
}
