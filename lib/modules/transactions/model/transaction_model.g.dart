// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    TransactionModel(
      id: json['id'] as String,
      transactionId: json['transaction_id'] as String,
      title: json['title'] as String,
      amount: (json['amount'] as num).toDouble(),
      type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
      createdAt: json['created_at'] as String,
      status: json['status'] as String? ?? 'COMPLETED',
      paymentMethod: json['payment_method'] as String? ?? 'bKash',
      accountNumber: json['account_number'] as String,
    );

Map<String, dynamic> _$TransactionModelToJson(TransactionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'transaction_id': instance.transactionId,
      'title': instance.title,
      'amount': instance.amount,
      'type': _$TransactionTypeEnumMap[instance.type]!,
      'created_at': instance.createdAt,
      'status': instance.status,
      'payment_method': instance.paymentMethod,
      'account_number': instance.accountNumber,
    };

const _$TransactionTypeEnumMap = {
  TransactionType.credit: 'credit',
  TransactionType.debit: 'debit',
};
