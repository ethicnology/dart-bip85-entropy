import 'package:bip85/bip85.dart';

class Bip85Application {
  final int number;

  const Bip85Application._({required this.number});

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

  static Bip85Application fromPath(String path) {
    path = removePrefixFromPathIfAny(path);
    final split = path.replaceAll("'", '').split('/');
    final applicationNumber = int.parse(split.first);
    return fromNumber(applicationNumber);
  }

  static String removePrefixFromPathIfAny(String path) {
    final prefix = "${Bip85Entropy.pathPrefix}/";
    if (path.contains(prefix)) path = path.replaceAll(prefix, '');
    return path;
  }

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

class MnemonicApplication extends Bip85Application {
  const MnemonicApplication() : super._(number: 39);

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

class HexApplication extends Bip85Application {
  const HexApplication() : super._(number: 128169);

  static ({int numBytes, int index}) parsePath(String path) {
    final components = Bip85Application.parsePathComponents(
      path: path,
      application: HexApplication(),
    );

    return (numBytes: components[0], index: components[1]);
  }
}

class DiceApplication extends Bip85Application {
  const DiceApplication() : super._(number: 89101);

  static ({int sides, int rolls, int index}) parsePath(String path) {
    final components = Bip85Application.parsePathComponents(
      path: path,
      application: DiceApplication(),
    );

    return (sides: components[0], rolls: components[1], index: components[2]);
  }
}

class PasswordBase64Application extends Bip85Application {
  const PasswordBase64Application() : super._(number: 707764);

  static ({int pwdLen, int index}) parsePath(String path) {
    final components = Bip85Application.parsePathComponents(
      path: path,
      application: PasswordBase64Application(),
    );

    return (pwdLen: components[0], index: components[1]);
  }
}

class PasswordBase85Application extends Bip85Application {
  const PasswordBase85Application() : super._(number: 707785);

  static ({int pwdLen, int index}) parsePath(String path) {
    final components = Bip85Application.parsePathComponents(
      path: path,
      application: PasswordBase85Application(),
    );

    return (pwdLen: components[0], index: components[1]);
  }
}

class WifApplication extends Bip85Application {
  const WifApplication() : super._(number: 2);

  static ({int index}) parsePath(String path) {
    final components = Bip85Application.parsePathComponents(
      path: path,
      application: WifApplication(),
    );

    return (index: components.last);
  }
}

class XprvApplication extends Bip85Application {
  const XprvApplication() : super._(number: 32);

  static ({int index}) parsePath(String path) {
    final components = Bip85Application.parsePathComponents(
      path: path,
      application: XprvApplication(),
    );

    return (index: components.last);
  }
}

class RsaApplication extends Bip85Application {
  const RsaApplication() : super._(number: 828365);
}

class CustomApplication implements Bip85Application {
  @override
  final int number;

  const CustomApplication._({required this.number});

  /// Factory constructor that validates the application number
  /// and throws an error if it conflicts with a standard application
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
