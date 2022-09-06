// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'StoreEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreEntity _$StoreEntityFromJson(Map<String, dynamic> json) {
  return StoreEntity(
    json['organCode'] as String,
    json['organName'] as String,
    json['organShort'] as String,
    json['organTel'] as String,
  );
}

Map<String, dynamic> _$StoreEntityToJson(StoreEntity instance) =>
    <String, dynamic>{
      'organCode': instance.organCode,
      'organName': instance.organName,
      'organShort': instance.organShort,
      'organTel': instance.organTel,
    };
