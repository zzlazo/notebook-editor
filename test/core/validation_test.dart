import 'package:flutter_test/flutter_test.dart';
import 'package:notebook_editor/core/validation.dart';

void main() {
  group('TitleValidation', () {
    test('0 文字は不正', () {
      expect(TitleValidation.isValid(''), isFalse);
    });

    test('1 文字は妥当', () {
      expect(TitleValidation.isValid('a' * 1), isTrue);
    });

    test('50 文字は妥当', () {
      expect(TitleValidation.isValid('a' * 50), isTrue);
    });

    test('51 文字は不正', () {
      expect(TitleValidation.isValid('a' * 51), isFalse);
    });

    test('日本語は 1 文字として数える', () {
      expect(TitleValidation.isValid('あ' * 50), isTrue);
      expect(TitleValidation.isValid('あ' * 51), isFalse);
    });

    // 書記素クラスタで数えるには characters パッケージの追加が要るため、あえて UTF-16 単位のまま扱う。
    // 上限に対しては厳しい側にずれるだけで、制約を超えた値は保存されない。
    test('絵文字は UTF-16 単位で 2 文字として数える', () {
      expect(TitleValidation.isValid('😀' * 25), isTrue);
      expect(TitleValidation.isValid('😀' * 26), isFalse);
    });
  });

  group('BodyValidation', () {
    test('9 文字は不正', () {
      expect(BodyValidation.isValid('a' * 9), isFalse);
    });

    test('10 文字は妥当', () {
      expect(BodyValidation.isValid('a' * 10), isTrue);
    });

    test('2000 文字は妥当', () {
      expect(BodyValidation.isValid('a' * 2000), isTrue);
    });

    test('2001 文字は不正', () {
      expect(BodyValidation.isValid('a' * 2001), isFalse);
    });

    test('絵文字は UTF-16 単位で 2 文字として数える', () {
      expect(BodyValidation.isValid('😀' * 4), isFalse);
      expect(BodyValidation.isValid('😀' * 5), isTrue);
      expect(BodyValidation.isValid('😀' * 1000), isTrue);
      expect(BodyValidation.isValid('😀' * 1001), isFalse);
    });
  });
}
