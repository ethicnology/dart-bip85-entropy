import 'dart:typed_data';
import 'package:bip85/bip85.dart';
import 'package:test/test.dart';
import 'package:convert/convert.dart';
import '_test_values.dart';

void main() {
  group('BIP85 Tests', () {
    test('derive basic functionality', () {
      final entropy = Bip85Entropy.derive(
        TestValues.masterKey,
        WifApplication(),
        "0'",
      );
      expect(entropy.length, equals(64));
      expect(entropy, isA<Uint8List>());
    });

    test('deterministic results', () {
      final entropy1 = Bip85Entropy.derive(
        TestValues.masterKey,
        WifApplication(),
        "0'",
      );
      final entropy2 = Bip85Entropy.derive(
        TestValues.masterKey,
        WifApplication(),
        "0'",
      );
      expect(entropy1, equals(entropy2));
    });

    test('different paths produce different results', () {
      final entropy1 = Bip85Entropy.derive(
        TestValues.masterKey,
        WifApplication(),
        "0'",
      );
      final entropy2 = Bip85Entropy.derive(
        TestValues.masterKey,
        WifApplication(),
        "1'",
      );
      expect(entropy1, isNot(equals(entropy2)));
    });

    test('different application numbers produce different results', () {
      final entropy1 = Bip85Entropy.derive(
        TestValues.masterKey,
        CustomApplication.fromNumber(0),
        "0'",
      );
      final entropy2 = Bip85Entropy.derive(
        TestValues.masterKey,
        MnemonicApplication(),
        "0'",
      );
      expect(entropy1, isNot(equals(entropy2)));
    });

    test('BIP85 test vector - Test case 1: m/83696968\'/0\'/0\'', () {
      final entropy = Bip85Entropy.derive(
        TestValues.masterKey,
        CustomApplication.fromNumber(0),
        "0'",
      );
      expect(hex.encode(entropy), equals(hex.encode(TestValues.entropy_0_0)));
    });

    test('BIP85 test vector - Test case 2: m/83696968\'/0\'/1\'', () {
      final entropy = Bip85Entropy.derive(
        TestValues.masterKey,
        CustomApplication.fromNumber(0),
        "1'",
      );
      expect(hex.encode(entropy), equals(hex.encode(TestValues.entropy_0_1)));
    });

    test('derive with custom path basic functionality', () {
      final entropy = Bip85Entropy.derive(
        TestValues.masterKey,
        WifApplication(),
        "0'",
      );
      expect(entropy.length, equals(64));
      expect(entropy, isA<Uint8List>());
    });

    test('derive with custom multi-level path', () {
      final entropy1 = Bip85Entropy.derive(
        TestValues.masterKey,
        WifApplication(),
        "1'/2'",
      );
      final entropy2 = Bip85Entropy.derive(
        TestValues.masterKey,
        WifApplication(),
        "1'/3'",
      );
      expect(entropy1, isNot(equals(entropy2)));
      expect(entropy1.length, equals(64));
      expect(entropy2.length, equals(64));
    });

    test('derive with multiple indices', () {
      final entropy1 = Bip85Entropy.derive(
        TestValues.masterKey,
        WifApplication(),
        "0'/1'/2'",
      );
      final entropy2 = Bip85Entropy.derive(
        TestValues.masterKey,
        WifApplication(),
        "0'/1'/3'",
      );
      expect(entropy1, isNot(equals(entropy2)));
      expect(entropy1.length, equals(64));
      expect(entropy2.length, equals(64));
    });

    test('derive - BIP39 12 words test vector', () {
      // Official BIP85 test vector: m/83696968'/39'/0'/12'/0'
      final entropy = Bip85Entropy.derive(
        TestValues.masterKey,
        MnemonicApplication(),
        "0'/12'/0'",
      );
      expect(entropy.sublist(0, 16), equals(TestValues.bip39_12words_entropy));
    });

    test('derive - BIP39 18 words test vector', () {
      // Official BIP85 test vector: m/83696968'/39'/0'/18'/0'
      final entropy = Bip85Entropy.derive(
        TestValues.masterKey,
        MnemonicApplication(),
        "0'/18'/0'",
      );
      expect(entropy.sublist(0, 24), equals(TestValues.bip39_18words_entropy));
    });

    test('derive - BIP39 24 words test vector', () {
      // Official BIP85 test vector: m/83696968'/39'/0'/24'/0'
      final entropy = Bip85Entropy.derive(
        TestValues.masterKey,
        MnemonicApplication(),
        "0'/24'/0'",
      );
      expect(entropy.sublist(0, 32), equals(TestValues.bip39_24words_entropy));
    });

    test('derive - HD-Seed WIF test vector', () {
      // Official BIP85 test vector: m/83696968'/2'/0'
      final entropy = Bip85Entropy.derive(
        TestValues.masterKey,
        WifApplication(),
        "0'",
      );
      expect(entropy.sublist(0, 32), equals(TestValues.hdSeedWif_entropy));
    });

    test('derive - XPRV test vector', () {
      // Official BIP85 test vector: m/83696968'/32'/0'
      // The spec shows only the private key part (second 32 bytes)
      final entropy = Bip85Entropy.derive(
        TestValues.masterKey,
        XprvApplication(),
        "0'",
      );
      expect(entropy.sublist(32, 64), equals(TestValues.xprv_entropy));
    });

    test('derive - HEX 64 bytes test vector', () {
      // Official BIP85 test vector: m/83696968'/128169'/64'/0'
      final entropy = Bip85Entropy.derive(
        TestValues.masterKey,
        HexApplication(),
        "64'/0'",
      );
      expect(entropy, equals(TestValues.hex64_entropy));
    });

    test('derive - PWD BASE64 test vector', () {
      // Official BIP85 test vector: m/83696968'/707764'/21'/0'
      final entropy = Bip85Entropy.derive(
        TestValues.masterKey,
        PasswordBase64Application(),
        "21'/0'",
      );
      expect(entropy, equals(TestValues.pwdBase64_entropy));
    });

    test('derive - PWD BASE85 test vector', () {
      // Official BIP85 test vector: m/83696968'/707785'/12'/0'
      final entropy = Bip85Entropy.derive(
        TestValues.masterKey,
        PasswordBase85Application(),
        "12'/0'",
      );
      expect(entropy, equals(TestValues.pwdBase85_entropy));
    });

    test('derive - DICE test vector', () {
      // Official BIP85 test vector: m/83696968'/89101'/6'/10'/0'
      final entropy = Bip85Entropy.derive(
        TestValues.masterKey,
        DiceApplication(),
        "6'/10'/0'",
      );
      expect(entropy, equals(TestValues.dice_entropy));
    });
  });
}
