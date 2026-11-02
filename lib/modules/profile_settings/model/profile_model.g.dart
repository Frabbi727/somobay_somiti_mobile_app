// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NomineeModel _$NomineeModelFromJson(Map<String, dynamic> json) => NomineeModel(
  name: json['name'] as String,
  relation: json['relation'] as String,
  sharePercent: json['share_percent'] as String,
  shareDisplay: json['share_display'] as String,
);

Map<String, dynamic> _$NomineeModelToJson(NomineeModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'relation': instance.relation,
      'share_percent': instance.sharePercent,
      'share_display': instance.shareDisplay,
    };

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) => ProfileModel(
  memberNo: json['member_no'] as String,
  name: json['name'] as String,
  nameBn: json['name_bn'] as String,
  nameEn: json['name_en'] as String,
  mobile: json['mobile'] as String,
  joinedOn: json['joined_on'] as String,
  status: EnumValueModel.fromJson(json['status'] as Map<String, dynamic>),
  nominees: (json['nominees'] as List<dynamic>)
      .map((e) => NomineeModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'member_no': instance.memberNo,
      'name': instance.name,
      'name_bn': instance.nameBn,
      'name_en': instance.nameEn,
      'mobile': instance.mobile,
      'joined_on': instance.joinedOn,
      'status': instance.status.toJson(),
      'nominees': instance.nominees.map((e) => e.toJson()).toList(),
    };

DividendModel _$DividendModelFromJson(Map<String, dynamic> json) =>
    DividendModel(
      id: (json['id'] as num).toInt(),
      fiscalYear: json['fiscal_year'] as String,
      shareMonths: (json['share_months'] as num).toInt(),
      amount: MoneyModel.fromJson(json['amount'] as Map<String, dynamic>),
      status: EnumValueModel.fromJson(json['status'] as Map<String, dynamic>),
      settledAt: json['settled_at'] as String?,
    );

Map<String, dynamic> _$DividendModelToJson(DividendModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fiscal_year': instance.fiscalYear,
      'share_months': instance.shareMonths,
      'amount': instance.amount.toJson(),
      'status': instance.status.toJson(),
      'settled_at': instance.settledAt,
    };
