import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/errors/error_handler.dart';
import '../../../core/errors/failures.dart';
import '../../../core/models/api_page.dart';
import '../../../core/network/api_client.dart';
import '../../../core/utils/paged_list.dart';
import '../model/payment_detail_model.dart';
import '../model/payment_summary_model.dart';

abstract class IPaymentsRepository {
  Future<PageResult<PaymentSummaryModel>> getPayments({int page = 1, String? status});
  Future<({Failure? failure, PaymentDetailModel? payment})> getPayment(int id);
  Future<({Failure? failure, String? url})> receiptUrl(int id);

  /// Pay online (bKash/Nagad). Reuse [idempotencyKey] when retrying the same form.
  Future<({Failure? failure, PaymentDetailModel? payment, String? message})> submit({
    required String method,
    required String amount,
    required String trxId,
    required String receivedOn,
    required String proofPath,
    required String idempotencyKey,
  });
}

class PaymentsRepository implements IPaymentsRepository {
  final ApiClient apiClient;

  PaymentsRepository({required this.apiClient});

  @override
  Future<PageResult<PaymentSummaryModel>> getPayments({int page = 1, String? status}) async {
    try {
      final response = await apiClient.get(ApiConstants.payments, queryParameters: {
        'page': page,
        if (status != null) 'status': status,
      });
      final parsed = ApiPage.parse(response.data, PaymentSummaryModel.fromJson);
      return (failure: null, items: parsed.items, meta: parsed.meta);
    } catch (e) {
      return (failure: ErrorHandler.handleException(e), items: <PaymentSummaryModel>[], meta: null);
    }
  }

  @override
  Future<({Failure? failure, PaymentDetailModel? payment})> getPayment(int id) async {
    try {
      final response = await apiClient.get(ApiConstants.paymentDetail(id));
      final data = (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      return (failure: null, payment: PaymentDetailModel.fromJson(data));
    } catch (e) {
      return (failure: ErrorHandler.handleException(e), payment: null);
    }
  }

  @override
  Future<({Failure? failure, String? url})> receiptUrl(int id) async {
    try {
      final response = await apiClient.get(ApiConstants.paymentReceipt(id));
      final data = (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>;
      return (failure: null, url: data['url'] as String);
    } catch (e) {
      return (failure: ErrorHandler.handleException(e), url: null);
    }
  }

  @override
  Future<({Failure? failure, PaymentDetailModel? payment, String? message})> submit({
    required String method,
    required String amount,
    required String trxId,
    required String receivedOn,
    required String proofPath,
    required String idempotencyKey,
  }) async {
    try {
      final form = FormData.fromMap({
        'method': method,
        'amount': amount,
        'trx_id': trxId,
        'received_on': receivedOn,
        'idempotency_key': idempotencyKey,
        'proof': await MultipartFile.fromFile(proofPath),
      });
      final response = await apiClient.post(ApiConstants.payments, data: form);
      final body = response.data as Map<String, dynamic>;
      return (
        failure: null,
        payment: PaymentDetailModel.fromJson(body['data'] as Map<String, dynamic>),
        message: body['message'] as String?,
      );
    } catch (e) {
      return (failure: ErrorHandler.handleException(e), payment: null, message: null);
    }
  }
}
