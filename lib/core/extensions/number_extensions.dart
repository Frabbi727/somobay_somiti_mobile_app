import '../utils/currency_formatter.dart';
import '../utils/bangla_number_util.dart';

extension NumberExtensions on num {
  String toCurrency({bool showSymbol = true}) =>
      CurrencyFormatter.format(this, showSymbol: showSymbol);

  String toBanglaDigits() => BanglaNumberUtil.toBangla(this);
}
