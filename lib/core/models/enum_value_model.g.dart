// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enum_value_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EnumValueModel _$EnumValueModelFromJson(Map<String, dynamic> json) =>
    EnumValueModel(
      value: json['value'] as String,
      label: json['label'] as String,
      color: json['color'] as String?,
    );

Map<String, dynamic> _$EnumValueModelToJson(EnumValueModel instance) =>
    <String, dynamic>{
      'value': instance.value,
      'label': instance.label,
      'color': instance.color,
    };
