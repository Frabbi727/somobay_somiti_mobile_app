// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registration_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegistrationModel _$RegistrationModelFromJson(Map<String, dynamic> json) =>
    RegistrationModel(
      status: EnumValueModel.fromJson(json['status'] as Map<String, dynamic>),
      nextAction: json['next_action'] as String,
      canEdit: json['can_edit'] as bool,
      headline: json['headline'] as String,
      message: json['message'] as String,
      timeline: (json['timeline'] as List<dynamic>)
          .map((e) => TimelineStepModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      decision: json['decision'] == null
          ? null
          : RegistrationDecisionModel.fromJson(
              json['decision'] as Map<String, dynamic>,
            ),
      data: RegistrationDataModel.fromJson(
        json['data'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$RegistrationModelToJson(RegistrationModel instance) =>
    <String, dynamic>{
      'status': instance.status.toJson(),
      'next_action': instance.nextAction,
      'can_edit': instance.canEdit,
      'headline': instance.headline,
      'message': instance.message,
      'timeline': instance.timeline.map((e) => e.toJson()).toList(),
      'decision': instance.decision?.toJson(),
      'data': instance.data.toJson(),
    };

TimelineStepModel _$TimelineStepModelFromJson(Map<String, dynamic> json) =>
    TimelineStepModel(
      key: json['key'] as String,
      label: json['label'] as String,
      state: json['state'] as String,
      actedAt: json['acted_at'] as String?,
      actor: json['actor'] as String?,
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$TimelineStepModelToJson(TimelineStepModel instance) =>
    <String, dynamic>{
      'key': instance.key,
      'label': instance.label,
      'state': instance.state,
      'acted_at': instance.actedAt,
      'actor': instance.actor,
      'reason': instance.reason,
    };

RegistrationDecisionModel _$RegistrationDecisionModelFromJson(
  Map<String, dynamic> json,
) => RegistrationDecisionModel(
  type: EnumValueModel.fromJson(json['type'] as Map<String, dynamic>),
  byRole: json['by_role'] as String,
  at: json['at'] as String?,
  reason: json['reason'] as String?,
);

Map<String, dynamic> _$RegistrationDecisionModelToJson(
  RegistrationDecisionModel instance,
) => <String, dynamic>{
  'type': instance.type.toJson(),
  'by_role': instance.byRole,
  'at': instance.at,
  'reason': instance.reason,
};

RegistrationDataModel _$RegistrationDataModelFromJson(
  Map<String, dynamic> json,
) => RegistrationDataModel(
  nameBn: json['name_bn'] as String?,
  nameEn: json['name_en'] as String?,
  guardianName: json['guardian_name'] as String?,
  nid: json['nid'] as String?,
  dateOfBirth: json['date_of_birth'] as String?,
  mobile: json['mobile'] as String,
  email: json['email'] as String?,
  address: json['address'] as String?,
  photoUrl: json['photo_url'] as String?,
  requestedShares: (json['requested_shares'] as num?)?.toInt(),
  nominees: (json['nominees'] as List<dynamic>)
      .map((e) => RegistrationNomineeModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$RegistrationDataModelToJson(
  RegistrationDataModel instance,
) => <String, dynamic>{
  'name_bn': instance.nameBn,
  'name_en': instance.nameEn,
  'guardian_name': instance.guardianName,
  'nid': instance.nid,
  'date_of_birth': instance.dateOfBirth,
  'mobile': instance.mobile,
  'email': instance.email,
  'address': instance.address,
  'photo_url': instance.photoUrl,
  'requested_shares': instance.requestedShares,
  'nominees': instance.nominees.map((e) => e.toJson()).toList(),
};

RegistrationNomineeModel _$RegistrationNomineeModelFromJson(
  Map<String, dynamic> json,
) => RegistrationNomineeModel(
  name: json['name'] as String,
  relationId: (json['relation_id'] as num?)?.toInt(),
  relation: json['relation'] as String?,
  mobile: json['mobile'] as String?,
  nid: json['nid'] as String?,
  sharePercent: json['share_percent'] as String,
);

Map<String, dynamic> _$RegistrationNomineeModelToJson(
  RegistrationNomineeModel instance,
) => <String, dynamic>{
  'name': instance.name,
  'relation_id': instance.relationId,
  'relation': instance.relation,
  'mobile': instance.mobile,
  'nid': instance.nid,
  'share_percent': instance.sharePercent,
};

NomineeRelationModel _$NomineeRelationModelFromJson(
  Map<String, dynamic> json,
) => NomineeRelationModel(
  id: (json['id'] as num).toInt(),
  key: json['key'] as String,
  label: json['label'] as String,
);

Map<String, dynamic> _$NomineeRelationModelToJson(
  NomineeRelationModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'key': instance.key,
  'label': instance.label,
};
