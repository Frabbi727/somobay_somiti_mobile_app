import 'package:json_annotation/json_annotation.dart';
import '../../../core/models/enum_value_model.dart';
import '../../../core/models/money_model.dart';

part 'payment_summary_model.g.dart';

/// A payment as listed (payments tab, home "recent payments").
@JsonSerializable(explicitToJson: true)
class PaymentSummaryModel {
  final int id;

  @JsonKey(name: 'received_on')
  final String receivedOn;

  final EnumValueModel method;

  @JsonKey(name: 'trx_id')
  final String? trxId;

  final MoneyModel amount;
  final EnumValueModel status;

  const PaymentSummaryModel({
    required this.id,
    required this.receivedOn,
    required this.method,
    this.trxId,
    required this.amount,
    required this.status,
  });

  factory PaymentSummaryModel.fromJson(Map<String, dynamic> json) => _$PaymentSummaryModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentSummaryModelToJson(this);
}
