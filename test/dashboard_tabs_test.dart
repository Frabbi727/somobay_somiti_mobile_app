import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:somobay_somiti_mobile_app/app/localization/app_translations.dart';
import 'package:somobay_somiti_mobile_app/core/constants/api_constants.dart';
import 'package:somobay_somiti_mobile_app/core/services/storage_service.dart';
import 'package:somobay_somiti_mobile_app/modules/dashboard/controller/dashboard_controller.dart';
import 'package:somobay_somiti_mobile_app/modules/dashboard/view/dashboard_page.dart';
import 'package:somobay_somiti_mobile_app/modules/dues/controller/dues_controller.dart';
import 'package:somobay_somiti_mobile_app/modules/dues/repository/dues_repository.dart';
import 'package:somobay_somiti_mobile_app/modules/home/controller/home_controller.dart';
import 'package:somobay_somiti_mobile_app/modules/home/repository/home_repository.dart';
import 'package:somobay_somiti_mobile_app/modules/payments/controller/payments_controller.dart';
import 'package:somobay_somiti_mobile_app/modules/payments/repository/payments_repository.dart';
import 'package:somobay_somiti_mobile_app/modules/profile_settings/controller/profile_controller.dart';
import 'package:somobay_somiti_mobile_app/modules/profile_settings/repository/profile_repository.dart';
import 'package:somobay_somiti_mobile_app/modules/transactions/controller/transaction_controller.dart';
import 'package:somobay_somiti_mobile_app/modules/transactions/repository/transaction_repository.dart';

import 'support/fake_api.dart';
import 'support/fixtures.dart';

class PrefsFreeStorage extends StorageService {
  @override
  String getLanguageCode() => 'bn';

  @override
  String? getString(String key) => null;

  @override
  bool getBool(String key, {bool defaultValue = false}) => defaultValue;
}

void main() {
  tearDown(Get.reset);

  testWidgets('the member app has five tabs: Home, Dues, Payments, Passbook, Profile — in Bangla', (tester) async {
    final page = {'current_page': 1, 'last_page': 1, 'per_page': 20, 'total': 0};
    final api = FakeApi({
      'GET ${ApiConstants.dashboardSummary}': (r) => (200, fixture('dashboard_summary.bn')),
      'GET ${ApiConstants.dues}': (r) => (200, envelope([], meta: page)),
      'GET ${ApiConstants.payments}': (r) => (200, envelope([], meta: page)),
      'GET ${ApiConstants.statement}': (r) => (200, fixture('statement.en')),
      'GET ${ApiConstants.profile}': (r) => (200, fixture('profile.en')),
    }).client();

    Get.put<StorageService>(PrefsFreeStorage());
    Get.put(DashboardController());
    Get.put(HomeController(repository: HomeRepository(apiClient: api)));
    Get.put(DuesController(repository: DuesRepository(apiClient: api)));
    Get.put(PaymentsController(repository: PaymentsRepository(apiClient: api)));
    Get.put(TransactionController(repository: TransactionRepository(apiClient: api)));
    Get.put(ProfileController(repository: ProfileRepository(apiClient: api), storageService: Get.find<StorageService>()));

    await tester.pumpWidget(GetMaterialApp(
      translations: AppTranslations(),
      locale: const Locale('bn', 'BD'),
      home: const DashboardPage(),
    ));
    await tester.pumpAndSettle();

    for (final label in ['হোম', 'বকেয়া', 'পরিশোধ', 'খতিয়ান বই', 'প্রোফাইল']) {
      expect(find.descendant(of: find.byType(NavigationBar), matching: find.text(label)), findsOneWidget, reason: label);
    }
    expect(find.text('রহিম উদ্দিন'), findsOneWidget); // Home shows the member from the API
  });
}
