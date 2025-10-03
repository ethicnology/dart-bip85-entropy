import 'package:bip85_entropy/bip85_entropy.dart';
import 'package:test/test.dart';
import '_test_values.dart';

void main() {
  group('Bip85Path Tests', () {
    group('Valid hardened paths', () {
      test('accepts full BIP85 path with hardened components', () {
        expect(
          () => Bip85HardenedPath(path: "m/83696968'/39'/0'/12'/0'"),
          returnsNormally,
        );
      });

      test('accepts path without BIP85 prefix', () {
        expect(() => Bip85HardenedPath(path: "39'/0'/12'/0'"), returnsNormally);
      });

      test('application missing quote', () {
        expect(
          () => Bip85HardenedPath(path: "39/0'/12'/0'"),
          throwsA(isA<Bip85Exception>()),
        );
      });

      test('index missing quote', () {
        expect(
          () => Bip85HardenedPath(path: "39'/0'/12'/0"),
          throwsA(isA<Bip85Exception>()),
        );
      });

      test('accepts multiple hardened components', () {
        expect(
          () => Bip85HardenedPath(path: "1'/2'/3'/4'/5'"),
          returnsNormally,
        );
      });
    });

    group('Invalid paths', () {
      test('throws on empty path', () {
        expect(
          () => Bip85HardenedPath(path: ''),
          throwsA(
            predicate(
              (e) => e is Bip85Exception && e.message == 'Path cannot be empty',
            ),
          ),
        );
      });

      test('throws on non-hardened component', () {
        expect(
          () => Bip85HardenedPath(path: "39'/0/12'/0'"),
          throwsA(
            predicate(
              (e) =>
                  e is Bip85Exception &&
                  e.message.contains('must be hardened') &&
                  e.message.contains('Component "0" at position 1'),
            ),
          ),
        );
      });

      test('throws on first component not hardened', () {
        expect(
          () => Bip85HardenedPath(path: "39/0'/12'/0'"),
          throwsA(
            predicate(
              (e) =>
                  e is Bip85Exception &&
                  e.message.contains('must be hardened') &&
                  e.message.contains('Component "39" at position 0'),
            ),
          ),
        );
      });

      test('throws on last component not hardened', () {
        expect(
          () => Bip85HardenedPath(path: "39'/0'/12'/0"),
          throwsA(
            predicate(
              (e) =>
                  e is Bip85Exception &&
                  e.message.contains('must be hardened') &&
                  e.message.contains('Component "0" at position 3'),
            ),
          ),
        );
      });

      test('throws on invalid number component', () {
        expect(
          () => Bip85HardenedPath(path: "abc'/0'/12'/0'"),
          throwsA(
            predicate(
              (e) =>
                  e is Bip85Exception &&
                  e.message.contains('Invalid path component "abc\'"'),
            ),
          ),
        );
      });

      test('throws on empty component', () {
        expect(
          () => Bip85HardenedPath(path: "'/0'/12'/0'"),
          throwsA(
            predicate(
              (e) =>
                  e is Bip85Exception &&
                  e.message.contains('Invalid path component "\'"'),
            ),
          ),
        );
      });

      test('throws on only slash', () {
        expect(
          () => Bip85HardenedPath(path: '/'),
          throwsA(
            predicate(
              (e) =>
                  e is Bip85Exception &&
                  e.message.contains(
                    'Path must contain at least one derivation component',
                  ),
            ),
          ),
        );
      });

      test('throws with full BIP85 prefix but non-hardened components', () {
        expect(
          () => Bip85HardenedPath(path: "m/83696968'/39/0'/12'/0'"),
          throwsA(
            predicate(
              (e) =>
                  e is Bip85Exception &&
                  e.message.contains('must be hardened') &&
                  e.message.contains('Component "39" at position 0'),
            ),
          ),
        );
      });
    });

    group('Edge cases', () {
      test('handles paths with leading/trailing slashes', () {
        expect(
          () => Bip85HardenedPath(path: "/39'/0'/12'/0'/"),
          returnsNormally,
        );
      });

      test('handles zero values', () {
        expect(() => Bip85HardenedPath(path: "0'/0'/0'"), returnsNormally);
      });
    });

    group('deriveFromPath vs deriveFromHardenedPath equivalence', () {
      test('produces same output for mnemonic derivation', () {
        const path = "m/83696968'/39'/0'/12'/0'";
        final hardenedPath = Bip85HardenedPath(path: path);

        final resultFromPath = Bip85Entropy.deriveFromPath(
          xprvBase58: TestValues.masterKey,
          path: path,
        );

        final resultFromHardenedPath = Bip85Entropy.deriveFromHardenedPath(
          xprvBase58: TestValues.masterKey,
          hardenedPath: hardenedPath,
        );

        expect(resultFromPath, equals(resultFromHardenedPath));
        expect(resultFromPath, equals(TestValues.bip39_12words_mnemonic));
      });

      test('produces same output for hex derivation', () {
        const path = "m/83696968'/128169'/64'/0'";
        final hardenedPath = Bip85HardenedPath(path: path);

        final resultFromPath = Bip85Entropy.deriveFromPath(
          xprvBase58: TestValues.masterKey,
          path: path,
        );

        final resultFromHardenedPath = Bip85Entropy.deriveFromHardenedPath(
          xprvBase58: TestValues.masterKey,
          hardenedPath: hardenedPath,
        );

        expect(resultFromPath, equals(resultFromHardenedPath));
        expect(resultFromPath, equals(TestValues.hex64_entropy));
      });

      test('produces same output for WIF derivation', () {
        const path = "m/83696968'/2'/0'";
        final hardenedPath = Bip85HardenedPath(path: path);

        final resultFromPath = Bip85Entropy.deriveFromPath(
          xprvBase58: TestValues.masterKey,
          path: path,
        );

        final resultFromHardenedPath = Bip85Entropy.deriveFromHardenedPath(
          xprvBase58: TestValues.masterKey,
          hardenedPath: hardenedPath,
        );

        expect(resultFromPath, equals(resultFromHardenedPath));
        expect(resultFromPath, equals(TestValues.wif));
      });

      test('produces same output for XPRV derivation', () {
        const path = "m/83696968'/32'/0'";
        final hardenedPath = Bip85HardenedPath(path: path);

        final resultFromPath = Bip85Entropy.deriveFromPath(
          xprvBase58: TestValues.masterKey,
          path: path,
        );

        final resultFromHardenedPath = Bip85Entropy.deriveFromHardenedPath(
          xprvBase58: TestValues.masterKey,
          hardenedPath: hardenedPath,
        );

        expect(resultFromPath, equals(resultFromHardenedPath));
        expect(resultFromPath, equals(TestValues.xprv));
      });

      test('produces same output for Base64 password derivation', () {
        const path = "m/83696968'/707764'/21'/0'";
        final hardenedPath = Bip85HardenedPath(path: path);

        final resultFromPath = Bip85Entropy.deriveFromPath(
          xprvBase58: TestValues.masterKey,
          path: path,
        );

        final resultFromHardenedPath = Bip85Entropy.deriveFromHardenedPath(
          xprvBase58: TestValues.masterKey,
          hardenedPath: hardenedPath,
        );

        expect(resultFromPath, equals(resultFromHardenedPath));
        expect(resultFromPath, equals(TestValues.pwdBase64));
      });

      test('produces same output for Base85 password derivation', () {
        const path = "m/83696968'/707785'/12'/0'";
        final hardenedPath = Bip85HardenedPath(path: path);

        final resultFromPath = Bip85Entropy.deriveFromPath(
          xprvBase58: TestValues.masterKey,
          path: path,
        );

        final resultFromHardenedPath = Bip85Entropy.deriveFromHardenedPath(
          xprvBase58: TestValues.masterKey,
          hardenedPath: hardenedPath,
        );

        expect(resultFromPath, equals(resultFromHardenedPath));
        expect(resultFromPath, equals(TestValues.pwdBase85));
      });

      test('produces same output for custom application derivation', () {
        const path = "m/83696968'/0'/0'";
        final hardenedPath = Bip85HardenedPath(path: path);

        final resultFromPath = Bip85Entropy.deriveFromPath(
          xprvBase58: TestValues.masterKey,
          path: path,
        );

        final resultFromHardenedPath = Bip85Entropy.deriveFromHardenedPath(
          xprvBase58: TestValues.masterKey,
          hardenedPath: hardenedPath,
        );

        expect(resultFromPath, equals(resultFromHardenedPath));
        expect(resultFromPath, equals(TestValues.entropy_0_0));
      });

      test('produces same output for paths without BIP85 prefix', () {
        const path = "39'/0'/12'/0'";
        final hardenedPath = Bip85HardenedPath(path: path);

        final resultFromPath = Bip85Entropy.deriveFromPath(
          xprvBase58: TestValues.masterKey,
          path: path,
        );

        final resultFromHardenedPath = Bip85Entropy.deriveFromHardenedPath(
          xprvBase58: TestValues.masterKey,
          hardenedPath: hardenedPath,
        );

        expect(resultFromPath, equals(resultFromHardenedPath));
        expect(resultFromPath, equals(TestValues.bip39_12words_mnemonic));
      });

      test('produces same output for complex paths', () {
        const path =
            "89101'/6'/10'/0'"; // Dice application (though not implemented)
        final hardenedPath = Bip85HardenedPath(path: path);

        // Both should throw the same exception for unsupported application
        expect(
          () => Bip85Entropy.deriveFromPath(
            xprvBase58: TestValues.masterKey,
            path: path,
          ),
          throwsA(isA<Bip85Exception>()),
        );

        expect(
          () => Bip85Entropy.deriveFromHardenedPath(
            xprvBase58: TestValues.masterKey,
            hardenedPath: hardenedPath,
          ),
          throwsA(isA<Bip85Exception>()),
        );
      });
    });
  });
}
