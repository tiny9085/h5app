// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'IndexResp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IndexResp _$IndexRespFromJson(Map<String, dynamic> json) {
  return IndexResp(
    json['sale'] == null
        ? null
        : Sale.fromJson(json['sale'] as Map<String, dynamic>),
    (json['bannerList'] as List<dynamic>)
        .map((e) => BannerItem.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['moduleList'] as List<dynamic>)
        .map((e) => Module.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['orgList'] as List<dynamic>)
        .map((e) => StoreEntity.fromJson(e as Map<String, dynamic>))
        .toList(),
    json['member'] == null
        ? null
        : Member.fromJson(json['member'] as Map<String, dynamic>),
    json['inventory'] == null
        ? null
        : Inventory.fromJson(json['inventory'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$IndexRespToJson(IndexResp instance) => <String, dynamic>{
      'sale': instance.sale,
      'bannerList': instance.bannerList,
      'moduleList': instance.moduleList,
      'orgList': instance.orgList,
      'member': instance.member,
      'inventory': instance.inventory,
    };

Sale _$SaleFromJson(Map<String, dynamic> json) {
  return Sale(
    (json['sales'] as num?)?.toDouble(),
    (json['grossProfit'] as num?)?.toDouble(),
    json['orderQuantity'],
    (json['profitRate'] as num?)?.toDouble(),
    json['guestFlow'],
    (json['guestUnitPrice'] as num?)?.toDouble(),
  );
}

Map<String, dynamic> _$SaleToJson(Sale instance) => <String, dynamic>{
      'sales': instance.sales,
      'grossProfit': instance.grossProfit,
      'orderQuantity': instance.orderQuantity,
      'profitRate': instance.profitRate,
      'guestFlow': instance.guestFlow,
      'guestUnitPrice': instance.guestUnitPrice,
    };

Inventory _$InventoryFromJson(Map<String, dynamic> json) {
  return Inventory(
    json['inventoryAmount'],
    json['inventorys'],
    json['newBreed'],
    json['outBreed'],
    json['expiryBreed'],
  );
}

Map<String, dynamic> _$InventoryToJson(Inventory instance) => <String, dynamic>{
      'inventoryAmount': instance.inventoryAmount,
      'inventorys': instance.inventorys,
      'newBreed': instance.newBreed,
      'outBreed': instance.outBreed,
      'expiryBreed': instance.expiryBreed,
    };

Member _$MemberFromJson(Map<String, dynamic> json) {
  return Member(
    json['members'],
    json['tradeMembers'],
    (json['memberSalePercent'] as num?)?.toDouble(),
    (json['memberGuestPercent'] as num?)?.toDouble(),
  );
}

Map<String, dynamic> _$MemberToJson(Member instance) => <String, dynamic>{
      'members': instance.members,
      'tradeMembers': instance.tradeMembers,
      'memberSalePercent': instance.memberSalePercent,
      'memberGuestPercent': instance.memberGuestPercent,
    };

Module _$ModuleFromJson(Map<String, dynamic> json) {
  return Module(
    json['moduleId'] as int,
    json['moduleName'] as String,
    json['funcImage'] as String,
    json['moduleType'] as int,
  );
}

Map<String, dynamic> _$ModuleToJson(Module instance) => <String, dynamic>{
      'moduleId': instance.moduleId,
      'moduleName': instance.moduleName,
      'funcImage': instance.funcImage,
      'moduleType': instance.moduleType,
    };

BannerItem _$BannerItemFromJson(Map<String, dynamic> json) {
  return BannerItem(
    json['bannerId'] as int,
    json['bannerUrl'] as String,
  );
}

Map<String, dynamic> _$BannerItemToJson(BannerItem instance) =>
    <String, dynamic>{
      'bannerId': instance.bannerId,
      'bannerUrl': instance.bannerUrl,
    };
