// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberBriefModel _$MemberBriefModelFromJson(Map<String, dynamic> json) =>
    MemberBriefModel(
      memberNo: json['member_no'] as String,
      name: json['name'] as String,
      status: EnumValueModel.fromJson(json['status'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MemberBriefModelToJson(MemberBriefModel instance) =>
    <String, dynamic>{
      'member_no': instance.memberNo,
      'name': instance.name,
      'status': instance.status.toJson(),
    };

DashboardSummaryModel _$DashboardSummaryModelFromJson(
  Map<String, dynamic> json,
) => DashboardSummaryModel(
  member: MemberBriefModel.fromJson(json['member'] as Map<String, dynamic>),
  savings: MoneyModel.fromJson(json['savings'] as Map<String, dynamic>),
  advance: MoneyModel.fromJson(json['advance'] as Map<String, dynamic>),
  outstanding: MoneyModel.fromJson(json['outstanding'] as Map<String, dynamic>),
  paidThrough: json['paid_through'] as String?,
  advanceMonthsEstimate: (json['advance_months_estimate'] as num).toInt(),
  shares: (json['shares'] as num).toInt(),
  payNowVisible: json['pay_now_visible'] as bool,
  recentPayments: (json['recent_payments'] as List<dynamic>)
      .map((e) => PaymentSummaryModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$DashboardSummaryModelToJson(
  DashboardSummaryModel instance,
) => <String, dynamic>{
  'member': instance.member.toJson(),
  'savings': instance.savings.toJson(),
  'advance': instance.advance.toJson(),
  'outstanding': instance.outstanding.toJson(),
  'paid_through': instance.paidThrough,
  'advance_months_estimate': instance.advanceMonthsEstimate,
  'shares': instance.shares,
  'pay_now_visible': instance.payNowVisible,
  'recent_payments': instance.recentPayments.map((e) => e.toJson()).toList(),
};
