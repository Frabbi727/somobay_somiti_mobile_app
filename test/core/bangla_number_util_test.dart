import 'package:flutter_test/flutter_test.dart';
import 'package:somobay_somiti_mobile_app/core/utils/bangla_number_util.dart';

void main() {
  group('BanglaNumberUtil Tests', () {
    test('Converts English digits to Bangla correctly', () {
      expect(BanglaNumberUtil.toBangla('0123456789'), '০১২৩৪৫৬৭৮৯');
      expect(BanglaNumberUtil.toBangla(50000), '৫০০০০');
      expect(BanglaNumberUtil.toBangla(''), '');
    });

    test('Converts Bangla digits to English correctly', () {
      expect(BanglaNumberUtil.toEnglish('০১২৩৪৫৬৭৮৯'), '0123456789');
      expect(BanglaNumberUtil.toEnglish('০১৭৯৮৭৬৫৪৩২'), '01798765432');
    });
  });
}
