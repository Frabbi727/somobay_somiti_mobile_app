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

  /// True only after a successful load of a non-empty union list for the chosen upazila.
  final unionsAvailable = false.obs;

  /// True once the chosen upazila's unions loaded successfully (the list may be empty). While false
  /// (loading, failed, nothing chosen) availability is unknown: the union stays required and is kept.
  final unionsLoaded = false.obs;

  int _epoch = 0;

  /// Whether the union must be chosen: unless the upazila is known to have none.
  bool get unionRequired => upazilaId.value != null && !(unionsLoaded.value && !unionsAvailable.value);

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
      _applyUnions(await _load(unions, () => geo.unions(id), () => upazilaId.value == id));
    }
  }

  void selectUnion(int? id) => unionId.value = id;

  Future<void> loadDivisions() async {
    await _load(divisions, geo.divisions, () => true);
  }

  /// Reloads the list that failed (the picker's Retry).
  Future<void> reloadDistricts() async {
    final id = divisionId.value;
    if (id != null) await _load(districts, () => geo.districts(id), () => divisionId.value == id);
  }

  Future<void> reloadUpazilas() async {
    final id = districtId.value;
    if (id != null) await _load(upazilas, () => geo.upazilas(id), () => districtId.value == id);
  }

  Future<void> reloadUnions() async {
    final id = upazilaId.value;
    if (id == null) return;
    _applyUnions(await _load(unions, () => geo.unions(id), () => upazilaId.value == id));
  }

  /// Availability changes only after a successful load; a failure leaves it unknown.
  void _applyUnions(bool loaded) {
    if (!loaded) return;
    unionsLoaded.value = true;
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
    unionsLoaded.value = false;
  }

  /// [stillWanted] drops an answer that arrives after the member chose something else.
  /// True when the list was loaded and applied; false on failure or when the answer is outdated.
  Future<bool> _load(GeoLevel level, Future<GeoResult> Function() fetch, bool Function() stillWanted) async {
    final epoch = _epoch;
    level.loading.value = true;
    level.failure.value = null;
    final result = await fetch();
    if (!stillWanted() || epoch != _epoch) return false;
    level.loading.value = false;
    level.failure.value = result.failure;
    level.places.assignAll(result.places);
    return result.failure == null;
  }

  /// Fills the whole chain from a saved address (the server derives division and district).
  Future<void> fromModel(RegistrationAddressModel? model) async {
    // Before the first await: the form may be closed while the lists load.
    lineController.text = model?.line ?? '';
    await loadDivisions();
    if (model?.upazilaId == null) return;

    divisionId.value = model!.divisionId;
    districtId.value = model.districtId;
    upazilaId.value = model.upazilaId;
    unionId.value = model.unionId;
    final results = await Future.wait([
      if (model.divisionId != null) _load(districts, () => geo.districts(model.divisionId!), () => true),
      if (model.districtId != null) _load(upazilas, () => geo.upazilas(model.districtId!), () => true),
      _load(unions, () => geo.unions(model.upazilaId!), () => true),
    ]);
    _applyUnions(results.last);
  }

  /// A copy of [other]'s choices (for "permanent is the same as present").
  void copyFrom(AddressFormState other) {
    divisionId.value = other.divisionId.value;
    districtId.value = other.districtId.value;
    upazilaId.value = other.upazilaId.value;
    unionId.value = other.unionId.value;
    lineController.text = other.lineController.text;
    unionsAvailable.value = other.unionsAvailable.value;
    unionsLoaded.value = other.unionsLoaded.value;
    _epoch++; // loads still running here must not overwrite the copied lists
    for (final (mine, theirs) in [(divisions, other.divisions), (districts, other.districts), (upazilas, other.upazilas), (unions, other.unions)]) {
      mine.places.assignAll(theirs.places);
      mine.failure.value = theirs.failure.value;
      mine.loading.value = false; // the loads still running here were dropped by the epoch bump
    }
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
    return {'${prefix}_upazila_id': upazilaId.value, '${prefix}_union_id': unionsLoaded.value && !unionsAvailable.value ? null : unionId.value, '${prefix}_address_line': line.isEmpty ? null : line};
  }

  void dispose() => lineController.dispose();
}
