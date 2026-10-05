import 'package:flutter_test/flutter_test.dart';
import 'package:somobay_somiti_mobile_app/core/errors/failures.dart';
import 'package:somobay_somiti_mobile_app/core/utils/paged_list.dart';
import 'package:somobay_somiti_mobile_app/modules/payments/controller/pay_online_controller.dart';
import 'package:somobay_somiti_mobile_app/modules/payments/model/payment_detail_model.dart';
import 'package:somobay_somiti_mobile_app/modules/payments/model/payment_summary_model.dart';
import 'package:somobay_somiti_mobile_app/modules/payments/repository/payments_repository.dart';

import '../support/fixtures.dart';

class RecordingRepository implements IPaymentsRepository {
  final List<String> keys = [];
  final List<Failure?> answers;

  RecordingRepository(this.answers);

  @override
  Future<({Failure? failure, PaymentDetailModel? payment, String? message})> submit({
    required String method,
    required String amount,
    required String trxId,
    required String receivedOn,
    required String proofPath,
    required String idempotencyKey,
  }) async {
    keys.add(idempotencyKey);
    final failure = answers.removeAt(0);
    return failure == null
        ? (failure: null, payment: PaymentDetailModel.fromJson(fixture('payment_submit.bn')['data'] as Map<String, dynamic>), message: 'ok')
        : (failure: failure, payment: null, message: null);
  }

  @override
  Future<PageResult<PaymentSummaryModel>> getPayments({int page = 1, String? status}) => throw UnimplementedError();

  @override
  Future<({Failure? failure, PaymentDetailModel? payment})> getPayment(int id) => throw UnimplementedError();

  @override
  Future<({Failure? failure, String? url})> receiptUrl(int id) => throw UnimplementedError();
}

void main() {
  test('retries of one form reuse its idempotency key; a new form after success gets a new key', () async {
    final repository = RecordingRepository([const TimeoutFailure(), null, null]);
    final controller = PayOnlineController(repository: repository)
      ..method.value = 'bkash'
      ..amountController.text = '১০০০'
      ..trxController.text = 'bk8x2lq91z'
      ..receivedOn.value = '2026-08-12'
      ..proofPath.value = '/tmp/proof.jpg';

    expect(await controller.send(), isFalse); // timed out
    expect(await controller.send(), isTrue); // retried
    expect(repository.keys[0], repository.keys[1]);

    expect(await controller.send(), isTrue); // a fresh form after success
    expect(repository.keys[2], isNot(repository.keys[0]));
  });
}
