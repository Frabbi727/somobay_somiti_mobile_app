import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:somobay_somiti_mobile_app/app/localization/app_translations.dart';
import 'package:somobay_somiti_mobile_app/core/utils/api_date_format.dart';

void main() {
  setUp(() {
    Get.addTranslations(AppTranslations().keys);
  });

  test('formats API months, dates and timestamps in Bangla and English', () {
    Get.locale = const Locale('bn', 'BD');
    expect(ApiDateFormat.month('2026-08'), 'আগস্ট ২০২৬');
    expect(ApiDateFormat.date('2026-08-05'), '০৫ আগস্ট ২০২৬');
    expect(ApiDateFormat.dateTime('2026-08-12T10:05:00+06:00'), '১২ আগস্ট ২০২৬, ১০:০৫');

    Get.locale = const Locale('en', 'US');
    expect(ApiDateFormat.month('2026-08'), 'August 2026');
    expect(ApiDateFormat.date('2026-08-05'), '05 August 2026');
    expect(ApiDateFormat.month(null), '—');
  });
}
