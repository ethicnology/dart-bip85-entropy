import 'dart:typed_data';
import 'package:bip32_keys/bip32_keys.dart' as bip32;
import 'package:bip39_mnemonic/bip39_mnemonic.dart' as bip39;
import 'package:bip85_entropy/bip85_entropy.dart';

import 'utils.dart';
import 'mnemonic.dart' as mnemonic;
import 'wif.dart' as wif;
import 'xprv.dart' as xprv;
import 'hex.dart' as hex_utils;
import 'pwd_base64.dart' as pwd_base64;
import 'pwd_base85.dart' as pwd_base85;
import 'derive_from_path.dart' as derive_from_path;

class Bip85Entropy {
  static const String _hmacKey = 'bip-entropy-from-k';
  static const int childNumber = 83696968;
  static const String pathPrefix = "m/$childNumber'";

  static Uint8List derive({
    required String xprvBase58,
    required Bip85Application application,
    required String path,
  }) {
    try {
      final root = bip32.Bip32Keys.fromBase58(xprvBase58);

      // Build the full BIP85 path: m/83696968'/app_no'/custom_path
      final derivationPath = "$pathPrefix/${application.number}'/$path";
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

  static String deriveFromRawPath({
    required String xprvBase58,
    required String rawPath,
  }) {
    return derive_from_path.deriveFromPath(
      xprvBase58: xprvBase58,
      path: rawPath,
    );
  }

  static String deriveFromHardenedPath({
    required String xprvBase58,
    required Bip85HardenedPath hardenedPath,
  }) {
    return derive_from_path.deriveFromPath(
      xprvBase58: xprvBase58,
      path: hardenedPath.toString(),
    );
  }

  static bip39.Mnemonic deriveMnemonic({
    required String xprvBase58,
    required bip39.Language language,
    required bip39.MnemonicLength length,
    required int index,
  }) {
    return mnemonic.deriveMnemonic(
      xprvBase58: xprvBase58,
      language: language,
      length: length,
      index: index,
    );
  }

  static String deriveWif({required String xprvBase58, required int index}) {
    return wif.deriveWif(xprvBase58: xprvBase58, index: index);
  }

  static String deriveXprv({required String xprvBase58, required int index}) {
    return xprv.deriveXprv(xprvBase58: xprvBase58, index: index);
  }

  static String deriveHex({
    required String xprvBase58,
    required int numBytes,
    required int index,
  }) {
    return hex_utils.deriveHex(
      xprvBase58: xprvBase58,
      numBytes: numBytes,
      index: index,
    );
  }

  static String derivePasswordBase64({
    required String xprvBase58,
    required int pwdLen,
    required int index,
  }) {
    return pwd_base64.derivePasswordBase64(
      xprvBase58: xprvBase58,
      pwdLen: pwdLen,
      index: index,
    );
  }

  static String derivePasswordBase85({
    required String xprvBase58,
    required int pwdLen,
    required int index,
  }) {
    return pwd_base85.derivePasswordBase85(
      xprvBase58: xprvBase58,
      pwdLen: pwdLen,
      index: index,
    );
  }

  // TODO: Implement Dice Rolls

  // TODO: Implement RSA
}
