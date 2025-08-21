import 'package:bip85/bip85.dart';
import 'package:convert/convert.dart';

void main() {
  // Master BIP32 root key from BIP85 test vectors
  const masterKey =
      'xprv9s21ZrQH143K2LBWUUQRFXhucrQqBpKdRRxNVq2zBqsx8HVqFk2uYo8kmbaLLHRdqtQpUm98uKfu3vca1LqdGhUtyoFnCNkfmXRyPXLjbKb';

  // 1. BIP39 Mnemonic Generation
  print('\n📝 BIP39 Mnemonic Generation');
  print('-' * 40);

  final index = 0;
  final mnemonic12 = Bip85Entropy.deriveMnemonic(
    masterKey,
    Language.english,
    MnemonicLength.words12,
    index,
  );
  print('12-word: ${mnemonic12.sentence}');
  print(
    "derivation path: ${Bip85Entropy.pathPrefix}/${MnemonicApplication().number}'/${Language.english.toBip85Code()}'/${MnemonicLength.words12.toBip85Code()}'/$index'",
  );

  final mnemonic24 = Bip85Entropy.deriveMnemonic(
    masterKey,
    Language.english,
    MnemonicLength.words24,
    0,
  );
  print('24-word: ${mnemonic24.sentence}');

  // 2. Password Generation
  print('\n🔐 Password Generation');
  print('-' * 40);

  final base64Password = Bip85Entropy.derivePasswordBase64(masterKey, 21, 0);
  print('Base64 (21 chars): $base64Password');
  print(
    "derivation path: ${Bip85Entropy.pathPrefix}/${PasswordBase64Application().number}'/${21}'/${0}'",
  );

  final base85Password = Bip85Entropy.derivePasswordBase85(masterKey, 12, 0);
  print('Base85 (12 chars): $base85Password');
  print(
    "derivation path: ${Bip85Entropy.pathPrefix}/${PasswordBase85Application().number}'/${12}'/${0}'",
  );
  // 3. Cryptographic Keys
  print('\n🗝️  Keys');
  print('-' * 40);

  final wif = Bip85Entropy.deriveWif(masterKey, 0);
  print('WIF Private Key: $wif');
  print(
    "derivation path: ${Bip85Entropy.pathPrefix}/${WifApplication().number}'/${0}'",
  );

  final xprv = Bip85Entropy.deriveXprv(masterKey, 0);
  print('Extended Private Key: $xprv');
  print(
    "derivation path: ${Bip85Entropy.pathPrefix}/${XprvApplication().number}'/${0}'",
  );

  // 4. Raw Entropy/Hex
  print('\nHex');
  print('-' * 40);

  final hex32 = Bip85Entropy.deriveHex(masterKey, 32, 0);
  print('32 bytes hex: $hex32');
  print(
    "derivation path: ${Bip85Entropy.pathPrefix}/${HexApplication().number}'/${32}'/${0}'",
  );

  final hex16 = Bip85Entropy.deriveHex(masterKey, 16, 1);
  print('16 bytes hex: $hex16');
  print(
    "derivation path: ${Bip85Entropy.pathPrefix}/${HexApplication().number}'/${16}'/${1}'",
  );

  // 5. Custom Application Example
  print('\nCustom Application');
  print('-' * 40);

  final customApp = CustomApplication.fromNumber(999999);
  final customEntropy = Bip85Entropy.derive(masterKey, customApp, "0'/1'");
  print('Custom app entropy: ${hex.encode(customEntropy)}');
  print(
    "derivation path: ${Bip85Entropy.pathPrefix}/${customApp.number}'/${0}'/${1}'",
  );
}
