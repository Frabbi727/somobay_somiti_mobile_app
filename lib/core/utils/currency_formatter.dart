import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'bangla_number_util.dart';

class CurrencyFormatter {
  CurrencyFormatter._();

  static String format(num? amount, {bool showSymbol = true}) {
    if (amount == null) return showSymbol ? '৳০.০০' : '০.০০';
    
    final formatter = NumberFormat('#,##,##0.00');
    final formatted = formatter.format(amount);
    final isBangla = Get.locale?.languageCode == 'bn';

    if (isBangla) {
      final banglaAmount = BanglaNumberUtil.toBangla(formatted);
      return showSymbol ? '৳$banglaAmount' : banglaAmount;
    }

    return showSymbol ? '$formatted BDT' : formatted;
  }
}
