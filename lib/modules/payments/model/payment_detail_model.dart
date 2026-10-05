import 'package:json_annotation/json_annotation.dart';
import '../../../core/models/enum_value_model.dart';
import '../../../core/models/money_model.dart';

part 'payment_detail_model.g.dart';

/// What part of an approved payment settled which due.
@JsonSerializable(explicitToJson: true)
class PaymentAllocationModel {
  @JsonKey(name: 'due_id')
  final int dueId;

  final String month;
  final EnumValueModel type;
  final MoneyModel amount;

  const PaymentAllocationModel({required this.dueId, required this.month, required this.type, required this.amount});

  factory PaymentAllocationModel.fromJson(Map<String, dynamic> json) => _$PaymentAllocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentAllocationModelToJson(this);
}

/// One payment with how it was used (allocations empty until staff approve it).
@JsonSerializable(explicitToJson: true)
class PaymentDetailModel {
  final int id;

  @JsonKey(name: 'received_on')
  final String receivedOn;

  final EnumValueModel method;

  @JsonKey(name: 'trx_id')
  final String? trxId;

  final MoneyModel amount;
  final EnumValueModel status;

  @JsonKey(name: 'rejection_reason')
  final String? rejectionReason;

  @JsonKey(name: 'approved_at')
  final String? approvedAt;

  @JsonKey(name: 'receipt_available')
  final bool receiptAvailable;

  final List<PaymentAllocationModel> allocations;

  @JsonKey(name: 'to_advance')
  final MoneyModel toAdvance;

  const PaymentDetailModel({
    required this.id,
    required this.receivedOn,
    required this.method,
    this.trxId,
    required this.amount,
    required this.status,
    this.rejectionReason,
    this.approvedAt,
    required this.receiptAvailable,
    required this.allocations,
    required this.toAdvance,
  });

  factory PaymentDetailModel.fromJson(Map<String, dynamic> json) => _$PaymentDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentDetailModelToJson(this);
}
