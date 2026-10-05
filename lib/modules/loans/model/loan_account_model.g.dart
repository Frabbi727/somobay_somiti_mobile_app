// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_account_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoanAccountModel _$LoanAccountModelFromJson(Map<String, dynamic> json) =>
    LoanAccountModel(
      id: json['id'] as String,
      loanNumber: json['loan_number'] as String,
      loanScheme: json['loan_scheme'] as String,
      sanctionedAmount: (json['sanctioned_amount'] as num).toDouble(),
      remainingBalance: (json['remaining_balance'] as num).toDouble(),
      installmentAmount: (json['installment_amount'] as num).toDouble(),
      totalInstallments: (json['total_installments'] as num).toInt(),
      paidInstallments: (json['paid_installments'] as num).toInt(),
      nextInstallmentDate: json['next_installment_date'] as String,
      overdueAmount: (json['overdue_amount'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? 'ACTIVE',
    );

Map<String, dynamic> _$LoanAccountModelToJson(LoanAccountModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'loan_number': instance.loanNumber,
      'loan_scheme': instance.loanScheme,
      'sanctioned_amount': instance.sanctionedAmount,
      'remaining_balance': instance.remainingBalance,
      'installment_amount': instance.installmentAmount,
      'total_installments': instance.totalInstallments,
      'paid_installments': instance.paidInstallments,
      'next_installment_date': instance.nextInstallmentDate,
      'overdue_amount': instance.overdueAmount,
      'status': instance.status,
    };
