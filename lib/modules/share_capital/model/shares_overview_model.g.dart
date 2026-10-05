// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shares_overview_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShareChangeModel _$ShareChangeModelFromJson(Map<String, dynamic> json) =>
    ShareChangeModel(
      type: EnumValueModel.fromJson(json['type'] as Map<String, dynamic>),
      shares: (json['shares'] as num).toInt(),
      sharesAfter: (json['shares_after'] as num).toInt(),
      effectiveFrom: json['effective_from'] as String,
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$ShareChangeModelToJson(ShareChangeModel instance) =>
    <String, dynamic>{
      'type': instance.type.toJson(),
      'shares': instance.shares,
      'shares_after': instance.sharesAfter,
      'effective_from': instance.effectiveFrom,
      'reason': instance.reason,
    };

LateFeeModel _$LateFeeModelFromJson(Map<String, dynamic> json) => LateFeeModel(
  mode: EnumValueModel.fromJson(json['mode'] as Map<String, dynamic>),
  fixed: json['fixed'] == null
      ? null
      : MoneyModel.fromJson(json['fixed'] as Map<String, dynamic>),
  percent: json['percent'] as String?,
  cap: json['cap'] == null
      ? null
      : MoneyModel.fromJson(json['cap'] as Map<String, dynamic>),
  frequency: json['frequency'] == null
      ? null
      : EnumValueModel.fromJson(json['frequency'] as Map<String, dynamic>),
);

Map<String, dynamic> _$LateFeeModelToJson(LateFeeModel instance) =>
    <String, dynamic>{
      'mode': instance.mode.toJson(),
      'fixed': instance.fixed?.toJson(),
      'percent': instance.percent,
      'cap': instance.cap?.toJson(),
      'frequency': instance.frequency?.toJson(),
    };

RatesModel _$RatesModelFromJson(Map<String, dynamic> json) => RatesModel(
  effectiveFrom: json['effective_from'] as String,
  shareUnit: MoneyModel.fromJson(json['share_unit'] as Map<String, dynamic>),
  serviceChargePerShare: MoneyModel.fromJson(
    json['service_charge_per_share'] as Map<String, dynamic>,
  ),
  registrationFeePerShare: MoneyModel.fromJson(
    json['registration_fee_per_share'] as Map<String, dynamic>,
  ),
  dueDay: (json['due_day'] as num).toInt(),
  graceDays: (json['grace_days'] as num).toInt(),
  lateFee: LateFeeModel.fromJson(json['late_fee'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RatesModelToJson(RatesModel instance) =>
    <String, dynamic>{
      'effective_from': instance.effectiveFrom,
      'share_unit': instance.shareUnit.toJson(),
      'service_charge_per_share': instance.serviceChargePerShare.toJson(),
      'registration_fee_per_share': instance.registrationFeePerShare.toJson(),
      'due_day': instance.dueDay,
      'grace_days': instance.graceDays,
      'late_fee': instance.lateFee.toJson(),
    };

SharesOverviewModel _$SharesOverviewModelFromJson(Map<String, dynamic> json) =>
    SharesOverviewModel(
      currentShares: (json['current_shares'] as num).toInt(),
      history: (json['history'] as List<dynamic>)
          .map((e) => ShareChangeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      rates: json['rates'] == null
          ? null
          : RatesModel.fromJson(json['rates'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SharesOverviewModelToJson(
  SharesOverviewModel instance,
) => <String, dynamic>{
  'current_shares': instance.currentShares,
  'history': instance.history.map((e) => e.toJson()).toList(),
  'rates': instance.rates?.toJson(),
};
