import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../../core/errors/failures.dart';
import '../model/registration_model.dart';
import '../repository/geo_repository.dart';

/// One level of the address chain (division, district, upazila or union): its choices and load state.
class GeoLevel {
  final places = <GeoPlaceModel>[].obs;
  final loading = false.obs;
  final failure = Rxn<Failure>();

  void clear() {
    places.clear();
    failure.value = null;
    loading.value = false;
  }
}

/// One address on the form: Division > District > Upazila > Union plus a street line.
/// Choosing a level clears everything below it and loads the next list.
class AddressFormState {
  final IGeoRepository geo;

  AddressFormState({required this.geo});

  final divisionId = RxnInt();
  final districtId = RxnInt();
  final upazilaId = RxnInt();
  final unionId = RxnInt();
  final lineController = TextEditingController();

  /// False until the chosen upazila's unions are loaded, and when that upazila has none.
  final unionsAvailable = false.obs;

  final divisions = GeoLevel();
  final districts = GeoLevel();
  final upazilas = GeoLevel();
  final unions = GeoLevel();

  /// The ids are set first and synchronously: a rebuild while the next list loads must not undo the choice.
  Future<void> selectDivision(int? id) async {
    divisionId.value = id;
    _clearBelow(districts: true);
    if (id != null) await _load(districts, () => geo.districts(id), () => divisionId.value == id);
  }

  Future<void> selectDistrict(int? id) async {
    districtId.value = id;
    _clearBelow(upazilas: true);
    if (id != null) await _load(upazilas, () => geo.upazilas(id), () => districtId.value == id);
  }

  Future<void> selectUpazila(int? id) async {
    upazilaId.value = id;
    _clearBelow(unions: true);
    if (id != null) {
      await _load(unions, () => geo.unions(id), () => upazilaId.value == id);
      unionsAvailable.value = unions.places.isNotEmpty;
    }
  }

  void selectUnion(int? id) => unionId.value = id;

  Future<void> loadDivisions() => _load(divisions, geo.divisions, () => true);

  /// Reloads the list that failed (the picker's Retry).
  Future<void> reloadDistricts() => divisionId.value == null ? Future.value() : _load(districts, () => geo.districts(divisionId.value!), () => true);

  Future<void> reloadUpazilas() => districtId.value == null ? Future.value() : _load(upazilas, () => geo.upazilas(districtId.value!), () => true);

  Future<void> reloadUnions() async {
    if (upazilaId.value == null) return;
    await _load(unions, () => geo.unions(upazilaId.value!), () => true);
    unionsAvailable.value = unions.places.isNotEmpty;
  }

  void _clearBelow({bool districts = false, bool upazilas = false, bool unions = false}) {
    if (districts) {
      districtId.value = null;
      this.districts.clear();
    }
    if (districts || upazilas) {
      upazilaId.value = null;
      this.upazilas.clear();
    }
    unionId.value = null;
    this.unions.clear();
    unionsAvailable.value = false;
  }

  /// [stillWanted] drops an answer that arrives after the member chose something else.
  Future<void> _load(GeoLevel level, Future<GeoResult> Function() fetch, bool Function() stillWanted) async {
    level.loading.value = true;
    level.failure.value = null;
    final result = await fetch();
    if (!stillWanted()) return;
    level.loading.value = false;
    level.failure.value = result.failure;
    level.places.assignAll(result.places);
  }

  /// Fills the whole chain from a saved address (the server derives division and district).
  Future<void> fromModel(RegistrationAddressModel? model) async {
    await loadDivisions();
    lineController.text = model?.line ?? '';
    if (model?.upazilaId == null) return;

    divisionId.value = model!.divisionId;
    districtId.value = model.districtId;
    upazilaId.value = model.upazilaId;
    unionId.value = model.unionId;
    await Future.wait([
      if (model.divisionId != null) _load(districts, () => geo.districts(model.divisionId!), () => true),
      if (model.districtId != null) _load(upazilas, () => geo.upazilas(model.districtId!), () => true),
      _load(unions, () => geo.unions(model.upazilaId!), () => true),
    ]);
    unionsAvailable.value = unions.places.isNotEmpty;
  }

  /// A copy of [other]'s choices (for "permanent is the same as present").
  void copyFrom(AddressFormState other) {
    divisionId.value = other.divisionId.value;
    districtId.value = other.districtId.value;
    upazilaId.value = other.upazilaId.value;
    unionId.value = other.unionId.value;
    lineController.text = other.lineController.text;
    unionsAvailable.value = other.unionsAvailable.value;
    districts.places.assignAll(other.districts.places);
    upazilas.places.assignAll(other.upazilas.places);
    unions.places.assignAll(other.unions.places);
  }

  /// "Gulshan-1, Gulshan, Dhaka, Dhaka" followed by the street line, for the review step.
  String summary(String languageCode) {
    String? nameOf(GeoLevel level, int? id) => level.places.firstWhereOrNull((place) => place.id == id)?.label(languageCode);
    final line = lineController.text.trim();
    return [
      if (line.isNotEmpty) line,
      nameOf(unions, unionId.value),
      nameOf(upazilas, upazilaId.value),
      nameOf(districts, districtId.value),
      nameOf(divisions, divisionId.value),
    ].whereType<String>().join(', ');
  }

  /// Flat API keys: `{prefix}_upazila_id`, `{prefix}_union_id`, `{prefix}_address_line`.
  Map<String, dynamic> toJson(String prefix) {
    final line = lineController.text.trim();
    return {'${prefix}_upazila_id': upazilaId.value, '${prefix}_union_id': unionsAvailable.value ? unionId.value : null, '${prefix}_address_line': line.isEmpty ? null : line};
  }

  void dispose() => lineController.dispose();
}
