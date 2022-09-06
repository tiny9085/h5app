import 'package:json_annotation/json_annotation.dart';

part 'SalesReportResp.g.dart';

@JsonSerializable()
class SalesReportResp {
  Sale? sale;
  List<OrganSaleSort>? organSaleSort;
  List<CategorySort>? categorySort;
  List<ProductSort>? productSort;

  SalesReportResp(this.sale,this.organSaleSort,this.categorySort,this.productSort);

  factory SalesReportResp.fromJson(Map<String, dynamic> json) =>
      _$SalesReportRespFromJson(json);

  Map<String, dynamic> toJson() => _$SalesReportRespToJson(this);
}

@JsonSerializable()
class Sale {
  var sales; //销售额
  var lastWeekSales; //上周同期
  var grossProfit; //毛利额
  var lastWeekGrossProfit; //上周同期毛利
  var lastWeekOrder;
  var orderQuantity; //订单数
  var guestFlow; //客流量
  var guestUnitPrice;
  var momSales;
  var momGrossProfit;
  var momOrderQuantity;
  var momGuestFlow;
  var momGuestUnitPrice;

  Sale(
      this.sales,
      this.lastWeekSales,
      this.grossProfit,
      this.lastWeekGrossProfit,
      this.lastWeekOrder,
      this.orderQuantity,
      this.guestFlow,
      this.guestUnitPrice,
      this.momSales,
      this.momGrossProfit,
      this.momOrderQuantity,
      this.momGuestFlow,
      this.momGuestUnitPrice);

  factory Sale.fromJson(Map<String, dynamic> json) => _$SaleFromJson(json);

  Map<String, dynamic> toJson() => _$SaleToJson(this);
}

@JsonSerializable()
class OrganSaleSort {
  var organId;
  var organName;
  var sales;
  var grossProfit;
  var guestFlow;

  OrganSaleSort(this.organId, this.organName, this.sales, this.grossProfit,
      this.guestFlow);

  factory OrganSaleSort.fromJson(Map<String, dynamic> json) => _$OrganSaleSortFromJson(json);

  Map<String, dynamic> toJson() => _$OrganSaleSortToJson(this);
}

@JsonSerializable()
class CategorySort {
  var organId;
  var categoryName;
  double? sales;
  double? salesTotal;

  CategorySort(
      this.organId,
      this.categoryName,
      this.sales,
      this.salesTotal);

  factory CategorySort.fromJson(Map<String, dynamic> json) => _$CategorySortFromJson(json);

  Map<String, dynamic> toJson() => _$CategorySortToJson(this);
}

@JsonSerializable()
class ProductSort {
  var goodsName;
  var organName;
  var productId;
  var productName;
  var sales;
  var salesTotal;
  var inventorys;

  ProductSort(this.goodsName, this.organName, this.productId, this.productName, this.sales, this.salesTotal, this.inventorys);

  factory ProductSort.fromJson(Map<String, dynamic> json) => _$ProductSortFromJson(json);

  Map<String, dynamic> toJson() => _$ProductSortToJson(this);
}
