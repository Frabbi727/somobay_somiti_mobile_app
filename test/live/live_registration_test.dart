@Tags(['live'])
library;

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:somobay_somiti_mobile_app/core/network/api_client.dart';
import 'package:somobay_somiti_mobile_app/modules/authentication/model/login_request_model.dart';
import 'package:somobay_somiti_mobile_app/modules/authentication/repository/auth_repository.dart';
import 'package:somobay_somiti_mobile_app/modules/registration/controller/registration_form_controller.dart';
import 'package:somobay_somiti_mobile_app/modules/registration/repository/registration_repository.dart';

/// Contract check of the registration screens against a running backend: an invited applicant
/// fills in every step through the form controller and submits. Run it again after the office
/// sends the registration back to check the reason and the resubmission. Writes data. Run with:
///   LIVE_API_URL=http://127.0.0.1:8002 LIVE_APPLICANT_MOBILE=017… LIVE_APPLICANT_PASSWORD=…
///   flutter test test/live/live_registration_test.dart --tags live
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  // The form controller needs the binding; this test needs the real network the binding blocks.
  HttpOverrides.global = null;

  final env = Platform.environment;
  final baseUrl = env['LIVE_API_URL'];
  final mobile = env['LIVE_APPLICANT_MOBILE'];
  final password = env['LIVE_APPLICANT_PASSWORD'];

  test('an applicant fills in and submits the registration on the live backend', () async {
    String? token;
    ApiClient client(String language) => ApiClient.forTesting(Dio(BaseOptions(
          baseUrl: baseUrl!,
          headers: {
            'Accept': 'application/json',
            'Accept-Language': language,
            if (token != null) 'Authorization': 'Bearer $token',
          },
        )));

    final login = await AuthRepository(apiClient: client('bn')).login(LoginRequestModel(mobile: mobile!, password: password!));
    expect(login.failure, isNull, reason: 'login: ${login.failure?.message}');
    token = login.tokens!.accessToken;

    final repository = RegistrationRepository(apiClient: client('bn'));
    final account = await repository.accountType();
    if (account.accountType != 'applicant') {
      // ignore: avoid_print
      print('account type: ${account.accountType} (already a member)');
      return;
    }

    for (final language in ['bn', 'en']) {
      final relations = await RegistrationRepository(apiClient: client(language)).relations();
      expect(relations.failure, isNull, reason: 'relations [$language]');
      expect(relations.relations, isNotEmpty, reason: 'relations [$language]');
    }

    final before = await repository.getRegistration();
    expect(before.failure, isNull, reason: 'registration: ${before.failure?.message}');
    // ignore: avoid_print
    print('before: ${before.registration!.status.value} · ${before.registration!.headline} · reason: ${before.registration!.decision?.reason}');

    if (before.registration!.canEdit) {
      final form = RegistrationFormController(repository: repository)..skipValidationForTests = true;
      await form.load();
      expect(form.loadState.value.isSuccess, isTrue, reason: 'form load');

      form.nameBnController.text = 'লাইভ পরীক্ষা';
      form.nameEnController.text = 'Live Test';
      form.guardianController.text = 'Abdul Live';
      form.nidController.text = '৫৫৬৬৭৭৮৮৯৬';
      form.dateOfBirth.value = '1992-03-04';
      form.addressController.text = 'Mirpur, Dhaka';
      while (form.nominees.length > 1) {
        form.removeNominee(form.nominees.length - 1);
      }
      form.nominees.first
        ..nameController.text = 'Karima'
        ..relationId.value = form.relations.first.id
        ..nidController.text = '1234567893'
        ..shareController.text = '60';
      form.addNominee();
      form.nominees.last
        ..nameController.text = 'Rahim'
        ..relationId.value = form.relations.last.id
        ..nidController.text = '1234567894'
        ..shareController.text = '৪০';
      form.sharesController.text = '২';

      for (var step = 0; step < 4; step++) {
        expect(await form.next(), isTrue, reason: 'step $step: ${form.failure.value?.message} ${form.failure.value?.validationErrors}');
      }

      expect(await form.submit(), isTrue, reason: 'submit: ${form.failure.value?.message} ${form.failure.value?.validationErrors}');
      form.onClose();
    }

    final after = await repository.getRegistration();
    expect(after.failure, isNull, reason: 'registration after');
    final data = after.registration!.data;
    expect(data.dateOfBirth, '1992-03-04');
    expect(data.nid, '5566778896');
    expect(data.nominees.map((nominee) => nominee.sharePercent), ['60.00', '40.00']);
    expect(data.requestedShares, 2);
    // ignore: avoid_print
    print('after: ${after.registration!.status.value} · ${after.registration!.headline} · '
        '${after.registration!.timeline.map((step) => '${step.label}=${step.state}').join(', ')}');
  }, skip: baseUrl == null || mobile == null || password == null ? 'Set LIVE_API_URL, LIVE_APPLICANT_MOBILE and LIVE_APPLICANT_PASSWORD' : false);
}
