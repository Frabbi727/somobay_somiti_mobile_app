import 'package:json_annotation/json_annotation.dart';
import '../../../core/models/enum_value_model.dart';
import '../../../core/models/money_model.dart';

part 'shares_overview_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ShareChangeModel {
  final EnumValueModel type;
  final int shares;

  @JsonKey(name: 'shares_after')
  final int sharesAfter;

  @JsonKey(name: 'effective_from')
  final String effectiveFrom;

  final String? reason;

  const ShareChangeModel({required this.type, required this.shares, required this.sharesAfter, required this.effectiveFrom, this.reason});

  factory ShareChangeModel.fromJson(Map<String, dynamic> json) => _$ShareChangeModelFromJson(json);

  Map<String, dynamic> toJson() => _$ShareChangeModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class LateFeeModel {
  final EnumValueModel mode;
  final MoneyModel? fixed;

  /// Two decimals, e.g. "2.00" (mode = percent).
  final String? percent;

  final MoneyModel? cap;
  final EnumValueModel? frequency;

  const LateFeeModel({required this.mode, this.fixed, this.percent, this.cap, this.frequency});

  factory LateFeeModel.fromJson(Map<String, dynamic> json) => _$LateFeeModelFromJson(json);

  Map<String, dynamic> toJson() => _$LateFeeModelToJson(this);
}

/// This month's rates from the society's approved rate plan.
@JsonSerializable(explicitToJson: true)
class RatesModel {
  @JsonKey(name: 'effective_from')
  final String effectiveFrom;

  @JsonKey(name: 'share_unit')
  final MoneyModel shareUnit;

  @JsonKey(name: 'service_charge_per_share')
  final MoneyModel serviceChargePerShare;

  @JsonKey(name: 'registration_fee_per_share')
  final MoneyModel registrationFeePerShare;

  @JsonKey(name: 'due_day')
  final int dueDay;

  @JsonKey(name: 'grace_days')
  final int graceDays;

  @JsonKey(name: 'late_fee')
  final LateFeeModel lateFee;

  const RatesModel({
    required this.effectiveFrom,
    required this.shareUnit,
    required this.serviceChargePerShare,
    required this.registrationFeePerShare,
    required this.dueDay,
    required this.graceDays,
    required this.lateFee,
  });

  factory RatesModel.fromJson(Map<String, dynamic> json) => _$RatesModelFromJson(json);

  Map<String, dynamic> toJson() => _$RatesModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class SharesOverviewModel {
  @JsonKey(name: 'current_shares')
  final int currentShares;

  final List<ShareChangeModel> history;

  /// Null when no approved rate plan covers the current month.
  final RatesModel? rates;

  const SharesOverviewModel({required this.currentShares, required this.history, this.rates});

  factory SharesOverviewModel.fromJson(Map<String, dynamic> json) => _$SharesOverviewModelFromJson(json);

  Map<String, dynamic> toJson() => _$SharesOverviewModelToJson(this);
}
