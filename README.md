# BIP85 Dart
[![codecov](https://codecov.io/gh/ethicnology/dart-bip85-entropy/graph/badge.svg?token=A7B2U9MS1L)](https://codecov.io/gh/ethicnology/dart-bip85-entropy)

A pure Dart implementation of [BIP85](https://github.com/bitcoin/bips/blob/master/bip-0085.mediawiki) - Deterministic Entropy From BIP32 Keychains.

## Features
- [x] **BIP39 Mnemonics**
- [x] **HD-Seed WIF**
- [x] **XPRV**
- [x] **HEX**
- [x] **PWD BASE64**
- [x] **PWD BASE85**
- [x] **Custom Path**
- [ ] **RSA**
- [ ] **RSA GPG**
- [ ] **DICE**

## Quick Start

```dart
import 'package:bip85_entropy/bip85_entropy.dart';
import 'package:convert/convert.dart';

void main() {
  // Master BIP32 root key from BIP85 test vectors
  const masterKey =
      'xprv9s21ZrQH143K2LBWUUQRFXhucrQqBpKdRRxNVq2zBqsx8HVqFk2uYo8kmbaLLHRdqtQpUm98uKfu3vca1LqdGhUtyoFnCNkfmXRyPXLjbKb';

  // Path-based derivation (recommended: use deriveFromHardenedPath)
  // To avoid missing a single quote `'` in one of your path component
  print('\n🛤️  Path-based Derivation');
  print('-' * 40);

  // Type-safe hardened path validation (recommended)
  final hardenedPath = Bip85HardenedPath(path: "39'/0'/12'/0'");
  final mnemonicFromHardenedPath = Bip85Entropy.deriveFromHardenedPath(
    xprvBase58: masterKey,
    hardenedPath: hardenedPath,
  );
  print('Mnemonic: $mnemonicFromHardenedPath');

  // String-based path (also available)
  final mnemonicFromRawPath = Bip85Entropy.deriveFromRawPath(
    xprvBase58: masterKey,
    rawPath: "39'/0'/12'/0'",
  );
  print('Mnemonic: $mnemonicFromRawPath');
  print('Same result but HardenedPath avoid to forget a single quote for a path component: ${mnemonicFromRawPath == mnemonicFromHardenedPath}');

  // 1. BIP39 Mnemonic Generation
  print('\n📝 BIP39 Mnemonic Generation');
  print('-' * 40);

  final index = 0;
  final mnemonic12 = Bip85Entropy.deriveMnemonic(
    xprvBase58: masterKey,
    language: Language.english,
    length: MnemonicLength.words12,
    index: index,
  );
  print('12-word: ${mnemonic12.sentence}');
  print(
    "derivation path: ${Bip85Entropy.pathPrefix}/${MnemonicApplication().number}'/${Language.english.toBip85Code()}'/${MnemonicLength.words12.toBip85Code()}'/$index'",
  );

  final mnemonic24 = Bip85Entropy.deriveMnemonic(
    xprvBase58: masterKey,
    language: Language.english,
    length: MnemonicLength.words24,
    index: 0,
  );
  print('24-word: ${mnemonic24.sentence}');

  // 2. Password Generation
  print('\n🔐 Password Generation');
  print('-' * 40);

  final base64Password = Bip85Entropy.derivePasswordBase64(
    xprvBase58: masterKey,
    pwdLen: 21,
    index: 0,
  );
  print('Base64 (21 chars): $base64Password');
  print(
    "derivation path: ${Bip85Entropy.pathPrefix}/${PasswordBase64Application().number}'/${21}'/${0}'",
  );

  final base85Password = Bip85Entropy.derivePasswordBase85(
    xprvBase58: masterKey,
    pwdLen: 12,
    index: 0,
  );

  print('Base85 (12 chars): $base85Password');
  print(
    "derivation path: ${Bip85Entropy.pathPrefix}/${PasswordBase85Application().number}'/${12}'/${0}'",
  );
  // 3. Cryptographic Keys
  print('\n🗝️  Keys');
  print('-' * 40);

  final wif = Bip85Entropy.deriveWif(xprvBase58: masterKey, index: 0);
  print('WIF Private Key: $wif');
  print(
    "derivation path: ${Bip85Entropy.pathPrefix}/${WifApplication().number}'/${0}'",
  );

  final xprv = Bip85Entropy.deriveXprv(xprvBase58: masterKey, index: 0);
  print('Extended Private Key: $xprv');
  print(
    "derivation path: ${Bip85Entropy.pathPrefix}/${XprvApplication().number}'/${0}'",
  );

  // 4. Raw Entropy/Hex
  print('\nHex');
  print('-' * 40);

  final hex32 = Bip85Entropy.deriveHex(
    xprvBase58: masterKey,
    numBytes: 32,
    index: 0,
  );
  print('32 bytes hex: $hex32');
  print(
    "derivation path: ${Bip85Entropy.pathPrefix}/${HexApplication().number}'/${32}'/${0}'",
  );

  final hex16 = Bip85Entropy.deriveHex(
    xprvBase58: masterKey,
    numBytes: 16,
    index: 1,
  );
  print('16 bytes hex: $hex16');
  print(
    "derivation path: ${Bip85Entropy.pathPrefix}/${HexApplication().number}'/${16}'/${1}'",
  );

  // 5. Custom Application Example
  print('\nCustom Application');
  print('-' * 40);

  final customApp = CustomApplication.fromNumber(999999);
  final customEntropy = Bip85Entropy.derive(
    xprvBase58: masterKey,
    application: customApp,
    path: "0'/1'",
  );
  print('Custom app entropy: ${hex.encode(customEntropy)}');
  print(
    "derivation path: ${Bip85Entropy.pathPrefix}/${customApp.number}'/${0}'/${1}'",
  );
}
```

## Type-Safe Path Validation

The library provides `Bip85HardenedPath` for compile-time path validation:

```dart
// ✅ Valid hardened path
final validPath = Bip85HardenedPath(path: "39'/0'/12'/0'");

// ❌ Throws exception - non-hardened component
try {
  Bip85HardenedPath(path: "39/0'/12'/0'"); // Missing quote on first component
} catch (e) {
  print('Invalid path: $e');
}

// ❌ Throws exception - missing quote
try {
  Bip85HardenedPath(path: "39'/0'/12'/0"); // Missing quote on last component
} catch (e) {
  print('Invalid path: $e');
}
```

### We recommend `deriveFromHardenedPath` over `deriveFromRawPath`?

- **🛡️ Type Safety**: Compile-time validation of hardened derivation paths
- **🔒 BIP85 Compliance**: Ensures all components use hardened derivation (required by BIP85)
- **⚡ Same Performance**: Identical output to `deriveFromRawPath` with zero overhead
- **🐛 Early Error Detection**: Catches invalid paths before derivation attempts

```
