// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfileModel _$UserProfileModelFromJson(Map<String, dynamic> json) =>
    UserProfileModel(
      id: json['id'] as String,
      memberId: json['member_id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      nid: json['nid'] as String,
      email: json['email'] as String?,
      address: json['address'] as String,
      nomineeName: json['nominee_name'] as String,
      nomineeRelation: json['nominee_relation'] as String,
      joinedDate: json['joined_date'] as String,
      status: json['status'] as String? ?? 'ACTIVE',
    );

Map<String, dynamic> _$UserProfileModelToJson(UserProfileModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'member_id': instance.memberId,
      'name': instance.name,
      'phone': instance.phone,
      'nid': instance.nid,
      'email': instance.email,
      'address': instance.address,
      'nominee_name': instance.nomineeName,
      'nominee_relation': instance.nomineeRelation,
      'joined_date': instance.joinedDate,
      'status': instance.status,
    };
