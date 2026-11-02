import '../../../core/constants/api_constants.dart';
import '../../../core/errors/error_handler.dart';
import '../../../core/errors/failures.dart';
import '../../../core/network/api_client.dart';
import '../model/terms_model.dart';

typedef TermsResult = ({Failure? failure, TermsModel? terms});

abstract class ITermsRepository {
  /// The current rules; works for members and applicants, and before a member has accepted.
  Future<TermsResult> current();

  /// Members only. One key per attempt: a retry with the same key never records twice.
  Future<({Failure? failure})> accept(int version, String idempotencyKey);
}

class TermsRepository implements ITermsRepository {
  final ApiClient apiClient;

  TermsRepository({required this.apiClient});

  @override
  Future<TermsResult> current() async {
    try {
      final response = await apiClient.get(ApiConstants.termsCurrent);
      final data = (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      return (failure: null, terms: TermsModel.fromJson(data));
    } catch (e) {
      return (failure: ErrorHandler.handleException(e), terms: null);
    }
  }

  @override
  Future<({Failure? failure})> accept(int version, String idempotencyKey) async {
    try {
      await apiClient.post(ApiConstants.termsAccept, data: {'version': version, 'idempotency_key': idempotencyKey});
      return (failure: null);
    } catch (e) {
      return (failure: ErrorHandler.handleException(e));
    }
  }
}
