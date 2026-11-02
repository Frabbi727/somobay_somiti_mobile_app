import 'package:get/get.dart';
import 'bangla_number_util.dart';

/// Shows the API's dates (`YYYY-MM-DD`), months (`YYYY-MM`) and ISO timestamps in the member's
/// language, with Bangla digits for Bangla. Never used for calculations.
class ApiDateFormat {
  ApiDateFormat._();

  static const String empty = '—';

  /// "2026-08" → "আগস্ট ২০২৬" / "August 2026".
  static String month(String? yearMonth) {
    final parts = yearMonth?.split('-');
    if (parts == null || parts.length < 2) return empty;
    return _digits('${_monthName(parts[1])} ${parts[0]}');
  }

  /// "2026-08-05" → "০৫ আগস্ট ২০২৬" / "05 August 2026".
  static String date(String? date) {
    final parts = date?.split('-');
    if (parts == null || parts.length < 3) return empty;
    return _digits('${parts[2].substring(0, 2)} ${_monthName(parts[1])} ${parts[0]}');
  }

  /// ISO timestamp (already in Bangladesh time) → "১২ আগস্ট ২০২৬, ১০:০৫".
  static String dateTime(String? timestamp) {
    if (timestamp == null || timestamp.length < 16) return empty;
    return '${date(timestamp.substring(0, 10))}, ${_digits(timestamp.substring(11, 16))}';
  }

  static String _monthName(String month) => 'month_${int.tryParse(month) ?? 0}'.tr;

  static String _digits(String text) => Get.locale?.languageCode == 'bn' ? BanglaNumberUtil.toBangla(text) : text;
}
