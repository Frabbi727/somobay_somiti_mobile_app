import 'package:flutter_test/flutter_test.dart';
import 'package:somobay_somiti_mobile_app/core/utils/app_validator.dart';

void main() {
  group('AppValidator Tests', () {
    test('Validates Bangladeshi mobile phone numbers', () {
      expect(AppValidator.validatePhone('01712345678'), isNull);
      expect(AppValidator.validatePhone('০১৮১২৩৪৫৬৭৮'), isNull);
      expect(AppValidator.validatePhone('01212345678'), isNotNull); // 012 invalid prefix
      expect(AppValidator.validatePhone(''), isNotNull);
    });

    test('Validates NID format', () {
      expect(AppValidator.validateNID('1234567890'), isNull); // 10 digit
      expect(AppValidator.validateNID('১২৩৪৫৬৭৮৯০'), isNull); // Bangla 10 digit
      expect(AppValidator.validateNID('12345'), isNotNull);
    });

    test('Validates Password minimum length', () {
      expect(AppValidator.validatePassword('123456'), isNull);
      expect(AppValidator.validatePassword('12345'), isNotNull);
      expect(AppValidator.validatePassword(''), isNotNull);
    });
  });
}
