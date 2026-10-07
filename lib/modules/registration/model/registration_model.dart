import 'package:json_annotation/json_annotation.dart';

import '../../../core/models/enum_value_model.dart';

part 'registration_model.g.dart';

/// The member's own registration as `GET /api/v1/registration` returns it. Every label is already
/// in the member's language; the app shows them as they are.
@JsonSerializable(explicitToJson: true)
class RegistrationModel {
  final EnumValueModel status;
  @JsonKey(name: 'next_action')
  final String nextAction; // complete | resubmit | wait | none
  @JsonKey(name: 'can_edit')
  final bool canEdit;
  final String headline;
  final String message;
  final List<TimelineStepModel> timeline;
  final RegistrationDecisionModel? decision;
  final RegistrationDataModel data;

  const RegistrationModel({
    required this.status,
    required this.nextAction,
    required this.canEdit,
    required this.headline,
    required this.message,
    required this.timeline,
    required this.decision,
    required this.data,
  });

  factory RegistrationModel.fromJson(Map<String, dynamic> json) => _$RegistrationModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegistrationModelToJson(this);
}

@JsonSerializable()
class TimelineStepModel {
  final String key;
  final String label;
  final String state; // done | pending | waiting | returned | rejected
  @JsonKey(name: 'acted_at')
  final String? actedAt;
  final String? actor;
  final String? reason;

  const TimelineStepModel({required this.key, required this.label, required this.state, this.actedAt, this.actor, this.reason});

  factory TimelineStepModel.fromJson(Map<String, dynamic> json) => _$TimelineStepModelFromJson(json);

  Map<String, dynamic> toJson() => _$TimelineStepModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class RegistrationDecisionModel {
  final EnumValueModel type;
  @JsonKey(name: 'by_role')
  final String byRole;
  final String? at;
  final String? reason;

  const RegistrationDecisionModel({required this.type, required this.byRole, this.at, this.reason});

  factory RegistrationDecisionModel.fromJson(Map<String, dynamic> json) => _$RegistrationDecisionModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegistrationDecisionModelToJson(this);
}

@JsonSerializable(explicitToJson: true)
class RegistrationDataModel {
  @JsonKey(name: 'name_bn')
  final String? nameBn;
  @JsonKey(name: 'name_en')
  final String? nameEn;
  @JsonKey(name: 'guardian_name')
  final String? guardianName;
  final String? nid;
  @JsonKey(name: 'date_of_birth')
  final String? dateOfBirth;
  final String mobile;
  final String? email;
  final String? address;
  @JsonKey(name: 'photo_url')
  final String? photoUrl;
  @JsonKey(name: 'requested_shares')
  final int? requestedShares;
  final List<RegistrationNomineeModel> nominees;

  const RegistrationDataModel({
    this.nameBn,
    this.nameEn,
    this.guardianName,
    this.nid,
    this.dateOfBirth,
    required this.mobile,
    this.email,
    this.address,
    this.photoUrl,
    this.requestedShares,
    required this.nominees,
  });

  factory RegistrationDataModel.fromJson(Map<String, dynamic> json) => _$RegistrationDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegistrationDataModelToJson(this);
}

@JsonSerializable()
class RegistrationNomineeModel {
  final String name;
  @JsonKey(name: 'relation_id')
  final int? relationId;
  final String? relation;
  final String? mobile;
  final String? nid;
  @JsonKey(name: 'share_percent')
  final String sharePercent;

  const RegistrationNomineeModel({required this.name, this.relationId, this.relation, this.mobile, this.nid, required this.sharePercent});

  factory RegistrationNomineeModel.fromJson(Map<String, dynamic> json) => _$RegistrationNomineeModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegistrationNomineeModelToJson(this);
}

@JsonSerializable()
class NomineeRelationModel {
  final int id;
  final String key;
  final String label;

  const NomineeRelationModel({required this.id, required this.key, required this.label});

  factory NomineeRelationModel.fromJson(Map<String, dynamic> json) => _$NomineeRelationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NomineeRelationModelToJson(this);
}
