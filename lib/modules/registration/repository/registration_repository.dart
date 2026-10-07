import 'package:dio/dio.dart';

import '../../../core/constants/api_constants.dart';
import '../../../core/errors/error_handler.dart';
import '../../../core/errors/failures.dart';
import '../../../core/network/api_client.dart';
import '../model/registration_model.dart';

typedef RegistrationResult = ({Failure? failure, RegistrationModel? registration});

abstract class IRegistrationRepository {
  Future<RegistrationResult> getRegistration();

  /// Saves the given fields only (a partial draft); `nominees` replaces the whole list.
  Future<RegistrationResult> saveDraft(Map<String, dynamic> fields);

  Future<RegistrationResult> uploadPhoto(String path);

  /// One key per form: a retry with the same key never submits twice.
  Future<RegistrationResult> submit(String idempotencyKey);

  Future<({Failure? failure, List<NomineeRelationModel> relations})> relations();

  /// "member" or "applicant" — asked before showing the status, so an approval is noticed.
  Future<({Failure? failure, String? accountType})> accountType();
}

class RegistrationRepository implements IRegistrationRepository {
  final ApiClient apiClient;

  RegistrationRepository({required this.apiClient});

  @override
  Future<RegistrationResult> getRegistration() => _registration(() => apiClient.get(ApiConstants.registration));

  @override
  Future<RegistrationResult> saveDraft(Map<String, dynamic> fields) =>
      _registration(() => apiClient.put(ApiConstants.registration, data: fields));

  @override
  Future<RegistrationResult> uploadPhoto(String path) async => _registration(
        () async => apiClient.post(ApiConstants.registrationPhoto, data: FormData.fromMap({'photo': await MultipartFile.fromFile(path)})),
      );

  @override
  Future<RegistrationResult> submit(String idempotencyKey) =>
      _registration(() => apiClient.post(ApiConstants.registrationSubmit, data: {'idempotency_key': idempotencyKey}));

  @override
  Future<({Failure? failure, List<NomineeRelationModel> relations})> relations() async {
    try {
      final response = await apiClient.get(ApiConstants.nomineeRelations);
      final rows = (response.data as Map<String, dynamic>)['data'] as List<dynamic>;
      return (failure: null, relations: rows.map((row) => NomineeRelationModel.fromJson(row as Map<String, dynamic>)).toList());
    } catch (e) {
      return (failure: ErrorHandler.handleException(e), relations: <NomineeRelationModel>[]);
    }
  }

  @override
  Future<({Failure? failure, String? accountType})> accountType() async {
    try {
      final response = await apiClient.get(ApiConstants.me);
      final data = (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      return (failure: null, accountType: (data['account_type'] as String?) ?? 'member');
    } catch (e) {
      return (failure: ErrorHandler.handleException(e), accountType: null);
    }
  }

  Future<RegistrationResult> _registration(Future<Response<dynamic>> Function() call) async {
    try {
      final response = await call();
      final data = (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      return (failure: null, registration: RegistrationModel.fromJson(data));
    } catch (e) {
      return (failure: ErrorHandler.handleException(e), registration: null);
    }
  }
}
