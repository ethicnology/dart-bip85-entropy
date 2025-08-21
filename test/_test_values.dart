// ignore_for_file: non_constant_identifier_names, constant_identifier_names

/// Official BIP85 test vectors and constants from the specification.
///
/// All values are taken directly from the BIP85 specification at:
/// https://github.com/bitcoin/bips/blob/master/bip-0085.mediawiki
class TestValues {
  /// Master BIP32 root key used in all BIP85 test vectors
  static const String masterKey =
      'xprv9s21ZrQH143K2LBWUUQRFXhucrQqBpKdRRxNVq2zBqsx8HVqFk2uYo8kmbaLLHRdqtQpUm98uKfu3vca1LqdGhUtyoFnCNkfmXRyPXLjbKb';

  /// Test vector 1: m/83696968'/0'/0' entropy
  static const String entropy_0_0 =
      'efecfbccffea313214232d29e71563d941229afb4338c21f9517c41aaa0d16f00b83d2a09ef747e7a64e8e2bd5a14869e693da66ce94ac2da570ab7ee48618f7';

  /// Test vector 2: m/83696968'/0'/1' entropy
  static const String entropy_0_1 =
      '70c6e3e8ebee8dc4c0dbba66076819bb8c09672527c4277ca8729532ad711872218f826919f6b67218adde99018a6df9095ab2b58d803b5b93ec9802085a690e';

  static const String drng_entropy = entropy_0_0;
  static const String drng_80_bytes =
      'b78b1ee6b345eae6836c2d53d33c64cdaf9a696487be81b03e822dc84b3f1cd883d7559e53d175f243e4c349e822a957bbff9224bc5dde9492ef54e8a439f6bc8c7355b87a925a37ee405a7502991111';

  // PATH: m/83696968'/39'/0'/12'/0'
  static const String bip39_12words_entropy =
      '6250b68daf746d12a24d58b4787a714b';
  static const String bip39_12words_mnemonic =
      'girl mad pet galaxy egg matter matrix prison refuse sense ordinary nose';

  // PATH: m/83696968'/39'/0'/18'/0'
  static const String bip39_18words_entropy =
      '938033ed8b12698449d4bbca3c853c66b293ea1b1ce9d9dc';
  static const String bip39_18words_mnemonic =
      'near account window bike charge season chef number sketch tomorrow excuse sniff circle vital hockey outdoor supply token';

  // PATH: m/83696968'/39'/0'/24'/0'
  static const String bip39_24words_entropy =
      'ae131e2312cdc61331542efe0d1077bac5ea803adf24b313a4f0e48e9c51f37f';
  static const String bip39_24words_mnemonic =
      'puppy ocean match cereal symbol another shed magic wrap hammer bulb intact gadget divorce twin tonight reason outdoor destroy simple truth cigar social volcano';

  /// HD-Seed WIF: m/83696968'/2'/0'
  static const String wif =
      'Kzyv4uF39d4Jrw2W7UryTHwZr1zQVNk4dAFyqE6BuMrMh1Za7uhp';

  /// XPRV: m/83696968'/32'/0'
  static const String xprv =
      'xprv9s21ZrQH143K2srSbCSg4m4kLvPMzcWydgmKEnMmoZUurYuBuYG46c6P71UGXMzmriLzCCBvKQWBUv3vPB3m1SATMhp3uEjXHJ42jFg7myX';

  /// HEX 64 bytes entropy: m/83696968'/128169'/64'/0'
  static const String hex64_entropy =
      '492db4698cf3b73a5a24998aa3e9d7fa96275d85724a91e71aa2d645442f878555d078fd1f1f67e368976f04137b1f7a0d19232136ca50c44614af72b5582a5c';

  /// PWD BASE64 password: m/83696968'/707764'/21'/0'
  static const String pwdBase64 = 'dKLoepugzdVJvdL56ogNV';

  /// PWD BASE85 password: m/83696968'/707785'/12'/0'
  static const String pwdBase85 = '_s`{TW89)i4`';

  /// DICE rolls: m/83696968'/89101'/6'/10'/0'
  static const String dice_entropy =
      '5e41f8f5d5d9ac09a20b8a5797a3172b28c806aead00d27e36609e2dd116a59176a738804236586f668da8a51b90c708a4226d7f92259c69f64c51124b6f6cd2';
  static const List<int> diceRolls = [1, 0, 0, 2, 0, 1, 5, 5, 2, 4];
}
