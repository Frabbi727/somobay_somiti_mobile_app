import 'package:json_annotation/json_annotation.dart';

part 'geo_place_model.g.dart';

/// A division, district, upazila or union as the public geo API returns it.
@JsonSerializable()
class GeoPlaceModel {
  final int id;
  @JsonKey(name: 'name_bn')
  final String nameBn;
  @JsonKey(name: 'name_en')
  final String nameEn;

  const GeoPlaceModel({required this.id, required this.nameBn, required this.nameEn});

  factory GeoPlaceModel.fromJson(Map<String, dynamic> json) => _$GeoPlaceModelFromJson(json);

  Map<String, dynamic> toJson() => _$GeoPlaceModelToJson(this);

  /// The name in [languageCode] ("bn" or "en"); the other name when that one is empty.
  String label(String languageCode) {
    final preferred = languageCode == 'bn' ? nameBn : nameEn;
    final other = languageCode == 'bn' ? nameEn : nameBn;
    return preferred.isNotEmpty ? preferred : other;
  }
}
