import '../../../core/constants/api_constants.dart';
import '../../../core/errors/error_handler.dart';
import '../../../core/errors/failures.dart';
import '../../../core/network/api_client.dart';
import '../model/geo_place_model.dart';

export '../model/geo_place_model.dart';

typedef GeoResult = ({Failure? failure, List<GeoPlaceModel> places});

abstract class IGeoRepository {
  Future<GeoResult> divisions();

  Future<GeoResult> districts(int divisionId);

  Future<GeoResult> upazilas(int districtId);

  /// May legitimately be empty: some city-area upazilas have no unions.
  Future<GeoResult> unions(int upazilaId);
}

/// Each child list is small, so it is fetched whole once per parent and kept in memory;
/// the picker searches it locally. Failures are never cached.
class GeoRepository implements IGeoRepository {
  final ApiClient apiClient;
  final Map<String, List<GeoPlaceModel>> _cache = {};

  GeoRepository({required this.apiClient});

  @override
  Future<GeoResult> divisions() => _load(ApiConstants.geoDivisions);

  @override
  Future<GeoResult> districts(int divisionId) => _load(ApiConstants.geoDistricts, parentKey: 'division_id', parentId: divisionId);

  @override
  Future<GeoResult> upazilas(int districtId) => _load(ApiConstants.geoUpazilas, parentKey: 'district_id', parentId: districtId);

  @override
  Future<GeoResult> unions(int upazilaId) => _load(ApiConstants.geoUnions, parentKey: 'upazila_id', parentId: upazilaId);

  Future<GeoResult> _load(String path, {String? parentKey, int? parentId}) async {
    final cacheKey = '$path|${parentId ?? ''}';
    final cached = _cache[cacheKey];
    if (cached != null) {
      return (failure: null, places: cached);
    }

    try {
      final response = await apiClient.get(path, queryParameters: parentKey == null ? null : {parentKey: parentId});
      final rows = (response.data as Map<String, dynamic>)['data'] as List<dynamic>;
      final places = List<GeoPlaceModel>.unmodifiable(rows.map((row) => GeoPlaceModel.fromJson(row as Map<String, dynamic>)));
      _cache[cacheKey] = places;
      return (failure: null, places: places);
    } catch (e) {
      return (failure: ErrorHandler.handleException(e), places: const <GeoPlaceModel>[]);
    }
  }
}
