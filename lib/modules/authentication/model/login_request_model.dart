import 'package:json_annotation/json_annotation.dart';

part 'login_request_model.g.dart';

/// Sign-in with mobile + password, or mobile + SMS code (when the society allows codes).
@JsonSerializable(includeIfNull: false)
class LoginRequestModel {
  final String mobile;
  final String? password;
  final String? code;

  const LoginRequestModel({
    required this.mobile,
    this.password,
    this.code,
  });

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) => _$LoginRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestModelToJson(this);
}
