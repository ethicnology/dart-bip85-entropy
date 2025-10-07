import 'package:bip85_entropy/bip85_entropy.dart';

/// Base class for BIP85 applications.
/// Each application has a unique number that identifies its purpose.
class Bip85Application {
  /// The application number according to BIP85 specification.
  final int number;

  const Bip85Application._({required this.number});

  /// Creates a [Bip85Application] from its numeric identifier.
  /// Returns the appropriate application subclass based on the [number].
  static Bip85Application fromNumber(int number) {
    switch (number) {
      case 39:
        return MnemonicApplication();
      case 128169:
        return HexApplication();
      case 89101:
        return DiceApplication();
      case 707764:
        return PasswordBase64Application();
      case 707785:
        return PasswordBase85Application();
      case 2:
        return WifApplication();
      case 32:
        return XprvApplication();
      case 828365:
        return RsaApplication();
      default:
        return CustomApplication._(number: number);
    }
  }

  /// Creates a [Bip85Application] by parsing the application number from a derivation path.
  static Bip85Application fromPath(String path) {
    path = removePrefixFromPathIfAny(path);
    final split = path.replaceAll("'", '').split('/');
    final applicationNumber = int.parse(split.first);
    return fromNumber(applicationNumber);
  }

  /// Removes the BIP85 path prefix from a path string if present.
  static String removePrefixFromPathIfAny(String path) {
    final prefix = "${Bip85Entropy.pathPrefix}/";
    if (path.contains(prefix)) path = path.replaceAll(prefix, '');
    return path;
  }

  /// Parses the path components from a derivation path string.
  /// Returns a list of integers representing each path component.
  static List<int> parsePathComponents({
    required String path,
    required Bip85Application application,
  }) {
    path = removePrefixFromPathIfAny(path);

    final applicationPrefix = "${application.number}'/";
    if (path.contains(applicationPrefix)) {
      path = path.replaceAll(applicationPrefix, '');
    }

    path = path.replaceAll("'", '');
    final split = path.split('/');

    return split.map((component) => int.parse(component)).toList();
  }
}

/// BIP85 application for deriving BIP39 mnemonic phrases (application number 39).
class MnemonicApplication extends Bip85Application {
  const MnemonicApplication() : super._(number: 39);

  /// Parses a BIP85 mnemonic derivation path and returns the language, length, and index.
  static ({Language language, MnemonicLength length, int index}) parsePath(
    String path,
  ) {
    final components = Bip85Application.parsePathComponents(
      path: path,
      application: MnemonicApplication(),
    );
    final language = Bip39LanguageExtension.fromBip85Code(components[0]);
    final length = Bip39MnemonicLengthExtension.fromBip85Code(components[1]);
    final index = components[2];

    return (language: language, length: length, index: index);
  }
}

/// BIP85 application for deriving hexadecimal entropy (application number 128169).
class HexApplication extends Bip85Application {
  const HexApplication() : super._(number: 128169);

  /// Parses a BIP85 hex derivation path and returns the number of bytes and index.
  static ({int numBytes, int index}) parsePath(String path) {
    final components = Bip85Application.parsePathComponents(
      path: path,
      application: HexApplication(),
    );

    return (numBytes: components[0], index: components[1]);
  }
}

/// BIP85 application for deriving dice rolls (application number 89101).
class DiceApplication extends Bip85Application {
  const DiceApplication() : super._(number: 89101);

  /// Parses a BIP85 dice derivation path and returns the number of sides, rolls, and index.
  static ({int sides, int rolls, int index}) parsePath(String path) {
    final components = Bip85Application.parsePathComponents(
      path: path,
      application: DiceApplication(),
    );

    return (sides: components[0], rolls: components[1], index: components[2]);
  }
}

/// BIP85 application for deriving Base64 encoded passwords (application number 707764).
class PasswordBase64Application extends Bip85Application {
  const PasswordBase64Application() : super._(number: 707764);

  /// Parses a BIP85 password derivation path and returns the password length and index.
  static ({int pwdLen, int index}) parsePath(String path) {
    final components = Bip85Application.parsePathComponents(
      path: path,
      application: PasswordBase64Application(),
    );

    return (pwdLen: components[0], index: components[1]);
  }
}

/// BIP85 application for deriving Base85 encoded passwords (application number 707785).
class PasswordBase85Application extends Bip85Application {
  const PasswordBase85Application() : super._(number: 707785);

  /// Parses a BIP85 password derivation path and returns the password length and index.
  static ({int pwdLen, int index}) parsePath(String path) {
    final components = Bip85Application.parsePathComponents(
      path: path,
      application: PasswordBase85Application(),
    );

    return (pwdLen: components[0], index: components[1]);
  }
}

/// BIP85 application for deriving Wallet Import Format (WIF) keys (application number 2).
class WifApplication extends Bip85Application {
  const WifApplication() : super._(number: 2);

  /// Parses a BIP85 WIF derivation path and returns the index.
  static ({int index}) parsePath(String path) {
    final components = Bip85Application.parsePathComponents(
      path: path,
      application: WifApplication(),
    );

    return (index: components.last);
  }
}

/// BIP85 application for deriving extended private keys (xprv) (application number 32).
class XprvApplication extends Bip85Application {
  const XprvApplication() : super._(number: 32);

  /// Parses a BIP85 xprv derivation path and returns the index.
  static ({int index}) parsePath(String path) {
    final components = Bip85Application.parsePathComponents(
      path: path,
      application: XprvApplication(),
    );

    return (index: components.last);
  }
}

/// BIP85 application for deriving RSA keys (application number 828365).
class RsaApplication extends Bip85Application {
  const RsaApplication() : super._(number: 828365);
}

/// Custom BIP85 application with a user-defined application number.
/// Use this for non-standard BIP85 applications.
class CustomApplication implements Bip85Application {
  @override
  final int number;

  const CustomApplication._({required this.number});

  /// Creates a custom application with the given [number].
  /// Validates that the [number] does not conflict with standard applications.
  /// Throws [Bip85ApplicationException] if the number is reserved.
  static CustomApplication fromNumber(int number) {
    final application = Bip85Application.fromNumber(number);
    if (application is! CustomApplication) {
      throw Bip85ApplicationException(
        'Application number $number is reserved for a ${application.runtimeType} application. '
        'Use the appropriate standard application class instead.',
      );
    }
    return application;
  }

  /// Parses a custom application path and returns the application and remaining path.
  /// Throws [Bip85ApplicationException] if the path uses a reserved application number.
  static ({CustomApplication application, String remainingPath}) parsePath(
    String path,
  ) {
    final application = Bip85Application.fromPath(path);
    if (application is! CustomApplication) {
      throw Bip85ApplicationException(
        'Application number ${application.number} is reserved for a ${application.runtimeType} application. '
        'Use the appropriate standard application class instead.',
      );
    }
    path = Bip85Application.removePrefixFromPathIfAny(path);
    final remainingPath = path.replaceAll("${application.number}'/", '');
    return (application: application, remainingPath: remainingPath);
  }
}
