import 'package:json_annotation/json_annotation.dart';

part 'CommodityManaResp.g.dart';

@JsonSerializable()
class CommodityManaResp {
  SaleManage? saleManage;
  InventoryManage? inventoryManage;
  ExpiryManage? expiryManage;

  CommodityManaResp(this.saleManage, this.inventoryManage, this.expiryManage);

  factory CommodityManaResp.fromJson(Map<String, dynamic> json) => _$CommodityManaRespFromJson(json);

  Map<String, dynamic> toJson() => _$CommodityManaRespToJson(this);
}

@JsonSerializable()
class SaleManage {
  var allBreeds;
  var newBreed;
  var monthSaleRate;
  var seasonSaleRate;
  var sixtyNoSale;
  var ninetyNoSale;

  SaleManage(this.allBreeds, this.newBreed, this.monthSaleRate, this.seasonSaleRate, this.sixtyNoSale, this.ninetyNoSale);

  factory SaleManage.fromJson(Map<String, dynamic> json) => _$SaleManageFromJson(json);

  Map<String, dynamic> toJson() => _$SaleManageToJson(this);
}

@JsonSerializable()
class InventoryManage {
  var inventoryAmount;
  var turnoverDays;
  var outBreed;
  var outBreedRate;

  InventoryManage(this.inventoryAmount, this.turnoverDays, this.outBreed, this.outBreedRate);

  factory InventoryManage.fromJson(Map<String, dynamic> json) => _$InventoryManageFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryManageToJson(this);
}

@JsonSerializable()
class ExpiryManage {
  var oneMonthExpiry;
  var threeMonthExpiry;
  var sixMonthExpiry;

  ExpiryManage(this.oneMonthExpiry, this.threeMonthExpiry, this.sixMonthExpiry);

  factory ExpiryManage.fromJson(Map<String, dynamic> json) => _$ExpiryManageFromJson(json);

  Map<String, dynamic> toJson() => _$ExpiryManageToJson(this);
}
