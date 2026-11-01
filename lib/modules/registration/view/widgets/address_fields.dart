import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_searchable_picker.dart';
import '../../../../core/widgets/app_text_fields.dart';
import '../../controller/address_form_state.dart';
import '../../model/geo_place_model.dart';

/// Division > District > Upazila > Union pickers and the street line of one address.
/// The union is required only when the chosen upazila has unions.
class AddressFields extends StatelessWidget {
  final AddressFormState state;

  /// The API prefix ("present" or "permanent"); also keeps the pickers' keys apart on one screen.
  final String prefix;

  /// Keys are unique per screen: nominees pass their own, e.g. `nominee_0_present`.
  final String keyPrefix;

  /// The server's message for one of this address's fields ('upazila_id', 'union_id', 'address_line').
  final String? Function(String field) errorFor;

  const AddressFields({super.key, required this.state, required this.prefix, required this.keyPrefix, required this.errorFor});

  static String get _language => Get.locale?.languageCode ?? 'bn';

  Widget _picker({
    required String label,
    required String name,
    required GeoLevel level,
    required int? Function() selectedId,
    required bool enabled,
    required void Function(int? id) onSelected,
    required Future<void> Function() onRetry,
    required bool Function() isRequired,
  }) {
    return Obx(() {
      final id = selectedId();
      final places = level.places.toList();
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: AppSearchablePicker<GeoPlaceModel>(
          keyPrefix: '${keyPrefix}_$name',
          label: label,
          items: places,
          itemLabel: (place) => place.label(_language),
          searchTerms: (place) => [place.nameBn, place.nameEn],
          value: places.firstWhereOrNull((place) => place.id == id),
          // The id is set synchronously inside the state; the list loads after.
          onChanged: (place) => onSelected(place?.id),
          enabled: enabled,
          isRequired: isRequired(),
          isLoading: level.loading.value,
          failure: level.failure.value,
          onRetry: onRetry,
          validator: (value) => isRequired() && value == null ? 'registration_required'.tr : null,
        ),
      );
    });
  }

  Widget _error(String field) => Obx(() {
    final message = errorFor(field);
    return message == null
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(message, style: AppTextStyles.bodySmall.copyWith(color: AppColors.error)),
          );
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _picker(
          label: 'geo_division'.tr,
          name: 'division',
          level: state.divisions,
          selectedId: () => state.divisionId.value,
          enabled: true,
          onSelected: state.selectDivision,
          onRetry: state.loadDivisions,
          isRequired: () => true,
        ),
        Obx(
          () => _picker(
            label: 'geo_district'.tr,
            name: 'district',
            level: state.districts,
            selectedId: () => state.districtId.value,
            enabled: state.divisionId.value != null,
            onSelected: state.selectDistrict,
            onRetry: state.reloadDistricts,
            isRequired: () => true,
          ),
        ),
        Obx(
          () => _picker(
            label: 'geo_upazila'.tr,
            name: 'upazila',
            level: state.upazilas,
            selectedId: () => state.upazilaId.value,
            enabled: state.districtId.value != null,
            onSelected: state.selectUpazila,
            onRetry: state.reloadUpazilas,
            isRequired: () => true,
          ),
        ),
        _error('${prefix}_upazila_id'),
        Obx(
          () => _picker(
            label: 'geo_union'.tr,
            name: 'union',
            level: state.unions,
            selectedId: () => state.unionId.value,
            // Stays open while the load failed, so the sheet's Retry is reachable.
            enabled: state.upazilaId.value != null && (state.unionsAvailable.value || state.unions.failure.value != null || state.unions.loading.value),
            onSelected: state.selectUnion,
            onRetry: state.reloadUnions,
            isRequired: () => state.unionRequired,
          ),
        ),
        _error('${prefix}_union_id'),
        AppTextField(
          key: Key('${keyPrefix}_line'),
          label: 'registration_address_line'.tr,
          controller: state.lineController,
          isRequired: true,
          maxLines: 2,
          validator: (v) => (v == null || v.trim().isEmpty) ? 'registration_required'.tr : null,
        ),
        _error('${prefix}_address_line'),
      ],
    );
  }
}
