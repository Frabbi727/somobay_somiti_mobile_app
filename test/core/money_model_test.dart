import 'package:flutter_test/flutter_test.dart';
import 'package:somobay_somiti_mobile_app/core/models/enum_value_model.dart';
import 'package:somobay_somiti_mobile_app/core/models/money_model.dart';

void main() {
  test('reads poisha exactly and keeps the backend display text', () {
    final money = MoneyModel.fromJson({'poisha': 100525, 'display': '৳ ১,০০৫.২৫'});

    expect(money.poisha, 100525);
    expect(money.display, '৳ ১,০০৫.২৫');
    expect(money.isPositive, isTrue);
    expect(MoneyModel.fromJson({'poisha': 0, 'display': '৳ ০.০০'}).isPositive, isFalse);
  });

  test('reads an enum value with its localised label and optional colour', () {
    final status = EnumValueModel.fromJson({'value': 'open', 'label': 'বকেয়া', 'color': null});

    expect(status.value, 'open');
    expect(status.label, 'বকেয়া');
    expect(status.color, isNull);
  });
}
