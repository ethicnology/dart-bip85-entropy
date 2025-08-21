import 'package:bip85/bip85.dart';
import 'package:test/test.dart';

import '_test_values.dart';

void main() {
  group('Password Base64 Tests', () {
    test('21-char Base64 password', () {
      final password = Bip85Entropy.derivePasswordBase64(
        TestValues.masterKey,
        21,
        0,
      );
      expect(password, TestValues.pwdBase64);
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
    test('12-char Base85 password', () {
      final password = Bip85Entropy.derivePasswordBase85(
        TestValues.masterKey,
        12,
        0,
      );
      expect(password, TestValues.pwdBase85);
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
