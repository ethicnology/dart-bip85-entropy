import 'errors.dart';

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
}

class MnemonicApplication extends Bip85Application {
  const MnemonicApplication() : super._(number: 39);
}

class HexApplication extends Bip85Application {
  const HexApplication() : super._(number: 128169);
}

class DiceApplication extends Bip85Application {
  const DiceApplication() : super._(number: 89101);
}

class PasswordBase64Application extends Bip85Application {
  const PasswordBase64Application() : super._(number: 707764);
}

class PasswordBase85Application extends Bip85Application {
  const PasswordBase85Application() : super._(number: 707785);
}

class WifApplication extends Bip85Application {
  const WifApplication() : super._(number: 2);
}

class XprvApplication extends Bip85Application {
  const XprvApplication() : super._(number: 32);
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
}
