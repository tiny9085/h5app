import 'package:json_annotation/json_annotation.dart';

part 'StoreEntity.g.dart';

@JsonSerializable()
class StoreEntity {
  String organCode;
  String organName;
  String organShort;
  String organTel;

  StoreEntity(this.organCode, this.organName, this.organShort, this.organTel);

  factory StoreEntity.fromJson(Map<String, dynamic> json) => _$StoreEntityFromJson(json);

  Map<String, dynamic> toJson() => _$StoreEntityToJson(this);
}
