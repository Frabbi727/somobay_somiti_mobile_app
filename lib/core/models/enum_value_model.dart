import 'package:json_annotation/json_annotation.dart';

part 'enum_value_model.g.dart';

/// A status or type from the API: a stable [value], a [label] already in the request language,
/// and an optional colour name (success, warning, danger, info, gray, primary).
@JsonSerializable()
class EnumValueModel {
  final String value;
  final String label;
  final String? color;

  const EnumValueModel({required this.value, required this.label, this.color});

  factory EnumValueModel.fromJson(Map<String, dynamic> json) => _$EnumValueModelFromJson(json);

  Map<String, dynamic> toJson() => _$EnumValueModelToJson(this);
}
