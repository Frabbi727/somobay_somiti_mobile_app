// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geo_place_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeoPlaceModel _$GeoPlaceModelFromJson(Map<String, dynamic> json) =>
    GeoPlaceModel(
      id: (json['id'] as num).toInt(),
      nameBn: json['name_bn'] as String,
      nameEn: json['name_en'] as String,
    );

Map<String, dynamic> _$GeoPlaceModelToJson(GeoPlaceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name_bn': instance.nameBn,
      'name_en': instance.nameEn,
    };
