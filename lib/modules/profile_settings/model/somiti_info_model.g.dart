// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'somiti_info_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SomitiInfoModel _$SomitiInfoModelFromJson(Map<String, dynamic> json) =>
    SomitiInfoModel(
      name: json['name'] as String,
      nameBn: json['name_bn'] as String,
      nameEn: json['name_en'] as String,
      registrationNo: json['registration_no'] as String?,
      address: json['address'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      logoUrl: json['logo_url'] as String?,
      otpEnabled: json['otp_enabled'] as bool,
    );

Map<String, dynamic> _$SomitiInfoModelToJson(SomitiInfoModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'name_bn': instance.nameBn,
      'name_en': instance.nameEn,
      'registration_no': instance.registrationNo,
      'address': instance.address,
      'phone': instance.phone,
      'email': instance.email,
      'logo_url': instance.logoUrl,
      'otp_enabled': instance.otpEnabled,
    };
