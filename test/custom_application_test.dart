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
  });
}
