import 'package:bip85_entropy/bip85_entropy.dart';
import 'package:test/test.dart';

void main() {
  group('Application parsePath Tests', () {
    test('MnemonicApplication parsePath', () {
      const path = "m/83696968'/39'/0'/12'/0'";
      final result = MnemonicApplication.parsePath(path);

      expect(result.language, equals(Language.english));
      expect(result.length, equals(MnemonicLength.words12));
      expect(result.index, equals(0));
    });

    test('HexApplication parsePath', () {
      const path = "m/83696968'/128169'/64'/0'";
      final result = HexApplication.parsePath(path);

      expect(result.numBytes, equals(64));
      expect(result.index, equals(0));
    });

    test('DiceApplication parsePath', () {
      const path = "m/83696968'/89101'/6'/10'/0'";
      final result = DiceApplication.parsePath(path);

      expect(result.sides, equals(6));
      expect(result.rolls, equals(10));
      expect(result.index, equals(0));
    });

    test('PasswordBase64Application parsePath', () {
      const path = "m/83696968'/707764'/21'/0'";
      final result = PasswordBase64Application.parsePath(path);

      expect(result.pwdLen, equals(21));
      expect(result.index, equals(0));
    });

    test('PasswordBase85Application parsePath', () {
      const path = "m/83696968'/707785'/12'/0'";
      final result = PasswordBase85Application.parsePath(path);

      expect(result.pwdLen, equals(12));
      expect(result.index, equals(0));
    });

    test('WifApplication parsePath', () {
      const path = "m/83696968'/2'/0'";
      final result = WifApplication.parsePath(path);

      expect(result.index, equals(0));
    });

    test('XprvApplication parsePath', () {
      const path = "m/83696968'/32'/0'";
      final result = XprvApplication.parsePath(path);

      expect(result.index, equals(0));
    });

    test('MnemonicApplication parsePath without prefix', () {
      const path = "39'/1'/24'/5'";
      final result = MnemonicApplication.parsePath(path);

      expect(result.language, equals(Language.japanese));
      expect(result.length, equals(MnemonicLength.words24));
      expect(result.index, equals(5));
    });

    test('MnemonicApplication parsePath without app number', () {
      const path = "3'/18'/10'";
      final result = MnemonicApplication.parsePath(path);

      expect(result.language, equals(Language.spanish));
      expect(result.length, equals(MnemonicLength.words18));
      expect(result.index, equals(10));
    });
  });
}
