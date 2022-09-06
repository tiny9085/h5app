// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'User.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User(
    json['userInfo'] == null
        ? null
        : UserInfo.fromJson(json['userInfo'] as Map<String, dynamic>),
    json['tokenInfo'] == null
        ? null
        : TokenInfo.fromJson(json['tokenInfo'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'userInfo': instance.userInfo,
      'tokenInfo': instance.tokenInfo,
    };

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) {
  return UserInfo(
    json['id'] as int?,
    json['avatar'] as String?,
    json['username'] as String?,
  );
}

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'id': instance.id,
      'avatar': instance.avatar,
      'username': instance.username,
    };

TokenInfo _$TokenInfoFromJson(Map<String, dynamic> json) {
  return TokenInfo(
    json['access_token'] as String?,
    json['token_type'] as String?,
    json['refresh_token'] as String?,
  );
}

Map<String, dynamic> _$TokenInfoToJson(TokenInfo instance) => <String, dynamic>{
      'access_token': instance.accessToken,
      'token_type': instance.tokenType,
      'refresh_token': instance.refreshToken,
    };
