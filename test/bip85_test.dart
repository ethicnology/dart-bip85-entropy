import 'package:bip85/bip85.dart';
import 'package:convert/convert.dart';
import 'package:test/test.dart';
import '_test_values.dart';

void main() {
  group('BIP85 Tests', () {
    test('BIP85 test vector - Test case 1: m/83696968\'/0\'/0\'', () {
      final entropy = Bip85Entropy.derive(
        TestValues.masterKey,
        CustomApplication.fromNumber(0),
        "0'",
      );
      expect(hex.encode(entropy), TestValues.entropy_0_0);
    });

    test('BIP85 test vector - Test case 2: m/83696968\'/0\'/1\'', () {
      final entropy = Bip85Entropy.derive(
        TestValues.masterKey,
        CustomApplication.fromNumber(0),
        "1'",
      );
      expect(hex.encode(entropy), TestValues.entropy_0_1);
    });
  });
}
