import 'package:json_annotation/json_annotation.dart';

part 'terms_model.g.dart';

/// The somiti's current rules (`terms/current`). The text is one string with a numbered rule per line.
@JsonSerializable()
class TermsModel {
  final int version;

  @JsonKey(name: 'rules_bn')
  final String rulesBn;

  @JsonKey(name: 'rules_en')
  final String rulesEn;

  @JsonKey(name: 'declaration_bn')
  final String declarationBn;

  @JsonKey(name: 'declaration_en')
  final String declarationEn;

  /// Whether this member accepted this version; null for an applicant.
  final bool? accepted;

  const TermsModel({
    required this.version,
    required this.rulesBn,
    required this.rulesEn,
    required this.declarationBn,
    required this.declarationEn,
    this.accepted,
  });

  factory TermsModel.fromJson(Map<String, dynamic> json) => _$TermsModelFromJson(json);

  Map<String, dynamic> toJson() => _$TermsModelToJson(this);

  /// The rules in [languageCode] ('bn' or 'en').
  String rules(String languageCode) => languageCode == 'bn' ? rulesBn : rulesEn;

  String declaration(String languageCode) => languageCode == 'bn' ? declarationBn : declarationEn;
}
