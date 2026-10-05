import '../utils/bangla_number_util.dart';

extension StringExtensions on String {
  String toBanglaDigits() => BanglaNumberUtil.toBangla(this);
  String toEnglishDigits() => BanglaNumberUtil.toEnglish(this);

  String capitalizeFirstLetter() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
