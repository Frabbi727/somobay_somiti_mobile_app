import 'package:flutter_test/flutter_test.dart';
import 'package:somobay_somiti_mobile_app/core/constants/api_constants.dart';
import 'package:somobay_somiti_mobile_app/modules/transactions/repository/transaction_repository.dart';

import '../support/fake_api.dart';
import '../support/fixtures.dart';

void main() {
  test('reads the statement exactly as the backend sends it', () async {
    final api = FakeApi({'GET ${ApiConstants.statement}': (r) => (200, fixture('statement.en'))});

    final result = await TransactionRepository(apiClient: api.client()).getStatement(from: '2026-07-01', until: '2026-08-31');
    final statement = result.statement!;

    expect(api.last.queryParameters, {'from': '2026-07-01', 'until': '2026-08-31'});
    expect(statement.from, '2026-07-01');
    expect(statement.opening.poisha, 0);
    expect(statement.rows.first.description, 'Registration fee · 2026-07');
    expect(statement.rows.first.charge?.poisha, 20000);
    expect(statement.rows.first.balance?.display, '৳ 200.00');
    expect(statement.closing.poisha, statement.rows.last.balance?.poisha);
  });

  test('sends no dates when none are chosen, so the backend uses the fiscal year so far', () async {
    final api = FakeApi({'GET ${ApiConstants.statement}': (r) => (200, fixture('statement.en'))});

    await TransactionRepository(apiClient: api.client()).getStatement();

    expect(api.last.queryParameters, isEmpty);
  });

  test('gets the signed PDF link for the same range', () async {
    final api = FakeApi({'GET ${ApiConstants.statementPdfLink}': (r) => (200, envelope({'url': 'https://x/statement.pdf?signature=s'}))});

    final result = await TransactionRepository(apiClient: api.client()).statementPdfUrl(from: '2026-07-01', until: '2026-08-31');

    expect(result.url, 'https://x/statement.pdf?signature=s');
    expect(api.last.queryParameters, {'from': '2026-07-01', 'until': '2026-08-31'});
  });
}
