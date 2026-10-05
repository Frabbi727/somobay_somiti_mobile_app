// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'somiti_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SomitiSummaryModel _$SomitiSummaryModelFromJson(Map<String, dynamic> json) =>
    SomitiSummaryModel(
      memberName: json['member_name'] as String,
      memberId: json['member_id'] as String,
      somitiName: json['somiti_name'] as String,
      totalSavings: (json['total_savings'] as num).toDouble(),
      activeLoanBalance: (json['active_loan_balance'] as num).toDouble(),
      totalSharesCount: (json['total_shares_count'] as num).toInt(),
      totalSharesValue: (json['total_shares_value'] as num).toDouble(),
      nextDueDate: json['next_due_date'] as String?,
      nextDueAmount: (json['next_due_amount'] as num?)?.toDouble(),
      unreadNoticesCount: (json['unread_notices_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$SomitiSummaryModelToJson(SomitiSummaryModel instance) =>
    <String, dynamic>{
      'member_name': instance.memberName,
      'member_id': instance.memberId,
      'somiti_name': instance.somitiName,
      'total_savings': instance.totalSavings,
      'active_loan_balance': instance.activeLoanBalance,
      'total_shares_count': instance.totalSharesCount,
      'total_shares_value': instance.totalSharesValue,
      'next_due_date': instance.nextDueDate,
      'next_due_amount': instance.nextDueAmount,
      'unread_notices_count': instance.unreadNoticesCount,
    };
