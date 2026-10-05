// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'savings_account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SavingsAccountModel _$SavingsAccountModelFromJson(Map<String, dynamic> json) =>
    SavingsAccountModel(
      id: json['id'] as String,
      accountNumber: json['account_number'] as String,
      accountTitle: json['account_title'] as String,
      type: $enumDecode(_$SavingsTypeEnumMap, json['type']),
      balance: (json['balance'] as num).toDouble(),
      monthlyInstallment: (json['monthly_installment'] as num?)?.toDouble(),
      totalInstallments: (json['total_installments'] as num?)?.toInt(),
      paidInstallments: (json['paid_installments'] as num?)?.toInt(),
      maturityDate: json['maturity_date'] as String?,
      status: json['status'] as String? ?? 'ACTIVE',
    );

Map<String, dynamic> _$SavingsAccountModelToJson(
  SavingsAccountModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'account_number': instance.accountNumber,
  'account_title': instance.accountTitle,
  'type': _$SavingsTypeEnumMap[instance.type]!,
  'balance': instance.balance,
  'monthly_installment': instance.monthlyInstallment,
  'total_installments': instance.totalInstallments,
  'paid_installments': instance.paidInstallments,
  'maturity_date': instance.maturityDate,
  'status': instance.status,
};

const _$SavingsTypeEnumMap = {
  SavingsType.general: 'general',
  SavingsType.dps: 'dps',
  SavingsType.fdr: 'fdr',
};
