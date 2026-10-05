import 'package:json_annotation/json_annotation.dart';

part 'transaction_model.g.dart';

enum TransactionType { credit, debit }

@JsonSerializable()
class TransactionModel {
  final String id;

  @JsonKey(name: 'transaction_id')
  final String transactionId;

  final String title;

  final double amount;

  final TransactionType type;

  @JsonKey(name: 'created_at')
  final String createdAt;

  final String status;

  @JsonKey(name: 'payment_method')
  final String paymentMethod;

  @JsonKey(name: 'account_number')
  final String accountNumber;

  const TransactionModel({
    required this.id,
    required this.transactionId,
    required this.title,
    required this.amount,
    required this.type,
    required this.createdAt,
    this.status = 'COMPLETED',
    this.paymentMethod = 'bKash',
    required this.accountNumber,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);
}
