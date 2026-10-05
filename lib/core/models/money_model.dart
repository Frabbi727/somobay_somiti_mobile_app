import 'package:json_annotation/json_annotation.dart';

part 'money_model.g.dart';

/// An amount from the API: exact poisha (৳1 = 100) plus the backend's own formatted text.
/// The app shows [display] and only compares [poisha] with zero; it never does money arithmetic.
@JsonSerializable()
class MoneyModel {
  final int poisha;
  final String display;

  const MoneyModel({required this.poisha, required this.display});

  bool get isPositive => poisha > 0;

  factory MoneyModel.fromJson(Map<String, dynamic> json) => _$MoneyModelFromJson(json);

  Map<String, dynamic> toJson() => _$MoneyModelToJson(this);
}
