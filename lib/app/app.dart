import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'bindings/initial_binding.dart';
import 'localization/app_translations.dart';
import 'routes/app_pages.dart';
import 'theme/app_theme.dart';
import '../core/constants/app_constants.dart';
import '../core/services/storage_service.dart';

class SomitiApp extends StatelessWidget {
  const SomitiApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final storage = Get.find<StorageService>();
    final savedLang = storage.getLanguageCode();
    final savedCountry = storage.getCountryCode();

    return GetMaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      initialBinding: InitialBinding(),
      translations: AppTranslations(),
      locale: Locale(savedLang, savedCountry),
      fallbackLocale: const Locale(AppConstants.defaultLocale, AppConstants.defaultCountry),
      defaultTransition: Transition.cupertino,
    );
  }
}
