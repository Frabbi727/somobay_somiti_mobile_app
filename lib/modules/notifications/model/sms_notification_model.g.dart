// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sms_notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SmsNotificationModel _$SmsNotificationModelFromJson(
  Map<String, dynamic> json,
) => SmsNotificationModel(
  id: (json['id'] as num).toInt(),
  kind: json['kind'] == null
      ? null
      : EnumValueModel.fromJson(json['kind'] as Map<String, dynamic>),
  body: json['body'] as String,
  status: EnumValueModel.fromJson(json['status'] as Map<String, dynamic>),
  sentAt: json['sent_at'] as String?,
);

Map<String, dynamic> _$SmsNotificationModelToJson(
  SmsNotificationModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'kind': instance.kind?.toJson(),
  'body': instance.body,
  'status': instance.status.toJson(),
  'sent_at': instance.sentAt,
};
