import 'package:json_annotation/json_annotation.dart';

part 'user_profile_model.g.dart';

@JsonSerializable()
class UserProfileModel {
  final String id;

  @JsonKey(name: 'member_id')
  final String memberId;

  final String name;

  final String phone;

  final String nid;

  final String? email;

  final String address;

  @JsonKey(name: 'nominee_name')
  final String nomineeName;

  @JsonKey(name: 'nominee_relation')
  final String nomineeRelation;

  @JsonKey(name: 'joined_date')
  final String joinedDate;

  final String status;

  const UserProfileModel({
    required this.id,
    required this.memberId,
    required this.name,
    required this.phone,
    required this.nid,
    this.email,
    required this.address,
    required this.nomineeName,
    required this.nomineeRelation,
    required this.joinedDate,
    this.status = 'ACTIVE',
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileModelToJson(this);
}
