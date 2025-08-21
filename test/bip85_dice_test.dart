// import 'package:bip85/bip85.dart';
// import 'package:convert/convert.dart';
// import 'package:test/test.dart';

// import '_test_values.dart';

// void main() {
//   group('Dice Tests', () {
//     test('dice entropy', () {
//       final entropy = Bip85Entropy.derive(
//         TestValues.masterKey,
//         DiceApplication(),
//         "6'/10'/0'",
//       );
//       expect(hex.encode(entropy), TestValues.dice_entropy);
//     });
//     test('dice rolls', () {
//       final rolls = Bip85Entropy.deriveDiceRolls(
//         TestValues.masterKey,
//         6,
//         10,
//         0,
//       );
//       expect(rolls, equals(TestValues.diceRolls));
//     });

//     test('invalid parameters throw exceptions', () {
//       expect(
//         () => Bip85Entropy.deriveDiceRolls(TestValues.masterKey, 1, 10, 0),
//         throwsA(isA<Bip85Exception>()),
//       );
//       expect(
//         () => Bip85Entropy.deriveDiceRolls(TestValues.masterKey, 6, 0, 0),
//         throwsA(isA<Bip85Exception>()),
//       );
//     });
//   });
// }
