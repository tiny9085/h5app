import 'package:json_annotation/json_annotation.dart';

part 'User.g.dart';

@JsonSerializable()
class User {

  UserInfo? userInfo;
  TokenInfo? tokenInfo;

  User(this.userInfo, this.tokenInfo);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  // 命名构造函数
  User.empty();
}

@JsonSerializable()
class UserInfo {
  int? id;
  String? avatar;
  String? username;

  UserInfo(this.id, this.avatar, this.username);

  factory UserInfo.fromJson(Map<String, dynamic> json) => _$UserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}

@JsonSerializable()
class TokenInfo {
  @JsonKey(name: 'access_token')
  String? accessToken;
  @JsonKey(name: 'token_type')
  String? tokenType;
  @JsonKey(name: 'refresh_token')
  String? refreshToken;

  TokenInfo(this.accessToken, this.tokenType, this.refreshToken);

  factory TokenInfo.fromJson(Map<String, dynamic> json) => _$TokenInfoFromJson(json);

  Map<String, dynamic> toJson() => _$TokenInfoToJson(this);
}

// @JsonSerializable()
// class User {
//   @JsonKey(name: 'access_token')
//   String? accessToken;
//   @JsonKey(name: 'token_type')
//   String? tokenType;
//   @JsonKey(name: 'user_details')
//   UserDetail? userDetail;
//
//   User(this.accessToken, this.tokenType, this.userDetail);
//
//   factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
//
//   Map<String, dynamic> toJson() => _$UserToJson(this);
//
//   // 命名构造函数
//   User.empty();
// }
//
// @JsonSerializable()
// class UserDetail {
//   String? userId;
//   String? username;
//   String? phone;
//   String? shopId;
//   int? status;
//   String? tenantId;
//   String? tenant;
//   String? dataScope;
//   String? ctrType;
//   String? additionalInformation;
//
//   UserDetail(this.userId, this.username, this.phone, this.shopId, this.status, this.tenantId, this.tenant, this.dataScope, this.ctrType,
//       this.additionalInformation);
//
//   factory UserDetail.fromJson(Map<String, dynamic> json) => _$UserDetailFromJson(json);
//
//   Map<String, dynamic> toJson() => _$UserDetailToJson(this);
// }
