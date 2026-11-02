import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:somobay_somiti_mobile_app/core/constants/api_constants.dart';
import 'package:somobay_somiti_mobile_app/core/errors/failures.dart';
import 'package:somobay_somiti_mobile_app/modules/payments/repository/payments_repository.dart';

import '../support/fake_api.dart';
import '../support/fixtures.dart';

void main() {
  late File proof;

  setUp(() {
    proof = File('${Directory.systemTemp.path}/proof.jpg')..writeAsBytesSync([1, 2, 3]);
  });

  test('lists payments and reads a detail with allocations and the advance part', () async {
    final detailBody = fixture('payment_detail.en');
    final id = (detailBody['data'] as Map<String, dynamic>)['id'] as int;
    final api = FakeApi({
      'GET ${ApiConstants.payments}': (r) => (200, fixture('payments.en')),
      'GET ${ApiConstants.paymentDetail(id)}': (r) => (200, detailBody),
    });
    final repository = PaymentsRepository(apiClient: api.client());

    final list = await repository.getPayments(page: 1, status: 'approved');
    expect(api.last.queryParameters, {'page': 1, 'status': 'approved'});
    expect(list.items, isNotEmpty);

    final detail = (await repository.getPayment(id)).payment!;
    final allocated = detail.allocations.fold<int>(0, (sum, a) => sum + a.amount.poisha);
    expect(detail.receiptAvailable, isTrue);
    expect(detail.allocations.first.month, '2026-07');
    expect(allocated + detail.toAdvance.poisha, detail.amount.poisha); // backend invariant, checked not computed by the app
  });

  test('gets a receipt link', () async {
    final api = FakeApi({'GET ${ApiConstants.paymentReceipt(1)}': (r) => (200, envelope({'url': 'https://x/receipts/1?signature=s'}))});

    expect((await PaymentsRepository(apiClient: api.client()).receiptUrl(1)).url, 'https://x/receipts/1?signature=s');
  });

  test('submits pay online as multipart with the same idempotency key on a retry', () async {
    final api = FakeApi({'POST ${ApiConstants.payments}': (r) => (201, fixture('payment_submit.bn'))});
    final repository = PaymentsRepository(apiClient: api.client());

    Future<void> submit() => repository.submit(
          method: 'bkash', amount: '১,০০০', trxId: 'BK8X2LQ91Z', receivedOn: '2026-08-12', proofPath: proof.path, idempotencyKey: 'key-1');

    await submit();
    final first = api.last.data as FormData;
    await submit();
    final second = api.last.data as FormData;

    Map<String, String> fields(FormData form) => {for (final f in form.fields) f.key: f.value};
    expect(fields(first), {'method': 'bkash', 'amount': '১,০০০', 'trx_id': 'BK8X2LQ91Z', 'received_on': '2026-08-12', 'idempotency_key': 'key-1'});
    expect(fields(second)['idempotency_key'], 'key-1');
    expect(first.files.single.key, 'proof');
  });

  test('submits without a proof file when none is attached (proof is optional)', () async {
    final api = FakeApi({'POST ${ApiConstants.payments}': (r) => (201, fixture('payment_submit.bn'))});

    final result = await PaymentsRepository(apiClient: api.client())
        .submit(method: 'nagad', amount: '600', trxId: 'NG12345678', receivedOn: '2026-08-12', idempotencyKey: 'key-2');

    expect(result.failure, isNull);
    expect((api.last.data as FormData).files, isEmpty);
  });

  test('a conflict and validation errors come back as their failures', () async {
    final api = FakeApi({
      'POST ${ApiConstants.payments}': (r) {
        final key = {for (final f in (r.data as FormData).fields) f.key: f.value}['idempotency_key'];
        return key == 'conflict' ? (409, fixture('error_409_payment_conflict.bn')) : (422, fixture('error_422_payment.bn'));
      },
    });
    final repository = PaymentsRepository(apiClient: api.client());

    final conflict = await repository.submit(method: 'bkash', amount: '999', trxId: 'BK1', receivedOn: '2026-08-12', proofPath: proof.path, idempotencyKey: 'conflict');
    expect(conflict.failure, isA<ConflictFailure>());

    final invalid = await repository.submit(method: 'cash', amount: '1', trxId: 'x', receivedOn: '2026-08-12', proofPath: proof.path, idempotencyKey: 'other');
    expect(invalid.failure, isA<ValidationFailure>());
    expect(invalid.failure?.validationErrors?['trx_id'], isNotEmpty);
  });
}
