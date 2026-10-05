import 'package:json_annotation/json_annotation.dart';
import '../../../core/models/enum_value_model.dart';
import '../../../core/models/money_model.dart';

part 'profile_model.g.dart';

@JsonSerializable()
class NomineeModel {
  final String name;
  final String relation;

  @JsonKey(name: 'share_percent')
  final String sharePercent;

  @JsonKey(name: 'share_display')
  final String shareDisplay;

  const NomineeModel({required this.name, required this.relation, required this.sharePercent, required this.shareDisplay});

  factory NomineeModel.fromJson(Map<String, dynamic> json) => _$NomineeModelFromJson(json);

  Map<String, dynamic> toJson() => _$NomineeModelToJson(this);
}

/// The member's details as the society holds them (read-only, as on the web portal).
@JsonSerializable(explicitToJson: true)
class ProfileModel {
  @JsonKey(name: 'member_no')
  final String memberNo;

  final String name;

  @JsonKey(name: 'name_bn')
  final String nameBn;

  @JsonKey(name: 'name_en')
  final String nameEn;

  final String mobile;

  @JsonKey(name: 'joined_on')
  final String joinedOn;

  final EnumValueModel status;
  final List<NomineeModel> nominees;

  const ProfileModel({
    required this.memberNo,
    required this.name,
    required this.nameBn,
    required this.nameEn,
    required this.mobile,
    required this.joinedOn,
    required this.status,
    required this.nominees,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => _$ProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);
}

/// A dividend for one closed fiscal year, split by share-months.
@JsonSerializable(explicitToJson: true)
class DividendModel {
  final int id;

  @JsonKey(name: 'fiscal_year')
  final String fiscalYear;

  @JsonKey(name: 'share_months')
  final int shareMonths;

  final MoneyModel amount;
  final EnumValueModel status;

  @JsonKey(name: 'settled_at')
  final String? settledAt;

  const DividendModel({required this.id, required this.fiscalYear, required this.shareMonths, required this.amount, required this.status, this.settledAt});

  factory DividendModel.fromJson(Map<String, dynamic> json) => _$DividendModelFromJson(json);

  Map<String, dynamic> toJson() => _$DividendModelToJson(this);
}
