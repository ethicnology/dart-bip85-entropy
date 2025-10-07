import 'package:bip85_entropy/bip85_entropy.dart';
import 'package:test/test.dart';

import '_test_values.dart';

void main() {
  group('Password Base64 Tests', () {
    const application = PasswordBase64Application();
    const pwdLen = 21;
    const index = 0;

    test('21-char Base64 password', () {
      final password = Bip85Entropy.derivePasswordBase64(
        xprvBase58: TestValues.masterKey,
        pwdLen: 21,
        index: 0,
      );
      expect(password, TestValues.pwdBase64);
    });

    test('Base64 password from full path', () {
      final passwordFromFullPath = Bip85Entropy.deriveFromRawPath(
        xprvBase58: TestValues.masterKey,
        path:
            "${Bip85Entropy.pathPrefix}/${application.number}'/$pwdLen'/$index'",
      );
      expect(passwordFromFullPath, TestValues.pwdBase64);
    });

    test('Base64 password from partial path', () {
      final passwordFromPartialPath = Bip85Entropy.deriveFromRawPath(
        xprvBase58: TestValues.masterKey,
        path: "${application.number}'/$pwdLen'/$index'",
      );
      expect(passwordFromPartialPath, TestValues.pwdBase64);
    });

    test('invalid password length throws exception', () {
      expect(
        () => Bip85Entropy.derivePasswordBase64(
          xprvBase58: TestValues.masterKey,
          pwdLen: 19,
          index: 0,
        ),
        throwsA(isA<Bip85Exception>()),
      );
      expect(
        () => Bip85Entropy.derivePasswordBase64(
          xprvBase58: TestValues.masterKey,
          pwdLen: 87,
          index: 0,
        ),
        throwsA(isA<Bip85Exception>()),
      );
    });
  });

  group('Password Base85 Tests', () {
    const application = PasswordBase85Application();
    const pwdLen = 12;
    const index = 0;

    test('12-char Base85 password', () {
      final password = Bip85Entropy.derivePasswordBase85(
        xprvBase58: TestValues.masterKey,
        pwdLen: 12,
        index: 0,
      );
      expect(password, TestValues.pwdBase85);
    });

    test('Base85 password from full path', () {
      final passwordFromFullPath = Bip85Entropy.deriveFromRawPath(
        xprvBase58: TestValues.masterKey,
        path:
            "${Bip85Entropy.pathPrefix}/${application.number}'/$pwdLen'/$index'",
      );
      expect(passwordFromFullPath, TestValues.pwdBase85);
    });

    test('Base85 password from partial path', () {
      final passwordFromPartialPath = Bip85Entropy.deriveFromRawPath(
        xprvBase58: TestValues.masterKey,
        path: "${application.number}'/$pwdLen'/$index'",
      );
      expect(passwordFromPartialPath, TestValues.pwdBase85);
    });

    test('invalid password length throws exception', () {
      expect(
        () => Bip85Entropy.derivePasswordBase85(
          xprvBase58: TestValues.masterKey,
          pwdLen: 9,
          index: 0,
        ),
        throwsA(isA<Bip85Exception>()),
      );
      expect(
        () => Bip85Entropy.derivePasswordBase85(
          xprvBase58: TestValues.masterKey,
          pwdLen: 81,
          index: 0,
        ),
        throwsA(isA<Bip85Exception>()),
      );
    });
  });
}
