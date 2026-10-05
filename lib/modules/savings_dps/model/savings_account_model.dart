import 'package:json_annotation/json_annotation.dart';

part 'savings_account_model.g.dart';

enum SavingsType { general, dps, fdr }

@JsonSerializable()
class SavingsAccountModel {
  final String id;

  @JsonKey(name: 'account_number')
  final String accountNumber;

  @JsonKey(name: 'account_title')
  final String accountTitle;

  final SavingsType type;

  final double balance;

  @JsonKey(name: 'monthly_installment')
  final double? monthlyInstallment;

  @JsonKey(name: 'total_installments')
  final int? totalInstallments;

  @JsonKey(name: 'paid_installments')
  final int? paidInstallments;

  @JsonKey(name: 'maturity_date')
  final String? maturityDate;

  final String status;

  const SavingsAccountModel({
    required this.id,
    required this.accountNumber,
    required this.accountTitle,
    required this.type,
    required this.balance,
    this.monthlyInstallment,
    this.totalInstallments,
    this.paidInstallments,
    this.maturityDate,
    this.status = 'ACTIVE',
  });

  factory SavingsAccountModel.fromJson(Map<String, dynamic> json) =>
      _$SavingsAccountModelFromJson(json);

  Map<String, dynamic> toJson() => _$SavingsAccountModelToJson(this);
}
