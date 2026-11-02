import 'dart:async';

import 'package:somobay_somiti_mobile_app/core/errors/failures.dart';
import 'package:somobay_somiti_mobile_app/modules/registration/repository/geo_repository.dart';

import 'fixtures.dart';

List<GeoPlaceModel> _places(String name) => (fixture(name)['data'] as List<dynamic>).map((row) => GeoPlaceModel.fromJson(row as Map<String, dynamic>)).toList();

/// The geo fixtures as a repository: Dhaka division (6) > Dhaka district (47) > its upazilas;
/// only Gulshan (495) has unions, so any other upazila behaves like one without unions.
class FakeGeoRepository implements IGeoRepository {
  final List<String> calls = [];
  Failure? districtsFailure;
  Failure? unionsFailure;

  /// Each queued gate holds back the next unions() answer until it completes.
  final List<Completer<void>> unionsGates = [];

  @override
  Future<GeoResult> divisions() async => (failure: null, places: _places('geo_divisions'));

  @override
  Future<GeoResult> districts(int divisionId) async {
    calls.add('districts:$divisionId');
    if (districtsFailure != null) return (failure: districtsFailure, places: const <GeoPlaceModel>[]);
    return (failure: null, places: divisionId == 6 ? _places('geo_districts_6') : const <GeoPlaceModel>[]);
  }

  @override
  Future<GeoResult> upazilas(int districtId) async {
    calls.add('upazilas:$districtId');
    return (failure: null, places: districtId == 47 ? _places('geo_upazilas_47') : const <GeoPlaceModel>[]);
  }

  @override
  Future<GeoResult> unions(int upazilaId) async {
    calls.add('unions:$upazilaId');
    if (unionsGates.isNotEmpty) await unionsGates.removeAt(0).future;
    if (unionsFailure != null) return (failure: unionsFailure, places: const <GeoPlaceModel>[]);
    return (failure: null, places: upazilaId == 495 ? _places('geo_unions_495') : const <GeoPlaceModel>[]);
  }
}
