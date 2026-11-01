import 'package:flutter_test/flutter_test.dart';
import 'package:somobay_somiti_mobile_app/core/constants/api_constants.dart';
import 'package:somobay_somiti_mobile_app/core/errors/failures.dart';
import 'package:somobay_somiti_mobile_app/modules/registration/repository/geo_repository.dart';

import '../support/fake_api.dart';
import '../support/fixtures.dart';

void main() {
  test('parses places and caches by parent', () async {
    final api = FakeApi({
      'GET ${ApiConstants.geoDivisions}': (_) => (200, fixture('geo_divisions')),
      'GET ${ApiConstants.geoDistricts}': (_) => (200, fixture('geo_districts_6')),
      'GET ${ApiConstants.geoUpazilas}': (_) => (200, fixture('geo_upazilas_47')),
      'GET ${ApiConstants.geoUnions}': (_) => (200, fixture('geo_unions_495')),
    });
    final repository = GeoRepository(apiClient: api.client());

    final divisions = await repository.divisions();
    expect(divisions.failure, isNull);
    expect(divisions.places, hasLength(8));
    expect(divisions.places.firstWhere((p) => p.id == 6).nameBn, 'ঢাকা');

    expect((await repository.districts(6)).places.any((p) => p.id == 47 && p.nameEn == 'Dhaka'), isTrue);
    expect(api.last.queryParameters, {'division_id': 6});

    expect((await repository.upazilas(47)).places.any((p) => p.id == 495 && p.nameEn == 'Gulshan'), isTrue);
    expect(api.last.queryParameters, {'district_id': 47});

    final unions = await repository.unions(495);
    expect(unions.places.map((p) => p.nameEn), containsAll(['Gulshan-1', 'Gulshan-2']));
    expect(api.last.queryParameters, {'upazila_id': 495});

    final requestsSoFar = api.requests.length;
    await repository.divisions();
    await repository.districts(6);
    await repository.upazilas(47);
    expect((await repository.unions(495)).places, hasLength(5));
    expect(api.requests.length, requestsSoFar, reason: 'second calls are served from the cache');
  });

  test('labels follow the language, falling back to the other name', () {
    const place = GeoPlaceModel(id: 4541, nameBn: 'গুলশান-১', nameEn: 'Gulshan-1');
    expect(place.label('bn'), 'গুলশান-১');
    expect(place.label('en'), 'Gulshan-1');
    expect(const GeoPlaceModel(id: 1, nameBn: 'ঢাকা', nameEn: '').label('en'), 'ঢাকা');
  });

  test('an empty child list is a success and is cached; a failure is not cached', () async {
    var empty = true;
    final api = FakeApi({
      'GET ${ApiConstants.geoUnions}': (_) => empty ? (200, envelope(<dynamic>[])) : (200, fixture('geo_unions_495')),
      'GET ${ApiConstants.geoUpazilas}': (_) => (422, envelopeError(422, 'invalid')),
    });
    final repository = GeoRepository(apiClient: api.client());

    final first = await repository.unions(496);
    expect(first.failure, isNull);
    expect(first.places, isEmpty);

    empty = false;
    expect((await repository.unions(496)).places, isEmpty);
    expect(api.requests, hasLength(1));

    final failed = await repository.upazilas(0);
    expect(failed.failure, isA<ValidationFailure>());
    await repository.upazilas(0);
    expect(api.requests, hasLength(3), reason: 'failures are retried, not cached');
  });
}
