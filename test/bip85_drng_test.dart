import 'dart:typed_data';

import 'package:bip85/bip85.dart';
import 'package:convert/convert.dart';
import 'package:test/test.dart';
import '_test_values.dart';

void main() {
  group('DRNG Tests', () {
    test('Expected entropy', () {
      final entropy = Bip85Entropy.derive(
        TestValues.masterKey,
        CustomApplication.fromNumber(0),
        "0'",
      );
      expect(entropy, TestValues.drng_entropy);
    });

    test('Expected 80 bytes', () {
      final drng = Bip85DRNG(
        Uint8List.fromList(hex.decode(TestValues.masterKey)),
      );
      final drng80 = drng.read(80);
      expect(hex.encode(drng80), TestValues.drng_80_bytes);
    });
  });
}
