import 'package:bip85_entropy/bip85_entropy.dart';
import 'package:test/test.dart';

import '_test_values.dart';

void main() {
  group('XPRV Tests', () {
    const application = XprvApplication();
    const index = 0;

    test('BIP85 test vector - XPRV', () {
      final xprv = Bip85Entropy.deriveXprv(
        xprvBase58: TestValues.masterKey,
        index: 0,
      );
      expect(xprv, TestValues.xprv);
    });

    test('XPRV from full path', () {
      final xprvFromFullPath = Bip85Entropy.deriveFromPath(
        xprvBase58: TestValues.masterKey,
        path: "${Bip85Entropy.pathPrefix}/${application.number}'/$index'",
      );
      expect(xprvFromFullPath, TestValues.xprv);
    });

    test('XPRV from partial path', () {
      final xprvFromPartialPath = Bip85Entropy.deriveFromPath(
        xprvBase58: TestValues.masterKey,
        path: "${application.number}'/$index'",
      );
      expect(xprvFromPartialPath, TestValues.xprv);
    });
  });
}
