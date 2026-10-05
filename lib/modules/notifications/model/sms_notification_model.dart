import 'package:json_annotation/json_annotation.dart';
import '../../../core/models/enum_value_model.dart';

part 'sms_notification_model.g.dart';

/// An SMS the society sent the member (login codes are never included).
@JsonSerializable(explicitToJson: true)
class SmsNotificationModel {
  final int id;
  final EnumValueModel? kind;
  final String body;
  final EnumValueModel status;

  @JsonKey(name: 'sent_at')
  final String? sentAt;

  const SmsNotificationModel({required this.id, this.kind, required this.body, required this.status, this.sentAt});

  factory SmsNotificationModel.fromJson(Map<String, dynamic> json) => _$SmsNotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$SmsNotificationModelToJson(this);
}
