// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentSummaryModel _$PaymentSummaryModelFromJson(Map<String, dynamic> json) =>
    PaymentSummaryModel(
      id: (json['id'] as num).toInt(),
      receivedOn: json['received_on'] as String,
      method: EnumValueModel.fromJson(json['method'] as Map<String, dynamic>),
      trxId: json['trx_id'] as String?,
      amount: MoneyModel.fromJson(json['amount'] as Map<String, dynamic>),
      status: EnumValueModel.fromJson(json['status'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PaymentSummaryModelToJson(
  PaymentSummaryModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'received_on': instance.receivedOn,
  'method': instance.method.toJson(),
  'trx_id': instance.trxId,
  'amount': instance.amount.toJson(),
  'status': instance.status.toJson(),
};
