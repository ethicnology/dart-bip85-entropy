import 'package:bip85/bip85.dart';
import 'package:test/test.dart';

import '_test_values.dart';

void main() {
  group('Dice Tests', () {
    test('derive dice rolls', () {
      final rolls = Bip85Entropy.deriveDiceRolls(
        TestValues.masterKey,
        6,
        10,
        0,
      );
      expect(rolls, isA<List<int>>());
      expect(rolls.length, equals(10));
      for (final roll in rolls) {
        expect(roll, greaterThanOrEqualTo(0));
        expect(roll, lessThan(6));
      }
    });

    test('deterministic results', () {
      final rolls1 = Bip85Entropy.deriveDiceRolls(
        TestValues.masterKey,
        6,
        10,
        0,
      );
      final rolls2 = Bip85Entropy.deriveDiceRolls(
        TestValues.masterKey,
        6,
        10,
        0,
      );
      expect(rolls1, equals(rolls2));
    });

    test('different parameters produce different results', () {
      final rolls1 = Bip85Entropy.deriveDiceRolls(
        TestValues.masterKey,
        6,
        10,
        0,
      );
      final rolls2 = Bip85Entropy.deriveDiceRolls(
        TestValues.masterKey,
        6,
        10,
        1,
      );
      expect(rolls1, isNot(equals(rolls2)));
    });

    test('invalid parameters throw exceptions', () {
      expect(
        () => Bip85Entropy.deriveDiceRolls(TestValues.masterKey, 1, 10, 0),
        throwsA(isA<Bip85Exception>()),
      );
      expect(
        () => Bip85Entropy.deriveDiceRolls(TestValues.masterKey, 6, 0, 0),
        throwsA(isA<Bip85Exception>()),
      );
    });
  });
}
