// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentAllocationModel _$PaymentAllocationModelFromJson(
  Map<String, dynamic> json,
) => PaymentAllocationModel(
  dueId: (json['due_id'] as num).toInt(),
  month: json['month'] as String,
  type: EnumValueModel.fromJson(json['type'] as Map<String, dynamic>),
  amount: MoneyModel.fromJson(json['amount'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PaymentAllocationModelToJson(
  PaymentAllocationModel instance,
) => <String, dynamic>{
  'due_id': instance.dueId,
  'month': instance.month,
  'type': instance.type.toJson(),
  'amount': instance.amount.toJson(),
};

PaymentDetailModel _$PaymentDetailModelFromJson(
  Map<String, dynamic> json,
) => PaymentDetailModel(
  id: (json['id'] as num).toInt(),
  receivedOn: json['received_on'] as String,
  method: EnumValueModel.fromJson(json['method'] as Map<String, dynamic>),
  trxId: json['trx_id'] as String?,
  amount: MoneyModel.fromJson(json['amount'] as Map<String, dynamic>),
  status: EnumValueModel.fromJson(json['status'] as Map<String, dynamic>),
  rejectionReason: json['rejection_reason'] as String?,
  approvedAt: json['approved_at'] as String?,
  receiptAvailable: json['receipt_available'] as bool,
  allocations: (json['allocations'] as List<dynamic>)
      .map((e) => PaymentAllocationModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  toAdvance: MoneyModel.fromJson(json['to_advance'] as Map<String, dynamic>),
);

Map<String, dynamic> _$PaymentDetailModelToJson(PaymentDetailModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'received_on': instance.receivedOn,
      'method': instance.method.toJson(),
      'trx_id': instance.trxId,
      'amount': instance.amount.toJson(),
      'status': instance.status.toJson(),
      'rejection_reason': instance.rejectionReason,
      'approved_at': instance.approvedAt,
      'receipt_available': instance.receiptAvailable,
      'allocations': instance.allocations.map((e) => e.toJson()).toList(),
      'to_advance': instance.toAdvance.toJson(),
    };
