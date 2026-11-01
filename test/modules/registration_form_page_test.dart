import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:somobay_somiti_mobile_app/app/localization/app_translations.dart';
import 'package:somobay_somiti_mobile_app/core/errors/failures.dart';
import 'package:somobay_somiti_mobile_app/modules/registration/controller/registration_form_controller.dart';
import 'package:somobay_somiti_mobile_app/modules/registration/model/registration_model.dart';
import 'package:somobay_somiti_mobile_app/modules/registration/view/registration_form_page.dart';

import '../support/fake_geo_repository.dart';
import '../support/fixtures.dart';

import 'registration_form_controller_test.dart' show RecordingRegistrationRepository;

void main() {
  testWidgets('walks from personal details to contact after saving', (tester) async {
    final repository = RecordingRegistrationRepository();
    Get.put(RegistrationFormController(repository: repository, geoRepository: FakeGeoRepository()));

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
      ..answers.add(
        const ValidationFailure(
          message: 'invalid',
          errors: {
            'nominees.0.nid': ['This NID is already a nominee.'],
          },
        ),
      );
    final controller = Get.put(RegistrationFormController(repository: repository, geoRepository: FakeGeoRepository()))..skipValidationForTests = true;

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
    Get.put(RegistrationFormController(repository: repository, geoRepository: FakeGeoRepository()));

    await tester.pumpWidget(GetMaterialApp(translations: AppTranslations(), locale: const Locale('en', 'US'), home: const RegistrationFormPage()));
    await tester.pumpAndSettle();

    expect(find.text('Reason (President): Please add a photo'), findsOneWidget);

    Get.reset();
  });

  testWidgets('accepts the requested shares typed in Bangla digits', (tester) async {
    final repository = RecordingRegistrationRepository();
    final controller = Get.put(RegistrationFormController(repository: repository, geoRepository: FakeGeoRepository()));

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

  testWidgets('server errors for nominees.0.present_upazila_id show on the nominee card', (tester) async {
    final repository = RecordingRegistrationRepository()
      ..answers.add(
        const ValidationFailure(
          message: 'invalid',
          errors: {
            'nominees.0.present_upazila_id': ['The upazila does not exist.'],
          },
        ),
      );
    final controller = Get.put(RegistrationFormController(repository: repository, geoRepository: FakeGeoRepository()))..skipValidationForTests = true;

    await tester.pumpWidget(GetMaterialApp(translations: AppTranslations(), locale: const Locale('en', 'US'), home: const RegistrationFormPage()));
    await tester.pumpAndSettle();
    controller.currentStep.value = 2;
    controller.nominees.first.shareController.text = '100';
    controller.nominees.refresh();
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save and continue'));
    await tester.pumpAndSettle();

    expect(find.text('The upazila does not exist.', skipOffstage: false), findsOneWidget);
    expect(controller.currentStep.value, 2);

    Get.reset();
  });

  testWidgets('choosing a division keeps the choice and offers its districts', (tester) async {
    final repository = RecordingRegistrationRepository();
    final controller = Get.put(RegistrationFormController(repository: repository, geoRepository: FakeGeoRepository()));

    await tester.pumpWidget(GetMaterialApp(translations: AppTranslations(), locale: const Locale('en', 'US'), home: const RegistrationFormPage()));
    await tester.pumpAndSettle();
    controller.currentStep.value = 1;
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(const Key('member_present_division_field')));
    await tester.tap(find.byKey(const Key('member_present_division_field')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Dhaka').last);
    await tester.pumpAndSettle();

    expect(controller.person.present.divisionId.value, 6);
    expect(find.descendant(of: find.byKey(const Key('member_present_division_field')), matching: find.text('Dhaka')), findsOneWidget);

    await tester.ensureVisible(find.byKey(const Key('member_present_district_field')));
    await tester.tap(find.byKey(const Key('member_present_district_field')));
    await tester.pumpAndSettle();
    expect(find.text('Gazipur'), findsOneWidget);

    Get.reset();
  });

  testWidgets('ticking same as present hides the permanent address', (tester) async {
    final controller = Get.put(RegistrationFormController(repository: RecordingRegistrationRepository(), geoRepository: FakeGeoRepository()));

    await tester.pumpWidget(GetMaterialApp(translations: AppTranslations(), locale: const Locale('en', 'US'), home: const RegistrationFormPage()));
    await tester.pumpAndSettle();
    controller.currentStep.value = 1;
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('member_permanent_division_field'), skipOffstage: false), findsOneWidget);

    await tester.ensureVisible(find.byKey(const Key('member_same_as_present')));
    await tester.tap(find.byKey(const Key('member_same_as_present')));
    await tester.pumpAndSettle();

    expect(controller.person.permanentSameAsPresent.value, isTrue);
    expect(find.byKey(const Key('member_permanent_division_field'), skipOffstage: false), findsNothing);

    Get.reset();
  });

  testWidgets('the union picker stays open after a failed load so Retry can be reached', (tester) async {
    final geo = FakeGeoRepository()..unionsFailure = const NetworkFailure();
    final controller = Get.put(RegistrationFormController(repository: RecordingRegistrationRepository(), geoRepository: geo));

    await tester.pumpWidget(GetMaterialApp(translations: AppTranslations(), locale: const Locale('en', 'US'), home: const RegistrationFormPage()));
    await tester.pumpAndSettle();
    controller.currentStep.value = 1;
    await tester.pumpAndSettle();
    await controller.person.present.selectDivision(6);
    await controller.person.present.selectDistrict(47);
    await controller.person.present.selectUpazila(495);
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.byKey(const Key('member_present_union_field')));
    await tester.tap(find.byKey(const Key('member_present_union_field')));
    await tester.pumpAndSettle();
    expect(find.text('Retry'), findsOneWidget);

    geo.unionsFailure = null;
    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();
    expect(find.text('Gulshan-1'), findsOneWidget);

    Get.reset();
  });

  testWidgets('next is blocked while gender and the address are empty', (tester) async {
    final repository = RecordingRegistrationRepository();
    final controller = Get.put(RegistrationFormController(repository: repository, geoRepository: FakeGeoRepository()));

    await tester.pumpWidget(GetMaterialApp(translations: AppTranslations(), locale: const Locale('en', 'US'), home: const RegistrationFormPage()));
    await tester.pumpAndSettle();
    controller.currentStep.value = 1;
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save and continue'));
    await tester.pumpAndSettle();

    expect(repository.saved, isEmpty);
    expect(controller.currentStep.value, 1);

    Get.reset();
  });

  testWidgets('the review step lists the place names, and skips an empty address', (tester) async {
    final repository = RecordingRegistrationRepository()..draft = () => RegistrationModel.fromJson(fixture('registration_submitted')['data'] as Map<String, dynamic>);
    final controller = Get.put(RegistrationFormController(repository: repository, geoRepository: FakeGeoRepository()));

    await tester.pumpWidget(GetMaterialApp(translations: AppTranslations(), locale: const Locale('en', 'US'), home: const RegistrationFormPage()));
    await tester.pumpAndSettle();
    controller.currentStep.value = 4;
    await tester.pumpAndSettle();

    expect(find.text('Present address: House 12, Road 3, Gulshan-1, Gulshan, Dhaka, Dhaka', skipOffstage: false), findsWidgets);

    controller.person.present.lineController.clear();
    await controller.person.present.selectDivision(null);
    controller.person.setSameAsPresent(false);
    controller.person.permanent.lineController.clear();
    await controller.person.permanent.selectDivision(null);
    controller.nominees.refresh();
    await tester.pumpAndSettle();
    expect(find.textContaining('Present address: ', skipOffstage: false), findsOneWidget, reason: 'only the nominee keeps its address lines');

    Get.reset();
  });
}
