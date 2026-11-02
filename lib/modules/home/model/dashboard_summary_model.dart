import 'package:json_annotation/json_annotation.dart';
import '../../../core/models/enum_value_model.dart';
import '../../../core/models/money_model.dart';
import '../../payments/model/payment_summary_model.dart';

part 'dashboard_summary_model.g.dart';

/// Who is signed in (`auth/me`, and `member` in the dashboard summary).
@JsonSerializable(explicitToJson: true)
class MemberBriefModel {
  @JsonKey(name: 'member_no')
  final String memberNo;

  final String name;
  final EnumValueModel status;

  const MemberBriefModel({required this.memberNo, required this.name, required this.status});

  factory MemberBriefModel.fromJson(Map<String, dynamic> json) => _$MemberBriefModelFromJson(json);

  Map<String, dynamic> toJson() => _$MemberBriefModelToJson(this);
}

/// The home screen: every figure is calculated by the backend (docs/MEMBER_ACCOUNTING_RULES.md).
@JsonSerializable(explicitToJson: true)
class DashboardSummaryModel {
  final MemberBriefModel member;
  final MoneyModel savings;
  final MoneyModel advance;
  final MoneyModel outstanding;

  @JsonKey(name: 'paid_through')
  final String? paidThrough;

  @JsonKey(name: 'advance_months_estimate')
  final int advanceMonthsEstimate;

  final int shares;

  @JsonKey(name: 'pay_now_visible')
  final bool payNowVisible;

  @JsonKey(name: 'recent_payments')
  final List<PaymentSummaryModel> recentPayments;

  const DashboardSummaryModel({
    required this.member,
    required this.savings,
    required this.advance,
    required this.outstanding,
    this.paidThrough,
    required this.advanceMonthsEstimate,
    required this.shares,
    required this.payNowVisible,
    required this.recentPayments,
  });

  factory DashboardSummaryModel.fromJson(Map<String, dynamic> json) => _$DashboardSummaryModelFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardSummaryModelToJson(this);
}
