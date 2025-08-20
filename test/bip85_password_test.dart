import 'package:bip85/bip85.dart';
import 'package:test/test.dart';

import '_test_values.dart';

void main() {
  group('Password Base64 Tests', () {
    test('derive Base64 password', () {
      final password = Bip85Entropy.derivePasswordBase64(
        TestValues.masterKey,
        20,
        0,
      );
      expect(password, isA<String>());
      expect(password.length, equals(20));
    });

    test('different lengths produce different password lengths', () {
      final pwd20 = Bip85Entropy.derivePasswordBase64(
        TestValues.masterKey,
        20,
        0,
      );
      final pwd30 = Bip85Entropy.derivePasswordBase64(
        TestValues.masterKey,
        30,
        0,
      );
      expect(pwd20.length, equals(20));
      expect(pwd30.length, equals(30));
    });

    test('BIP85 test vector - 21-char Base64 password', () {
      final password = Bip85Entropy.derivePasswordBase64(
        TestValues.masterKey,
        21,
        0,
      );
      expect(password, equals(TestValues.pwdBase64));
    });

    test('invalid password length throws exception', () {
      expect(
        () => Bip85Entropy.derivePasswordBase64(TestValues.masterKey, 19, 0),
        throwsA(isA<Bip85Exception>()),
      );
      expect(
        () => Bip85Entropy.derivePasswordBase64(TestValues.masterKey, 87, 0),
        throwsA(isA<Bip85Exception>()),
      );
    });
  });

  group('Password Base85 Tests', () {
    test('derive Base85 password', () {
      final password = Bip85Entropy.derivePasswordBase85(
        TestValues.masterKey,
        12,
        0,
      );
      expect(password, isA<String>());
      expect(password.length, equals(12));
    });

    test('BIP85 test vector - 12-char Base85 password', () {
      final password = Bip85Entropy.derivePasswordBase85(
        TestValues.masterKey,
        12,
        0,
      );
      expect(password, equals(TestValues.pwdBase85));
    });

    test('invalid password length throws exception', () {
      expect(
        () => Bip85Entropy.derivePasswordBase85(TestValues.masterKey, 9, 0),
        throwsA(isA<Bip85Exception>()),
      );
      expect(
        () => Bip85Entropy.derivePasswordBase85(TestValues.masterKey, 81, 0),
        throwsA(isA<Bip85Exception>()),
      );
    });
  });
}
