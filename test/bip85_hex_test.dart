import 'package:bip85/bip85.dart';
import 'package:test/test.dart';

import '_test_values.dart';

void main() {
  group('HEX Tests', () {
    test('derive hex entropy', () {
      final hexEntropy = Bip85Entropy.deriveHex(TestValues.masterKey, 32, 0);
      expect(hexEntropy, isA<String>());
      expect(hexEntropy.length, equals(64)); // 32 bytes = 64 hex chars
      expect(RegExp(r'^[0-9a-f]+$').hasMatch(hexEntropy), isTrue);
    });

    test('different byte counts produce different lengths', () {
      final hex16 = Bip85Entropy.deriveHex(TestValues.masterKey, 16, 0);
      final hex32 = Bip85Entropy.deriveHex(TestValues.masterKey, 32, 0);
      expect(hex16.length, equals(32)); // 16 bytes = 32 hex chars
      expect(hex32.length, equals(64)); // 32 bytes = 64 hex chars
    });

    test('BIP85 test vector - 64-byte HEX', () {
      final hexEntropy = Bip85Entropy.deriveHex(TestValues.masterKey, 64, 0);
      expect(
        hexEntropy,
        equals(
          '492db4698cf3b73a5a24998aa3e9d7fa96275d85724a91e71aa2d645442f878555d078fd1f1f67e368976f04137b1f7a0d19232136ca50c44614af72b5582a5c',
        ),
      );
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
