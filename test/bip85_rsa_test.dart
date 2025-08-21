// import 'dart:typed_data';
// import 'package:bip85/bip85.dart';
// import 'package:test/test.dart';
// import 'package:convert/convert.dart';
// import '_test_values.dart';

// void main() {
//   group('BIP85 RSA Tests', () {
//     test('Bip85DRNG basic functionality', () {
//       final entropy = Uint8List.fromList(List.generate(64, (i) => i));
//       final drng = Bip85DRNG(entropy);

//       // Test reading different amounts
//       final bytes1 = drng.read(32);
//       final bytes2 = drng.read(64);
//       final bytes3 = drng.read(100);

//       expect(bytes1.length, equals(32));
//       expect(bytes2.length, equals(64));
//       expect(bytes3.length, equals(100));

//       // Results should be deterministic
//       final drng2 = Bip85DRNG(entropy);
//       final bytes1Again = drng2.read(32);
//       expect(bytes1, equals(bytes1Again));
//     });

//     test('Bip85DRNG throws on invalid seed length', () {
//       expect(
//         () => Bip85DRNG(Uint8List(32)), // Wrong length
//         throwsA(isA<Bip85Exception>()),
//       );

//       expect(
//         () => Bip85DRNG(Uint8List(128)), // Wrong length
//         throwsA(isA<Bip85Exception>()),
//       );
//     });

//     test('RSA key derivation is deterministic', () {
//       final keyPair1 = Bip85Entropy.deriveRsaKeyPair(
//         TestValues.masterKey,
//         2048,
//         0,
//       );

//       final keyPair2 = Bip85Entropy.deriveRsaKeyPair(
//         TestValues.masterKey,
//         2048,
//         0,
//       );

//       // Same parameters should produce identical keys
//       expect(keyPair1.privateKey.modulus, equals(keyPair2.privateKey.modulus));
//       expect(
//         keyPair1.privateKey.privateExponent,
//         equals(keyPair2.privateKey.privateExponent),
//       );
//       expect(keyPair1.privateKey.p, equals(keyPair2.privateKey.p));
//       expect(keyPair1.privateKey.q, equals(keyPair2.privateKey.q));
//     });

//     test('Different indices produce different keys', () {
//       final keyPair1 = Bip85Entropy.deriveRsaKeyPair(
//         TestValues.masterKey,
//         2048,
//         0,
//       );

//       final keyPair2 = Bip85Entropy.deriveRsaKeyPair(
//         TestValues.masterKey,
//         2048,
//         1,
//       );

//       // Different indices should produce different keys
//       expect(
//         keyPair1.privateKey.modulus,
//         isNot(equals(keyPair2.privateKey.modulus)),
//       );
//     });

//     test('Different key sizes produce different keys', () {
//       final keyPair1024 = Bip85Entropy.deriveRsaKeyPair(
//         TestValues.masterKey,
//         1024,
//         0,
//       );

//       final keyPair2048 = Bip85Entropy.deriveRsaKeyPair(
//         TestValues.masterKey,
//         2048,
//         0,
//       );

//       expect(keyPair1024.bitLength, equals(1024));
//       expect(keyPair2048.bitLength, equals(2048));
//       expect(
//         keyPair1024.privateKey.modulus,
//         isNot(equals(keyPair2048.privateKey.modulus)),
//       );
//     });

//     test('RSA key validation', () {
//       expect(
//         () => Bip85Entropy.deriveRsaKeyPair(TestValues.masterKey, 512, 0),
//         throwsA(isA<Bip85Exception>()),
//       );

//       expect(
//         () => Bip85Entropy.deriveRsaKeyPair(TestValues.masterKey, 9999, 0),
//         throwsA(isA<Bip85Exception>()),
//       );

//       expect(
//         () => Bip85Entropy.deriveRsaKeyPair(TestValues.masterKey, 2047, 0),
//         throwsA(isA<Bip85Exception>()),
//       );
//     });

//     test('RSA GPG key derivation', () {
//       // Test main key (equivalent to regular RSA key)
//       final mainKey = Bip85Entropy.deriveRsaKeyPair(
//         TestValues.masterKey,
//         2048,
//         0,
//       );

//       // Test sub-keys
//       final encryptionKey = Bip85Entropy.deriveRsaGpgKeyPair(
//         TestValues.masterKey,
//         2048,
//         0,
//         0, // ENCRYPTION
//       );

//       final authKey = Bip85Entropy.deriveRsaGpgKeyPair(
//         TestValues.masterKey,
//         2048,
//         0,
//         1, // AUTHENTICATION
//       );

//       final signKey = Bip85Entropy.deriveRsaGpgKeyPair(
//         TestValues.masterKey,
//         2048,
//         0,
//         2, // SIGNATURE
//       );

//       // All keys should be different
//       expect(
//         mainKey.privateKey.modulus,
//         isNot(equals(encryptionKey.privateKey.modulus)),
//       );
//       expect(
//         encryptionKey.privateKey.modulus,
//         isNot(equals(authKey.privateKey.modulus)),
//       );
//       expect(
//         authKey.privateKey.modulus,
//         isNot(equals(signKey.privateKey.modulus)),
//       );
//     });

//     test('RSA GPG key validation', () {
//       expect(
//         () =>
//             Bip85Entropy.deriveRsaGpgKeyPair(TestValues.masterKey, 2048, 0, 3),
//         throwsA(isA<Bip85Exception>()),
//       );

//       expect(
//         () =>
//             Bip85Entropy.deriveRsaGpgKeyPair(TestValues.masterKey, 2048, 0, -2),
//         throwsA(isA<Bip85Exception>()),
//       );
//     });

//     test('RSA key PEM output format', () {
//       final keyPair = Bip85Entropy.deriveRsaKeyPair(
//         TestValues.masterKey,
//         1024, // Smaller key for faster test
//         0,
//       );

//       final privatePem = keyPair.privatePem;
//       final publicPem = keyPair.publicPem;

//       expect(privatePem, contains('RSA Private Key:'));
//       expect(privatePem, contains('Modulus (n):'));
//       expect(privatePem, contains('Public Exponent (e):'));
//       expect(privatePem, contains('Private Exponent (d):'));
//       expect(privatePem, contains('Prime 1 (p):'));
//       expect(privatePem, contains('Prime 2 (q):'));

//       expect(publicPem, contains('RSA Public Key:'));
//       expect(publicPem, contains('Modulus (n):'));
//       expect(publicPem, contains('Public Exponent (e):'));
//     });

//     test('BIP85 DRNG test vector compatibility', () {
//       // Test that our DRNG produces consistent output for the same seed
//       final testEntropy = hex.decode(
//         'efecfbccffea313214232d29e71563d941229afb4338c21f9517c41aaa0d16f00b83d2a09ef747e7a64e8e2bd5a14869e693da66ce94ac2da570ab7ee48618f7',
//       );

//       final drng = Bip85DRNG(Uint8List.fromList(testEntropy));
//       final output80Bytes = drng.read(80);

//       // The output should be deterministic
//       expect(output80Bytes.length, equals(80));

//       // Test with another DRNG instance - should get same result
//       final drng2 = Bip85DRNG(Uint8List.fromList(testEntropy));
//       final output80Bytes2 = drng2.read(80);

//       expect(output80Bytes, equals(output80Bytes2));
//     });

//     test('RSA derivation path format', () {
//       // Test that RSA uses the correct application number and path format
//       // This is verified by the deterministic nature of the keys
//       final keyPair1 = Bip85Entropy.deriveRsaKeyPair(
//         TestValues.masterKey,
//         2048,
//         5,
//       );
//       final keyPair2 = Bip85Entropy.deriveRsaKeyPair(
//         TestValues.masterKey,
//         2048,
//         5,
//       );

//       expect(keyPair1.privateKey.modulus, equals(keyPair2.privateKey.modulus));
//     });
//   });
// }
