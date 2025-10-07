/// Base exception for BIP85 related errors.
class Bip85Exception implements Exception {
  /// The error message describing what went wrong.
  final String message;
  const Bip85Exception(this.message);

  @override
  String toString() => message;
}

/// Exception thrown when there is an error with BIP85 application handling.
class Bip85ApplicationException extends Bip85Exception {
  Bip85ApplicationException(super.message);
}
