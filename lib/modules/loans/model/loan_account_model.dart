import 'package:json_annotation/json_annotation.dart';

part 'loan_account_model.g.dart';

@JsonSerializable()
class LoanAccountModel {
  final String id;

  @JsonKey(name: 'loan_number')
  final String loanNumber;

  @JsonKey(name: 'loan_scheme')
  final String loanScheme;

  @JsonKey(name: 'sanctioned_amount')
  final double sanctionedAmount;

  @JsonKey(name: 'remaining_balance')
  final double remainingBalance;

  @JsonKey(name: 'installment_amount')
  final double installmentAmount;

  @JsonKey(name: 'total_installments')
  final int totalInstallments;

  @JsonKey(name: 'paid_installments')
  final int paidInstallments;

  @JsonKey(name: 'next_installment_date')
  final String nextInstallmentDate;

  @JsonKey(name: 'overdue_amount')
  final double overdueAmount;

  final String status;

  const LoanAccountModel({
    required this.id,
    required this.loanNumber,
    required this.loanScheme,
    required this.sanctionedAmount,
    required this.remainingBalance,
    required this.installmentAmount,
    required this.totalInstallments,
    required this.paidInstallments,
    required this.nextInstallmentDate,
    this.overdueAmount = 0.0,
    this.status = 'ACTIVE',
  });

  factory LoanAccountModel.fromJson(Map<String, dynamic> json) =>
      _$LoanAccountModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoanAccountModelToJson(this);
}
