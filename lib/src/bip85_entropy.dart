import 'dart:typed_data';
import 'package:bip32_keys/bip32_keys.dart' as bip32;
import 'package:bip39_mnemonic/bip39_mnemonic.dart' as bip39;
import 'applications.dart';
import 'errors.dart';
import 'utils.dart';
import 'mnemonic.dart' as mnemonic;
import 'wif.dart' as wif;
import 'xprv.dart' as xprv;
import 'hex.dart' as hex_utils;
import 'pwd_base64.dart' as pwd_base64;
import 'pwd_base85.dart' as pwd_base85;
import 'dice.dart' as dice;

class Bip85Entropy {
  static const String _hmacKey = 'bip-entropy-from-k';

  /// Derives BIP85 entropy from a master key using a custom path after the application number.
  ///
  /// This method accepts both int and String for the third parameter:
  /// - When passed an int, it will be converted to a hardened derivation path (e.g., 0 -> "0'")
  /// - When passed a String, it will be used as-is for complex derivation paths
  ///
  /// The full derivation path will be: m/83696968'/applicationNumber'/customPath
  ///
  /// [xprvBase58] - Base58 encoded extended private key (master key)
  /// [applicationNumber] - The application number for the derivation path
  /// [path] - String path (e.g., "0'/1'/2'" for multiple indices)
  ///
  /// Returns 64 bytes of derived entropy
  static Uint8List derive(
    String xprvBase58,
    Bip85Application application,
    String path,
  ) {
    try {
      final root = bip32.Bip32Keys.fromBase58(xprvBase58);

      // Build the full BIP85 path: m/83696968'/app_no'/custom_path
      final derivationPath = "m/83696968'/${application.number}'/$path";
      final derivedKey = root.derivePath(derivationPath);

      // Get the private key bytes
      final privateKeyBytes = derivedKey.private!;

      // Apply HMAC-SHA512 with key "bip-entropy-from-k"
      final keyBytes = Uint8List.fromList(_hmacKey.codeUnits);
      final out = Utils.hmacSha512(keyBytes, privateKeyBytes);

      return out;
    } catch (e) {
      throw Bip85Exception('Failed to derive BIP85 entropy with path: $e');
    }
  }

  /// Derives a BIP39 mnemonic according to BIP85 specification.
  ///
  /// Path format: m/83696968'/39'/language'/words'/index'
  ///
  /// [xprvBase58] - Base58 encoded extended private key (master key)
  /// [language] - Language code (0=English, 1=Japanese, etc.)
  /// [wordCount] - Number of words (12, 15, 18, 21, 24)
  /// [index] - Index for multiple mnemonics
  ///
  /// Returns the BIP39 mnemonic string
  static String deriveMnemonic(
    String xprvBase58,
    bip39.Language language,
    bip39.MnemonicLength length,
    int index,
  ) {
    return mnemonic.deriveMnemonic(xprvBase58, language, length, index);
  }

  /// Derives HD-Seed WIF according to BIP85 specification.
  ///
  /// Path format: m/83696968'/2'/index'
  /// Uses most significant 256 bits as private key for WIF encoding.
  ///
  /// [xprvBase58] - Base58 encoded extended private key (master key)
  /// [index] - Index for multiple WIF keys
  ///
  /// Returns the WIF-encoded private key
  static String deriveWif(String xprvBase58, int index) {
    return wif.deriveWif(xprvBase58, index);
  }

  /// Derives XPRV according to BIP85 specification.
  ///
  /// Path format: m/83696968'/32'/index'
  /// First 32 bytes = chain code, second 32 bytes = private key
  ///
  /// [xprvBase58] - Base58 encoded extended private key (master key)
  /// [index] - Index for multiple XPRV keys
  ///
  /// Returns the XPRV string
  static String deriveXprv(String xprvBase58, int index) {
    return xprv.deriveXprv(xprvBase58, index);
  }

  /// Derives hex entropy according to BIP85 specification.
  ///
  /// Path format: m/83696968'/128169'/num_bytes'/index'
  ///
  /// [xprvBase58] - Base58 encoded extended private key (master key)
  /// [numBytes] - Number of bytes to return (16-64)
  /// [index] - Index for multiple hex values
  ///
  /// Returns hex-encoded entropy
  static String deriveHex(String xprvBase58, int numBytes, int index) {
    return hex_utils.deriveHex(xprvBase58, numBytes, index);
  }

  /// Derives Base64 password according to BIP85 specification.
  ///
  /// Path format: m/83696968'/707764'/pwd_len'/index'
  ///
  /// [xprvBase58] - Base58 encoded extended private key (master key)
  /// [pwdLen] - Password length (20-86)
  /// [index] - Index for multiple passwords
  ///
  /// Returns Base64-encoded password
  static String derivePasswordBase64(String xprvBase58, int pwdLen, int index) {
    return pwd_base64.derivePasswordBase64(xprvBase58, pwdLen, index);
  }

  /// Derives Base85 password according to BIP85 specification.
  ///
  /// Path format: m/83696968'/707785'/pwd_len'/index'
  ///
  /// [xprvBase58] - Base58 encoded extended private key (master key)
  /// [pwdLen] - Password length (10-80)
  /// [index] - Index for multiple passwords
  ///
  /// Returns Base85-encoded password
  static String derivePasswordBase85(String xprvBase58, int pwdLen, int index) {
    return pwd_base85.derivePasswordBase85(xprvBase58, pwdLen, index);
  }

  /// Derives dice rolls according to BIP85 specification.
  ///
  /// Path format: m/83696968'/89101'/sides'/rolls'/index'
  ///
  /// [xprvBase58] - Base58 encoded extended private key (master key)
  /// [sides] - Number of sides on the die (2 to 2^32-1)
  /// [rolls] - Number of rolls to generate (1 to 2^32-1)
  /// [index] - Index for multiple sets of rolls
  ///
  /// Returns list of dice roll values
  static List<int> deriveDiceRolls(
    String xprvBase58,
    int sides,
    int rolls,
    int index,
  ) {
    return dice.deriveDiceRolls(xprvBase58, sides, rolls, index);
  }
}
