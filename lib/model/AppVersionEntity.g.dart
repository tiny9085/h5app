// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AppVersionEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppVersionEntity _$AppVersionEntityFromJson(Map<String, dynamic> json) {
  return AppVersionEntity(
    json['createTime'] as String?,
    json['updateTime'] as String?,
    json['versionId'] as int?,
    json['versionNumber'],
    json['versionCode'] as String?,
    json['description'] as String?,
    json['downloadUrl'] as String?,
    json['forceUpdate'] as int?,
    json['clientType'] as String?,
    json['status'] as int?,
    json['statusName'] as String?,
  );
}

Map<String, dynamic> _$AppVersionEntityToJson(AppVersionEntity instance) =>
    <String, dynamic>{
      'createTime': instance.createTime,
      'updateTime': instance.updateTime,
      'versionId': instance.versionId,
      'versionNumber': instance.versionNumber,
      'versionCode': instance.versionCode,
      'description': instance.description,
      'downloadUrl': instance.downloadUrl,
      'forceUpdate': instance.forceUpdate,
      'clientType': instance.clientType,
      'status': instance.status,
      'statusName': instance.statusName,
    };
