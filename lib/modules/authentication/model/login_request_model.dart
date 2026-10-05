import 'package:json_annotation/json_annotation.dart';

part 'login_request_model.g.dart';

@JsonSerializable()
class LoginRequestModel {
  final String phone;
  final String password;
  @JsonKey(name: 'device_id')
  final String? deviceId;

  const LoginRequestModel({
    required this.phone,
    required this.password,
    this.deviceId,
  });

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestModelToJson(this);
}
