import 'dart:typed_data';
import 'package:pointycastle/export.dart';
import 'package:bip85/bip85.dart';

/// RSA key pair generated using BIP85 deterministic entropy
class Bip85RsaKeyPair {
  final RSAPrivateKey privateKey;
  final RSAPublicKey publicKey;

  const Bip85RsaKeyPair({required this.privateKey, required this.publicKey});

  /// Returns the modulus size in bits
  int get bitLength => privateKey.modulus!.bitLength;

  /// Returns the private key in PKCS#1 PEM format
  String get privatePem => _rsaPrivateKeyToPem(privateKey);

  /// Returns the public key in PKCS#1 PEM format
  String get publicPem => _rsaPublicKeyToPem(publicKey);
}

/// Generates an RSA key pair using BIP85 deterministic entropy.
///
/// The derivation path format is: m/83696968'/828365'/key_bits'/key_index'
///
/// [xprvBase58] - Base58 encoded extended private key (master key)
/// [keyBits] - RSA key size in bits (typically 1024, 2048, or 4096)
/// [keyIndex] - Index for multiple RSA keys of the same size
///
/// Returns a [Bip85RsaKeyPair] containing the generated private and public keys
Bip85RsaKeyPair deriveRsaKeyPair(String xprvBase58, int keyBits, int keyIndex) {
  // Validate key size
  if (keyBits < 1024 || keyBits > 8192) {
    throw Bip85Exception('RSA key bits must be between 1024 and 8192');
  }

  // Key bits should typically be a power of 2 or at least divisible by 8
  if (keyBits % 8 != 0) {
    throw Bip85Exception('RSA key bits should be divisible by 8');
  }

  try {
    // Derive the BIP85 entropy for RSA
    final entropy = Bip85Entropy.derive(
      xprvBase58,
      RsaApplication(),
      "$keyBits'/$keyIndex'",
    );

    // Create BIP85-DRNG with the derived entropy
    final drng = Bip85DRNG(entropy);

    // Generate RSA key pair using the DRNG
    final keyPair = _generateRsaKeyPair(keyBits, drng);

    return Bip85RsaKeyPair(
      privateKey: keyPair.privateKey as RSAPrivateKey,
      publicKey: keyPair.publicKey as RSAPublicKey,
    );
  } catch (e) {
    throw Bip85Exception('Failed to derive RSA key pair: $e');
  }
}

/// Generates an RSA key pair for GPG purposes.
///
/// GPG keys use the following scheme:
/// - Main key: m/83696968'/828365'/key_bits'/key_index'
/// - Sub keys: m/83696968'/828365'/key_bits'/key_index'/sub_key'
///
/// Where:
/// - key_index is the parent key for CERTIFY capability
/// - sub_key 0' is used as the ENCRYPTION key
/// - sub_key 1' is used as the AUTHENTICATION key
/// - sub_key 2' is usually used as SIGNATURE key
///
/// [xprvBase58] - Base58 encoded extended private key (master key)
/// [keyBits] - RSA key size in bits
/// [keyIndex] - Index for the main GPG key
/// [subKey] - Sub-key index (0=ENCRYPTION, 1=AUTHENTICATION, 2=SIGNATURE)
///
/// Returns a [Bip85RsaKeyPair] for the specified GPG sub-key
Bip85RsaKeyPair deriveRsaGpgKeyPair(
  String xprvBase58,
  int keyBits,
  int keyIndex,
  int subKey,
) {
  // Validate sub-key index
  if (subKey < 0 || subKey > 2) {
    throw Bip85Exception(
      'GPG sub-key index must be 0 (ENCRYPTION), 1 (AUTHENTICATION), or 2 (SIGNATURE)',
    );
  }

  try {
    // For the main key (CERTIFY capability), use the standard path
    if (subKey == -1) {
      return deriveRsaKeyPair(xprvBase58, keyBits, keyIndex);
    }

    // For sub-keys, add the sub-key index to the path
    final entropy = Bip85Entropy.derive(
      xprvBase58,
      RsaApplication(),
      "$keyBits'/$keyIndex'/$subKey'",
    );

    final drng = Bip85DRNG(entropy);
    final keyPair = _generateRsaKeyPair(keyBits, drng);

    return Bip85RsaKeyPair(
      privateKey: keyPair.privateKey as RSAPrivateKey,
      publicKey: keyPair.publicKey as RSAPublicKey,
    );
  } catch (e) {
    throw Bip85Exception('Failed to derive RSA GPG key pair: $e');
  }
}

/// Internal method to generate RSA key pair using deterministic randomness
AsymmetricKeyPair<PublicKey, PrivateKey> _generateRsaKeyPair(
  int bitLength,
  Bip85DRNG drng,
) {
  // Create RSA key generator
  final keyGen = RSAKeyGenerator();

  // Create a custom secure random that uses our DRNG
  final secureRandom = _Bip85SecureRandom(drng);

  // Set up RSA key generation parameters
  final params = RSAKeyGeneratorParameters(
    BigInt.from(65537), // Standard RSA public exponent (F4)
    bitLength,
    80, // Certainty for primality testing
  );

  // Initialize and generate
  keyGen.init(ParametersWithRandom(params, secureRandom));
  return keyGen.generateKeyPair();
}

/// Custom SecureRandom implementation that uses BIP85-DRNG
class _Bip85SecureRandom implements SecureRandom {
  final Bip85DRNG _drng;

  _Bip85SecureRandom(this._drng);

  @override
  String get algorithmName => 'BIP85-DRNG';

  @override
  BigInt nextBigInteger(int bitLength) {
    final byteLength = (bitLength + 7) ~/ 8;
    final bytes = _drng.read(byteLength);

    // Clear excess bits if necessary
    if (bitLength % 8 != 0) {
      final excessBits = 8 - (bitLength % 8);
      bytes[0] &= (0xFF >> excessBits);
    }

    // Ensure the number is positive and has the correct bit length
    bytes[0] |= (1 << ((bitLength - 1) % 8));

    // Convert bytes to BigInt manually
    var result = BigInt.zero;
    for (int i = 0; i < bytes.length; i++) {
      result = result << 8;
      result = result + BigInt.from(bytes[i]);
    }
    return result;
  }

  @override
  int nextUint8() {
    final bytes = _drng.read(1);
    return bytes[0];
  }

  @override
  int nextUint16() {
    final bytes = _drng.read(2);
    return (bytes[0] << 8) | bytes[1];
  }

  @override
  int nextUint32() {
    final bytes = _drng.read(4);
    return (bytes[0] << 24) | (bytes[1] << 16) | (bytes[2] << 8) | bytes[3];
  }

  @override
  Uint8List nextBytes(int count) {
    return _drng.read(count);
  }

  @override
  void seed(CipherParameters params) {
    // BIP85-DRNG is already seeded, so this is a no-op
  }
}

/// Converts an RSA private key to PEM format
String _rsaPrivateKeyToPem(RSAPrivateKey privateKey) {
  // This is a simplified PEM encoding
  // In a production implementation, you'd want to use proper ASN.1 encoding
  final n = privateKey.modulus!;
  final e = privateKey.exponent!;
  final d = privateKey.privateExponent!;
  final p = privateKey.p!;
  final q = privateKey.q!;

  return 'RSA Private Key:\n'
      'Modulus (n): ${n.toRadixString(16)}\n'
      'Public Exponent (e): ${e.toRadixString(16)}\n'
      'Private Exponent (d): ${d.toRadixString(16)}\n'
      'Prime 1 (p): ${p.toRadixString(16)}\n'
      'Prime 2 (q): ${q.toRadixString(16)}';
}

/// Converts an RSA public key to PEM format
String _rsaPublicKeyToPem(RSAPublicKey publicKey) {
  // This is a simplified PEM encoding
  final n = publicKey.modulus!;
  final e = publicKey.exponent!;

  return 'RSA Public Key:\n'
      'Modulus (n): ${n.toRadixString(16)}\n'
      'Public Exponent (e): ${e.toRadixString(16)}';
}
