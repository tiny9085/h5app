// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CommodityManaResp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommodityManaResp _$CommodityManaRespFromJson(Map<String, dynamic> json) {
  return CommodityManaResp(
    json['saleManage'] == null
        ? null
        : SaleManage.fromJson(json['saleManage'] as Map<String, dynamic>),
    json['inventoryManage'] == null
        ? null
        : InventoryManage.fromJson(
            json['inventoryManage'] as Map<String, dynamic>),
    json['expiryManage'] == null
        ? null
        : ExpiryManage.fromJson(json['expiryManage'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$CommodityManaRespToJson(CommodityManaResp instance) =>
    <String, dynamic>{
      'saleManage': instance.saleManage,
      'inventoryManage': instance.inventoryManage,
      'expiryManage': instance.expiryManage,
    };

SaleManage _$SaleManageFromJson(Map<String, dynamic> json) {
  return SaleManage(
    json['allBreeds'],
    json['newBreed'],
    json['monthSaleRate'],
    json['seasonSaleRate'],
    json['sixtyNoSale'],
    json['ninetyNoSale'],
  );
}

Map<String, dynamic> _$SaleManageToJson(SaleManage instance) =>
    <String, dynamic>{
      'allBreeds': instance.allBreeds,
      'newBreed': instance.newBreed,
      'monthSaleRate': instance.monthSaleRate,
      'seasonSaleRate': instance.seasonSaleRate,
      'sixtyNoSale': instance.sixtyNoSale,
      'ninetyNoSale': instance.ninetyNoSale,
    };

InventoryManage _$InventoryManageFromJson(Map<String, dynamic> json) {
  return InventoryManage(
    json['inventoryAmount'],
    json['turnoverDays'],
    json['outBreed'],
    json['outBreedRate'],
  );
}

Map<String, dynamic> _$InventoryManageToJson(InventoryManage instance) =>
    <String, dynamic>{
      'inventoryAmount': instance.inventoryAmount,
      'turnoverDays': instance.turnoverDays,
      'outBreed': instance.outBreed,
      'outBreedRate': instance.outBreedRate,
    };

ExpiryManage _$ExpiryManageFromJson(Map<String, dynamic> json) {
  return ExpiryManage(
    json['oneMonthExpiry'],
    json['threeMonthExpiry'],
    json['sixMonthExpiry'],
  );
}

Map<String, dynamic> _$ExpiryManageToJson(ExpiryManage instance) =>
    <String, dynamic>{
      'oneMonthExpiry': instance.oneMonthExpiry,
      'threeMonthExpiry': instance.threeMonthExpiry,
      'sixMonthExpiry': instance.sixMonthExpiry,
    };
