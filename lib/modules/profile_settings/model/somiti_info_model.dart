import 'package:json_annotation/json_annotation.dart';

part 'somiti_info_model.g.dart';

/// The society's own details (`config/somiti-info`), available before sign-in.
@JsonSerializable()
class SomitiInfoModel {
  final String name;

  @JsonKey(name: 'name_bn')
  final String nameBn;

  @JsonKey(name: 'name_en')
  final String nameEn;

  @JsonKey(name: 'registration_no')
  final String? registrationNo;

  final String? address;
  final String? phone;
  final String? email;

  @JsonKey(name: 'logo_url')
  final String? logoUrl;

  @JsonKey(name: 'otp_enabled')
  final bool otpEnabled;

  const SomitiInfoModel({
    required this.name,
    required this.nameBn,
    required this.nameEn,
    this.registrationNo,
    this.address,
    this.phone,
    this.email,
    this.logoUrl,
    required this.otpEnabled,
  });

  factory SomitiInfoModel.fromJson(Map<String, dynamic> json) => _$SomitiInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$SomitiInfoModelToJson(this);
}
