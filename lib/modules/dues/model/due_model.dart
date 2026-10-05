import 'package:json_annotation/json_annotation.dart';
import '../../../core/models/enum_value_model.dart';
import '../../../core/models/money_model.dart';

part 'due_model.g.dart';

/// One due of one month (deposit, service charge, registration fee or late fee).
@JsonSerializable(explicitToJson: true)
class DueModel {
  final int id;
  final String month;
  final EnumValueModel type;
  final MoneyModel amount;
  final MoneyModel paid;
  final MoneyModel outstanding;

  @JsonKey(name: 'due_date')
  final String dueDate;

  final EnumValueModel status;

  const DueModel({
    required this.id,
    required this.month,
    required this.type,
    required this.amount,
    required this.paid,
    required this.outstanding,
    required this.dueDate,
    required this.status,
  });

  factory DueModel.fromJson(Map<String, dynamic> json) => _$DueModelFromJson(json);

  Map<String, dynamic> toJson() => _$DueModelToJson(this);
}
