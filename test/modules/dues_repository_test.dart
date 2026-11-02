import 'package:flutter_test/flutter_test.dart';
import 'package:somobay_somiti_mobile_app/core/constants/api_constants.dart';
import 'package:somobay_somiti_mobile_app/core/utils/paged_list.dart';
import 'package:somobay_somiti_mobile_app/modules/dues/model/due_model.dart';
import 'package:somobay_somiti_mobile_app/modules/dues/repository/dues_repository.dart';

import '../support/fake_api.dart';
import '../support/fixtures.dart';

void main() {
  test('reads a page of dues as the backend sends them, with the filters it was asked for', () async {
    final api = FakeApi({'GET ${ApiConstants.dues}': (r) => (200, fixture('dues.en'))});

    final result = await DuesRepository(apiClient: api.client()).getDues(page: 1, status: 'all', type: 'deposit');
    final due = result.items.first;

    expect(result.failure, isNull);
    expect(api.last.queryParameters, {'page': 1, 'status': 'all', 'type': 'deposit'});
    expect(due.month, '2026-08');
    expect(due.type.value, 'deposit');
    expect(due.amount.poisha, 100000);
    expect(due.outstanding.display, '৳ 0.00');
    expect(due.status.value, 'settled');
    expect(result.meta?.perPage, 20);
  });

  test('loads the next page, appends it and stops at the last page', () async {
    Map<String, dynamic> page(int n) => envelope(
          [
            {'id': n, 'month': '2026-0$n', 'type': enumValue('deposit'), 'amount': money(100), 'paid': money(0), 'outstanding': money(100), 'due_date': '2026-0$n-10', 'status': enumValue('open')},
          ],
          meta: {'current_page': n, 'last_page': 2, 'per_page': 20, 'total': 2},
        );
    final api = FakeApi({'GET ${ApiConstants.dues}': (r) => (200, page(r.queryParameters['page'] as int))});
    final repository = DuesRepository(apiClient: api.client());
    final list = PagedList<DueModel>((pageNo) => repository.getDues(page: pageNo, status: 'open'));

    await list.refresh();
    expect(list.items.map((d) => d.id), [1]);
    expect(list.hasMore, isTrue);

    await list.loadMore();
    expect(list.items.map((d) => d.id), [1, 2]);
    expect(list.hasMore, isFalse);

    await list.loadMore();
    expect(api.requests.length, 2);
  });

  test('an empty list is not an error', () async {
    final api = FakeApi({'GET ${ApiConstants.dues}': (r) => (200, envelope([], meta: {'current_page': 1, 'last_page': 1, 'per_page': 20, 'total': 0}))});
    final list = PagedList<DueModel>((pageNo) => DuesRepository(apiClient: api.client()).getDues(page: pageNo));

    await list.refresh();

    expect(list.items, isEmpty);
    expect(list.failure, isNull);
    expect(list.hasMore, isFalse);
  });
}
