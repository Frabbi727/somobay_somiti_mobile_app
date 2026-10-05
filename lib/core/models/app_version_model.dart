import 'package:json_annotation/json_annotation.dart';

part 'app_version_model.g.dart';

@JsonSerializable()
class AppVersionModel {
  @JsonKey(name: 'minimum_version')
  final String minimumVersion;

  @JsonKey(name: 'latest_version')
  final String latestVersion;

  @JsonKey(name: 'force_update')
  final bool forceUpdate;

  @JsonKey(name: 'update_url')
  final String updateUrl;

  @JsonKey(name: 'release_notes')
  final String? releaseNotes;

  const AppVersionModel({
    required this.minimumVersion,
    required this.latestVersion,
    required this.forceUpdate,
    required this.updateUrl,
    this.releaseNotes,
  });

  factory AppVersionModel.fromJson(Map<String, dynamic> json) =>
      _$AppVersionModelFromJson(json);

  Map<String, dynamic> toJson() => _$AppVersionModelToJson(this);
}
