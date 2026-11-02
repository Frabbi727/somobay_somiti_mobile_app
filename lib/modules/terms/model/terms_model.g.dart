// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'terms_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TermsModel _$TermsModelFromJson(Map<String, dynamic> json) => TermsModel(
  version: (json['version'] as num).toInt(),
  rulesBn: json['rules_bn'] as String,
  rulesEn: json['rules_en'] as String,
  declarationBn: json['declaration_bn'] as String,
  declarationEn: json['declaration_en'] as String,
  accepted: json['accepted'] as bool?,
);

Map<String, dynamic> _$TermsModelToJson(TermsModel instance) =>
    <String, dynamic>{
      'version': instance.version,
      'rules_bn': instance.rulesBn,
      'rules_en': instance.rulesEn,
      'declaration_bn': instance.declarationBn,
      'declaration_en': instance.declarationEn,
      'accepted': instance.accepted,
    };
