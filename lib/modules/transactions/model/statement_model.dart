import 'package:json_annotation/json_annotation.dart';
import '../../../core/models/money_model.dart';

part 'statement_model.g.dart';

/// One line of the statement: a charge (a due, by its due date) or a payment, with the running
/// balance after it (positive = owed). Charge and paid are both present; one of them is zero.
@JsonSerializable(explicitToJson: true)
class StatementRowModel {
  final String? date;
  final String description;
  final MoneyModel? charge;
  final MoneyModel? paid;
  final MoneyModel? balance;

  const StatementRowModel({this.date, required this.description, this.charge, this.paid, this.balance});

  factory StatementRowModel.fromJson(Map<String, dynamic> json) => _$StatementRowModelFromJson(json);

  Map<String, dynamic> toJson() => _$StatementRowModelToJson(this);
}

/// The member statement (passbook) for a date range, as the web portal shows it.
@JsonSerializable(explicitToJson: true)
class StatementModel {
  final String from;
  final String until;
  final MoneyModel opening;
  final List<StatementRowModel> rows;

  @JsonKey(name: 'total_charges')
  final MoneyModel totalCharges;

  @JsonKey(name: 'total_paid')
  final MoneyModel totalPaid;

  final MoneyModel closing;

  const StatementModel({
    required this.from,
    required this.until,
    required this.opening,
    required this.rows,
    required this.totalCharges,
    required this.totalPaid,
    required this.closing,
  });

  factory StatementModel.fromJson(Map<String, dynamic> json) => _$StatementModelFromJson(json);

  Map<String, dynamic> toJson() => _$StatementModelToJson(this);
}
