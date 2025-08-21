import 'package:bip85/bip85.dart';
import 'package:test/test.dart';

import '_test_values.dart';

void main() {
  group('HEX Tests', () {
    const application = HexApplication();
    const numBytes = 64;
    const index = 0;
    test('BIP85 test vector - 64-byte HEX', () {
      final hexEntropy = Bip85Entropy.deriveHex(
        xprvBase58: TestValues.masterKey,
        numBytes: numBytes,
        index: index,
      );
      expect(hexEntropy, TestValues.hex64_entropy);
    });

    test('HEX from full path', () {
      final hexEntropyFromFullPath = Bip85Entropy.deriveFromPath(
        xprvBase58: TestValues.masterKey,
        path:
            "${Bip85Entropy.pathPrefix}/${application.number}'/$numBytes'/$index'",
      );
      expect(hexEntropyFromFullPath, TestValues.hex64_entropy);
    });

    test('HEX from partial path', () {
      final hexEntropyFromPartialPath = Bip85Entropy.deriveFromPath(
        xprvBase58: TestValues.masterKey,
        path: "${application.number}'/$numBytes'/$index'",
      );
      expect(hexEntropyFromPartialPath, TestValues.hex64_entropy);
    });

    test('invalid byte count throws exception', () {
      expect(
        () => Bip85Entropy.deriveHex(
          xprvBase58: TestValues.masterKey,
          numBytes: 15,
          index: 0,
        ),
        throwsA(isA<Bip85Exception>()),
      );
      expect(
        () => Bip85Entropy.deriveHex(
          xprvBase58: TestValues.masterKey,
          numBytes: 65,
          index: 0,
        ),
        throwsA(isA<Bip85Exception>()),
      );
    });
  });
}
