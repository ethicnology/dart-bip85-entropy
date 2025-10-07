import 'package:bip85_entropy/bip85_entropy.dart';
import 'package:convert/convert.dart';
import 'package:test/test.dart';
import '_test_values.dart';

void main() {
  group('BIP85 Tests', () {
    const applicationNumber = 0;
    const index1 = 0;
    const index2 = 1;

    test(
      'BIP85 test vector - Test case 1: m/83696968\'/$applicationNumber\'/$index1\'',
      () {
        final entropy = Bip85Entropy.derive(
          xprvBase58: TestValues.masterKey,
          application: CustomApplication.fromNumber(0),
          path: "$index1'",
        );
        expect(hex.encode(entropy), TestValues.entropy_0_0);
      },
    );

    test('Custom application from full path entropy_0_0', () {
      final entropyFromFullPath = Bip85Entropy.deriveFromRawPath(
        xprvBase58: TestValues.masterKey,
        path: "${Bip85Entropy.pathPrefix}/$applicationNumber'/$index1'",
      );
      expect(entropyFromFullPath, TestValues.entropy_0_0);
    });

    test('Custom application from partial path entropy_0_0', () {
      final entropyFromPartialPath = Bip85Entropy.deriveFromRawPath(
        xprvBase58: TestValues.masterKey,
        path: "$applicationNumber'/$index1'",
      );
      expect(entropyFromPartialPath, TestValues.entropy_0_0);
    });

    test(
      'BIP85 test vector - Test case 2: m/83696968\'/$applicationNumber\'/$index2\'',
      () {
        final entropy = Bip85Entropy.derive(
          xprvBase58: TestValues.masterKey,
          application: CustomApplication.fromNumber(0),
          path: "$index2'",
        );
        expect(hex.encode(entropy), TestValues.entropy_0_1);
      },
    );

    test('Custom application from full path entropy_0_1', () {
      final entropyFromFullPath = Bip85Entropy.deriveFromRawPath(
        xprvBase58: TestValues.masterKey,
        path: "${Bip85Entropy.pathPrefix}/$applicationNumber'/$index2'",
      );
      expect(entropyFromFullPath, TestValues.entropy_0_1);
    });

    test('Custom application from partial path entropy_0_1', () {
      final entropyFromPartialPath = Bip85Entropy.deriveFromRawPath(
        xprvBase58: TestValues.masterKey,
        path: "$applicationNumber'/$index2'",
      );
      expect(entropyFromPartialPath, TestValues.entropy_0_1);
    });
  });
}
