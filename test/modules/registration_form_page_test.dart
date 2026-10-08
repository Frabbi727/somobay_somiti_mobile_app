import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:somobay_somiti_mobile_app/app/localization/app_translations.dart';
import 'package:somobay_somiti_mobile_app/core/errors/failures.dart';
import 'package:somobay_somiti_mobile_app/modules/registration/controller/registration_form_controller.dart';
import 'package:somobay_somiti_mobile_app/modules/registration/model/registration_model.dart';
import 'package:somobay_somiti_mobile_app/modules/registration/view/registration_form_page.dart';

import '../support/fixtures.dart';

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

  testWidgets("shows the server's error under the nominee field it belongs to", (tester) async {
    final repository = RecordingRegistrationRepository()
      ..answers.add(const ValidationFailure(message: 'invalid', errors: {'nominees.0.nid': ['This NID is already a nominee.']}));
    final controller = Get.put(RegistrationFormController(repository: repository))..skipValidationForTests = true;

    await tester.pumpWidget(GetMaterialApp(translations: AppTranslations(), locale: const Locale('en', 'US'), home: const RegistrationFormPage()));
    await tester.pumpAndSettle();
    controller.currentStep.value = 2;
    controller.nominees.first.shareController.text = '100';
    controller.nominees.refresh();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save and continue'));
    await tester.pumpAndSettle();

    expect(find.text('This NID is already a nominee.'), findsOneWidget);
    expect(controller.currentStep.value, 2);

    Get.reset();
  });

  testWidgets('keeps the reason in sight while correcting a returned registration', (tester) async {
    final repository = RecordingRegistrationRepository()
      ..draft = () {
        final json = fixture('registration_invited')['data'] as Map<String, dynamic>;
        json['decision'] = {
          'type': {'value': 'return', 'label': 'Sent back', 'color': 'warning'},
          'by_role': 'President',
          'at': '2026-10-08T01:06:00+06:00',
          'reason': 'Please add a photo',
        };
        return RegistrationModel.fromJson(json);
      };
    Get.put(RegistrationFormController(repository: repository));

    await tester.pumpWidget(GetMaterialApp(translations: AppTranslations(), locale: const Locale('en', 'US'), home: const RegistrationFormPage()));
    await tester.pumpAndSettle();

    expect(find.text('Reason (President): Please add a photo'), findsOneWidget);

    Get.reset();
  });

  testWidgets('accepts the requested shares typed in Bangla digits', (tester) async {
    final repository = RecordingRegistrationRepository();
    final controller = Get.put(RegistrationFormController(repository: repository));

    await tester.pumpWidget(GetMaterialApp(translations: AppTranslations(), locale: const Locale('en', 'US'), home: const RegistrationFormPage()));
    await tester.pumpAndSettle();
    controller.currentStep.value = 3;
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).first, '৫');
    await tester.tap(find.text('Save and continue'));
    await tester.pumpAndSettle();

    expect(repository.saved.single, {'requested_shares': 5});

    Get.reset();
  });
}
