// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MemberResp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MemberResp _$MemberRespFromJson(Map<String, dynamic> json) {
  return MemberResp(
    json['member'] == null
        ? null
        : DataItem.fromJson(json['member'] as Map<String, dynamic>),
    json['newMember'] == null
        ? null
        : ChartData.fromJson(json['newMember'] as Map<String, dynamic>),
    json['memberOrder'] == null
        ? null
        : ChartData.fromJson(json['memberOrder'] as Map<String, dynamic>),
    json['memberSales'] == null
        ? null
        : ChartData.fromJson(json['memberSales'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$MemberRespToJson(MemberResp instance) =>
    <String, dynamic>{
      'member': instance.member,
      'newMember': instance.newMember,
      'memberOrder': instance.memberOrder,
      'memberSales': instance.memberSales,
    };

ChartData _$ChartDataFromJson(Map<String, dynamic> json) {
  return ChartData(
    (json['max'] as num?)?.toDouble(),
    (json['sum'] as List<dynamic>?)?.map((e) => (e as num).toDouble()).toList(),
    (json['list'] as List<dynamic>?)
        ?.map((e) => (e as num).toDouble())
        .toList(),
    (json['avg'] as List<dynamic>?)?.map((e) => e as String).toList(),
  );
}

Map<String, dynamic> _$ChartDataToJson(ChartData instance) => <String, dynamic>{
      'max': instance.max,
      'sum': instance.sum,
      'list': instance.list,
      'avg': instance.avg,
    };

DataItem _$DataItemFromJson(Map<String, dynamic> json) {
  return DataItem(
    json['organId'],
    json['effectDate'],
    json['totalMember'],
    json['validMember'],
    json['memberSales'],
    json['memberOrders'],
    json['memberSalePercent'],
    json['memberGuestPercent'],
  );
}

Map<String, dynamic> _$DataItemToJson(DataItem instance) => <String, dynamic>{
      'organId': instance.organId,
      'effectDate': instance.effectDate,
      'totalMember': instance.totalMember,
      'validMember': instance.validMember,
      'memberSales': instance.memberSales,
      'memberOrders': instance.memberOrders,
      'memberSalePercent': instance.memberSalePercent,
      'memberGuestPercent': instance.memberGuestPercent,
    };
