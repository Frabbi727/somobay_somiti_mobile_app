// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatementRowModel _$StatementRowModelFromJson(Map<String, dynamic> json) =>
    StatementRowModel(
      date: json['date'] as String?,
      description: json['description'] as String,
      charge: json['charge'] == null
          ? null
          : MoneyModel.fromJson(json['charge'] as Map<String, dynamic>),
      paid: json['paid'] == null
          ? null
          : MoneyModel.fromJson(json['paid'] as Map<String, dynamic>),
      balance: json['balance'] == null
          ? null
          : MoneyModel.fromJson(json['balance'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StatementRowModelToJson(StatementRowModel instance) =>
    <String, dynamic>{
      'date': instance.date,
      'description': instance.description,
      'charge': instance.charge?.toJson(),
      'paid': instance.paid?.toJson(),
      'balance': instance.balance?.toJson(),
    };

StatementModel _$StatementModelFromJson(Map<String, dynamic> json) =>
    StatementModel(
      from: json['from'] as String,
      until: json['until'] as String,
      opening: MoneyModel.fromJson(json['opening'] as Map<String, dynamic>),
      rows: (json['rows'] as List<dynamic>)
          .map((e) => StatementRowModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCharges: MoneyModel.fromJson(
        json['total_charges'] as Map<String, dynamic>,
      ),
      totalPaid: MoneyModel.fromJson(
        json['total_paid'] as Map<String, dynamic>,
      ),
      closing: MoneyModel.fromJson(json['closing'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StatementModelToJson(StatementModel instance) =>
    <String, dynamic>{
      'from': instance.from,
      'until': instance.until,
      'opening': instance.opening.toJson(),
      'rows': instance.rows.map((e) => e.toJson()).toList(),
      'total_charges': instance.totalCharges.toJson(),
      'total_paid': instance.totalPaid.toJson(),
      'closing': instance.closing.toJson(),
    };
