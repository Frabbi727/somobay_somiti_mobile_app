import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:somobay_somiti_mobile_app/app/localization/app_translations.dart';
import 'package:somobay_somiti_mobile_app/modules/registration/controller/registration_form_controller.dart';
import 'package:somobay_somiti_mobile_app/modules/registration/view/registration_form_page.dart';

import 'registration_form_controller_test.dart' show RecordingRegistrationRepository;

void main() {
  testWidgets('walks from personal details to contact after saving', (tester) async {
    final repository = RecordingRegistrationRepository();
    Get.put(RegistrationFormController(repository: repository));

    await tester.pumpWidget(GetMaterialApp(translations: AppTranslations(), locale: const Locale('en', 'US'), home: const RegistrationFormPage()));
    await tester.pumpAndSettle();

    await tester.enterText(find.descendant(of: find.byKey(const Key('field_name_en')), matching: find.byType(TextFormField)), 'Karim Mia');
    await tester.tap(find.text('Save and continue'));
    await tester.pumpAndSettle();

    expect(repository.saved.single['name_en'], 'Karim Mia');
    expect(find.text('Email'), findsOneWidget);

    Get.reset();
  });
}
