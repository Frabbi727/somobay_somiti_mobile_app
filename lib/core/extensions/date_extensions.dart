import 'package:intl/intl.dart';
import 'package:get/get.dart';
import '../utils/bangla_number_util.dart';

extension DateExtensions on DateTime {
  String toAppDateFormat({String format = 'dd MMM yyyy'}) {
    final isBangla = Get.locale?.languageCode == 'bn';
    final formatted = DateFormat(format).format(this);
    if (isBangla) {
      return BanglaNumberUtil.toBangla(formatted);
    }
    return formatted;
  }

  String toTimeFormat({String format = 'hh:mm a'}) {
    final isBangla = Get.locale?.languageCode == 'bn';
    final formatted = DateFormat(format).format(this);
    if (isBangla) {
      return BanglaNumberUtil.toBangla(formatted);
    }
    return formatted;
  }
}
