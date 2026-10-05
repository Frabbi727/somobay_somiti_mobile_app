class BanglaNumberUtil {
  BanglaNumberUtil._();

  static const Map<String, String> _englishToBanglaDigits = {
    '0': '০',
    '1': '১',
    '2': '২',
    '3': '৩',
    '4': '৪',
    '5': '৫',
    '6': '৬',
    '7': '৭',
    '8': '৮',
    '9': '৯',
  };

  static const Map<String, String> _banglaToEnglishDigits = {
    '০': '0',
    '১': '1',
    '২': '2',
    '৩': '3',
    '৪': '4',
    '৫': '5',
    '৬': '6',
    '৭': '7',
    '৮': '8',
    '৯': '9',
  };

  static String toBangla(dynamic value) {
    if (value == null) return '';
    String text = value.toString();
    _englishToBanglaDigits.forEach((eng, ban) {
      text = text.replaceAll(eng, ban);
    });
    return text;
  }

  static String toEnglish(dynamic value) {
    if (value == null) return '';
    String text = value.toString();
    _banglaToEnglishDigits.forEach((ban, eng) {
      text = text.replaceAll(ban, eng);
    });
    return text;
  }
}
