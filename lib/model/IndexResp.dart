import 'package:json_annotation/json_annotation.dart';
import 'package:smart_assistant/model/StoreEntity.dart';

part 'IndexResp.g.dart';

@JsonSerializable()
class IndexResp {
  Sale? sale;
  List<BannerItem> bannerList;
  List<Module> moduleList;
  List<StoreEntity> orgList;
  Member? member;
  Inventory? inventory;

  IndexResp(this.sale, this.bannerList, this.moduleList, this.orgList, this.member, this.inventory);

  factory IndexResp.fromJson(Map<String, dynamic> json) => _$IndexRespFromJson(json);

  Map<String, dynamic> toJson() => _$IndexRespToJson(this);
}

@JsonSerializable()
class Sale {
  double? sales; //销售额
  double? grossProfit; //毛利额
  var orderQuantity; //订单数
  double? profitRate; //毛利率
  var guestFlow; //客流量
  double? guestUnitPrice; //客单价

  Sale(this.sales, this.grossProfit, this.orderQuantity, this.profitRate, this.guestFlow, this.guestUnitPrice);

  factory Sale.fromJson(Map<String, dynamic> json) => _$SaleFromJson(json);

  Map<String, dynamic> toJson() => _$SaleToJson(this);
}

@JsonSerializable()
class Inventory {
  var inventoryAmount; //库存成本金额
  var inventorys; //库存数
  var newBreed; //新品品种数
  var outBreed; //断货品种数
  var expiryBreed; //效期品种数

  Inventory(this.inventoryAmount, this.inventorys, this.newBreed, this.outBreed, this.expiryBreed);

  factory Inventory.fromJson(Map<String, dynamic> json) => _$InventoryFromJson(json);

  Map<String, dynamic> toJson() => _$InventoryToJson(this);
}

@JsonSerializable()
class Member {
  var members; //新增会员数
  var tradeMembers; //交易会员数
  double? memberSalePercent; //会员销占比
  double? memberGuestPercent; //会员来客占比

  Member(this.members, this.tradeMembers, this.memberSalePercent, this.memberGuestPercent);

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);

  Map<String, dynamic> toJson() => _$MemberToJson(this);
}

@JsonSerializable()
class Module {
  int moduleId;
  String moduleName;
  String funcImage;
  int moduleType;

  Module(this.moduleId, this.moduleName, this.funcImage, this.moduleType);

  factory Module.fromJson(Map<String, dynamic> json) => _$ModuleFromJson(json);

  Map<String, dynamic> toJson() => _$ModuleToJson(this);
}

@JsonSerializable()
class BannerItem {
  int bannerId;
  String bannerUrl;

  BannerItem(this.bannerId, this.bannerUrl);

  factory BannerItem.fromJson(Map<String, dynamic> json) => _$BannerItemFromJson(json);

  Map<String, dynamic> toJson() => _$BannerItemToJson(this);
}
