import 'package:bip85/bip85.dart';
import 'package:convert/convert.dart';

String deriveFromPath({required String xprvBase58, required String path}) {
  final application = Bip85Application.fromPath(path);
  switch (application) {
    case MnemonicApplication():
      final params = MnemonicApplication.parsePath(path);
      final mnemonic = Bip85Entropy.deriveMnemonic(
        xprvBase58: xprvBase58,
        language: params.language,
        length: params.length,
        index: params.index,
      );
      return mnemonic.sentence;
    case HexApplication():
      final params = HexApplication.parsePath(path);
      return Bip85Entropy.deriveHex(
        xprvBase58: xprvBase58,
        numBytes: params.numBytes,
        index: params.index,
      );
    case WifApplication():
      final params = WifApplication.parsePath(path);
      return Bip85Entropy.deriveWif(
        xprvBase58: xprvBase58,
        index: params.index,
      );
    case XprvApplication():
      final params = XprvApplication.parsePath(path);
      return Bip85Entropy.deriveXprv(
        xprvBase58: xprvBase58,
        index: params.index,
      );
    case PasswordBase64Application():
      final params = PasswordBase64Application.parsePath(path);
      return Bip85Entropy.derivePasswordBase64(
        xprvBase58: xprvBase58,
        pwdLen: params.pwdLen,
        index: params.index,
      );
    case PasswordBase85Application():
      final params = PasswordBase85Application.parsePath(path);
      return Bip85Entropy.derivePasswordBase85(
        xprvBase58: xprvBase58,
        pwdLen: params.pwdLen,
        index: params.index,
      );
    case CustomApplication():
      final params = CustomApplication.parsePath(path);
      final hexEntropy = hex.encode(
        Bip85Entropy.derive(
          xprvBase58: xprvBase58,
          application: params.application,
          path: params.remainingPath,
        ),
      );
      return hexEntropy;
    default:
      throw Bip85Exception(
        'Application ${application.runtimeType} is not supported.',
      );
  }
}
