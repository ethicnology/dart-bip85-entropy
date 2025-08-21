import 'package:test/test.dart';
import 'package:bip85/bip85.dart';

void main() {
  group('CustomApplication', () {
    test('throws when using reserved application number', () {
      expect(
        () => CustomApplication.fromNumber(39),
        throwsA(isA<Bip85ApplicationException>()),
      );
    });

    test('throws when parsing path with reserved application number', () {
      expect(
        () => CustomApplication.parsePath("39'/0'/12'/0'"),
        throwsA(isA<Bip85ApplicationException>()),
      );
    });

    test('throws when parsing full path with reserved application number', () {
      expect(
        () => CustomApplication.parsePath("m/83696968'/39'/0'/12'/0'"),
        throwsA(isA<Bip85ApplicationException>()),
      );
    });
  });
}
