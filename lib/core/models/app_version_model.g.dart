// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_version_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppVersionModel _$AppVersionModelFromJson(Map<String, dynamic> json) =>
    AppVersionModel(
      minimumVersion: json['minimum_version'] as String,
      latestVersion: json['latest_version'] as String,
      forceUpdate: json['force_update'] as bool,
      updateUrl: json['update_url'] as String,
      releaseNotes: json['release_notes'] as String?,
    );

Map<String, dynamic> _$AppVersionModelToJson(AppVersionModel instance) =>
    <String, dynamic>{
      'minimum_version': instance.minimumVersion,
      'latest_version': instance.latestVersion,
      'force_update': instance.forceUpdate,
      'update_url': instance.updateUrl,
      'release_notes': instance.releaseNotes,
    };
