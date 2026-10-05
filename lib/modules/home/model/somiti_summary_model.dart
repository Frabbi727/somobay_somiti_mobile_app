import 'package:json_annotation/json_annotation.dart';

part 'somiti_summary_model.g.dart';

@JsonSerializable()
class SomitiSummaryModel {
  @JsonKey(name: 'member_name')
  final String memberName;

  @JsonKey(name: 'member_id')
  final String memberId;

  @JsonKey(name: 'somiti_name')
  final String somitiName;

  @JsonKey(name: 'total_savings')
  final double totalSavings;

  @JsonKey(name: 'active_loan_balance')
  final double activeLoanBalance;

  @JsonKey(name: 'total_shares_count')
  final int totalSharesCount;

  @JsonKey(name: 'total_shares_value')
  final double totalSharesValue;

  @JsonKey(name: 'next_due_date')
  final String? nextDueDate;

  @JsonKey(name: 'next_due_amount')
  final double? nextDueAmount;

  @JsonKey(name: 'unread_notices_count')
  final int unreadNoticesCount;

  const SomitiSummaryModel({
    required this.memberName,
    required this.memberId,
    required this.somitiName,
    required this.totalSavings,
    required this.activeLoanBalance,
    required this.totalSharesCount,
    required this.totalSharesValue,
    this.nextDueDate,
    this.nextDueAmount,
    this.unreadNoticesCount = 0,
  });

  factory SomitiSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$SomitiSummaryModelFromJson(json);

  Map<String, dynamic> toJson() => _$SomitiSummaryModelToJson(this);
}
