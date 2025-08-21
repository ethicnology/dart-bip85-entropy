import 'package:bip85/bip85.dart';
import 'package:convert/convert.dart';

String deriveFromPath(String xprvBase58, String path) {
  final application = Bip85Application.fromPath(path);
  switch (application) {
    case MnemonicApplication():
      final params = MnemonicApplication.parsePath(path);
      final mnemonic = Bip85Entropy.deriveMnemonic(
        xprvBase58,
        params.language,
        params.length,
        params.index,
      );
      return mnemonic.sentence;
    case HexApplication():
      final params = HexApplication.parsePath(path);
      return Bip85Entropy.deriveHex(xprvBase58, params.numBytes, params.index);
    case WifApplication():
      final params = WifApplication.parsePath(path);
      return Bip85Entropy.deriveWif(xprvBase58, params.index);
    case XprvApplication():
      final params = XprvApplication.parsePath(path);
      return Bip85Entropy.deriveXprv(xprvBase58, params.index);
    case PasswordBase64Application():
      final params = PasswordBase64Application.parsePath(path);
      return Bip85Entropy.derivePasswordBase64(
        xprvBase58,
        params.pwdLen,
        params.index,
      );
    case PasswordBase85Application():
      final params = PasswordBase85Application.parsePath(path);
      return Bip85Entropy.derivePasswordBase85(
        xprvBase58,
        params.pwdLen,
        params.index,
      );
    case CustomApplication():
      final params = CustomApplication.parsePath(path);
      final hexEntropy = hex.encode(
        Bip85Entropy.derive(
          xprvBase58,
          params.application,
          params.remainingPath,
        ),
      );
      return hexEntropy;
    default:
      throw Bip85Exception(
        'Application ${application.runtimeType} is not supported.',
      );
  }
}
