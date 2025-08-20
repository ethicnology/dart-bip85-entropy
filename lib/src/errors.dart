class Bip85Exception implements Exception {
  final String message;
  const Bip85Exception(this.message);

  @override
  String toString() => message;
}

class Bip85ApplicationException extends Bip85Exception {
  Bip85ApplicationException(super.message);
}
