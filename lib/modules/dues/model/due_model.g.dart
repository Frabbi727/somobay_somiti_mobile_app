// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'due_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DueModel _$DueModelFromJson(Map<String, dynamic> json) => DueModel(
  id: (json['id'] as num).toInt(),
  month: json['month'] as String,
  type: EnumValueModel.fromJson(json['type'] as Map<String, dynamic>),
  amount: MoneyModel.fromJson(json['amount'] as Map<String, dynamic>),
  paid: MoneyModel.fromJson(json['paid'] as Map<String, dynamic>),
  outstanding: MoneyModel.fromJson(json['outstanding'] as Map<String, dynamic>),
  dueDate: json['due_date'] as String,
  status: EnumValueModel.fromJson(json['status'] as Map<String, dynamic>),
);

Map<String, dynamic> _$DueModelToJson(DueModel instance) => <String, dynamic>{
  'id': instance.id,
  'month': instance.month,
  'type': instance.type.toJson(),
  'amount': instance.amount.toJson(),
  'paid': instance.paid.toJson(),
  'outstanding': instance.outstanding.toJson(),
  'due_date': instance.dueDate,
  'status': instance.status.toJson(),
};
