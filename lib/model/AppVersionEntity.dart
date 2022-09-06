import 'package:json_annotation/json_annotation.dart';

part 'AppVersionEntity.g.dart';

@JsonSerializable()
class AppVersionEntity {
  String? createTime;
  String? updateTime;
  int? versionId;
  var versionNumber;
  String? versionCode;
  String? description;
  String? downloadUrl;
  int? forceUpdate;
  String? clientType;
  int? status;
  String? statusName;

  AppVersionEntity(this.createTime, this.updateTime, this.versionId, this.versionNumber, this.versionCode, this.description,
      this.downloadUrl, this.forceUpdate, this.clientType, this.status, this.statusName);

  factory AppVersionEntity.fromJson(Map<String, dynamic> json) => _$AppVersionEntityFromJson(json);

  Map<String, dynamic> toJson() => _$AppVersionEntityToJson(this);
}