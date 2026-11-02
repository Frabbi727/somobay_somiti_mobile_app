import '../../../core/constants/api_constants.dart';
import '../../../core/errors/error_handler.dart';
import '../../../core/errors/failures.dart';
import '../../../core/network/api_client.dart';
import '../model/statement_model.dart';

/// The passbook: the member statement for a date range, and a signed link to its PDF.
abstract class ITransactionRepository {
  /// Without dates the backend uses the current fiscal year so far.
  Future<({Failure? failure, StatementModel? statement})> getStatement({String? from, String? until});
  Future<({Failure? failure, String? url})> statementPdfUrl({String? from, String? until});
}

class TransactionRepository implements ITransactionRepository {
  final ApiClient apiClient;

  TransactionRepository({required this.apiClient});

  Map<String, dynamic> _range(String? from, String? until) => {
        if (from != null) 'from': from,
        if (until != null) 'until': until,
      };

  @override
  Future<({Failure? failure, StatementModel? statement})> getStatement({String? from, String? until}) async {
    try {
      final response = await apiClient.get(ApiConstants.statement, queryParameters: _range(from, until));
      final data = (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      return (failure: null, statement: StatementModel.fromJson(data));
    } catch (e) {
      return (failure: ErrorHandler.handleException(e), statement: null);
    }
  }

  @override
  Future<({Failure? failure, String? url})> statementPdfUrl({String? from, String? until}) async {
    try {
      final response = await apiClient.get(ApiConstants.statementPdfLink, queryParameters: _range(from, until));
      final data = (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      return (failure: null, url: data['url'] as String);
    } catch (e) {
      return (failure: ErrorHandler.handleException(e), url: null);
    }
  }
}
