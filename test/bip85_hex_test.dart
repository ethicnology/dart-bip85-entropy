import 'package:bip85/bip85.dart';
import 'package:test/test.dart';

import '_test_values.dart';

void main() {
  group('HEX Tests', () {
    test('BIP85 test vector - 64-byte HEX', () {
      final hexEntropy = Bip85Entropy.deriveHex(TestValues.masterKey, 64, 0);
      expect(hexEntropy, TestValues.hex64_entropy);
    });

    test('invalid byte count throws exception', () {
      expect(
        () => Bip85Entropy.deriveHex(TestValues.masterKey, 15, 0),
        throwsA(isA<Bip85Exception>()),
      );
      expect(
        () => Bip85Entropy.deriveHex(TestValues.masterKey, 65, 0),
        throwsA(isA<Bip85Exception>()),
      );
    });
  });
}
