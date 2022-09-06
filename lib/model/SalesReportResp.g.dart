// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SalesReportResp.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SalesReportResp _$SalesReportRespFromJson(Map<String, dynamic> json) {
  return SalesReportResp(
    json['sale'] == null
        ? null
        : Sale.fromJson(json['sale'] as Map<String, dynamic>),
    (json['organSaleSort'] as List<dynamic>?)
        ?.map((e) => OrganSaleSort.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['categorySort'] as List<dynamic>?)
        ?.map((e) => CategorySort.fromJson(e as Map<String, dynamic>))
        .toList(),
    (json['productSort'] as List<dynamic>?)
        ?.map((e) => ProductSort.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$SalesReportRespToJson(SalesReportResp instance) =>
    <String, dynamic>{
      'sale': instance.sale,
      'organSaleSort': instance.organSaleSort,
      'categorySort': instance.categorySort,
      'productSort': instance.productSort,
    };

Sale _$SaleFromJson(Map<String, dynamic> json) {
  return Sale(
    json['sales'],
    json['lastWeekSales'],
    json['grossProfit'],
    json['lastWeekGrossProfit'],
    json['lastWeekOrder'],
    json['orderQuantity'],
    json['guestFlow'],
    json['guestUnitPrice'],
    json['momSales'],
    json['momGrossProfit'],
    json['momOrderQuantity'],
    json['momGuestFlow'],
    json['momGuestUnitPrice'],
  );
}

Map<String, dynamic> _$SaleToJson(Sale instance) => <String, dynamic>{
      'sales': instance.sales,
      'lastWeekSales': instance.lastWeekSales,
      'grossProfit': instance.grossProfit,
      'lastWeekGrossProfit': instance.lastWeekGrossProfit,
      'lastWeekOrder': instance.lastWeekOrder,
      'orderQuantity': instance.orderQuantity,
      'guestFlow': instance.guestFlow,
      'guestUnitPrice': instance.guestUnitPrice,
      'momSales': instance.momSales,
      'momGrossProfit': instance.momGrossProfit,
      'momOrderQuantity': instance.momOrderQuantity,
      'momGuestFlow': instance.momGuestFlow,
      'momGuestUnitPrice': instance.momGuestUnitPrice,
    };

OrganSaleSort _$OrganSaleSortFromJson(Map<String, dynamic> json) {
  return OrganSaleSort(
    json['organId'],
    json['organName'],
    json['sales'],
    json['grossProfit'],
    json['guestFlow'],
  );
}

Map<String, dynamic> _$OrganSaleSortToJson(OrganSaleSort instance) =>
    <String, dynamic>{
      'organId': instance.organId,
      'organName': instance.organName,
      'sales': instance.sales,
      'grossProfit': instance.grossProfit,
      'guestFlow': instance.guestFlow,
    };

CategorySort _$CategorySortFromJson(Map<String, dynamic> json) {
  return CategorySort(
    json['organId'],
    json['categoryName'],
    (json['sales'] as num?)?.toDouble(),
    (json['salesTotal'] as num?)?.toDouble(),
  );
}

Map<String, dynamic> _$CategorySortToJson(CategorySort instance) =>
    <String, dynamic>{
      'organId': instance.organId,
      'categoryName': instance.categoryName,
      'sales': instance.sales,
      'salesTotal': instance.salesTotal,
    };

ProductSort _$ProductSortFromJson(Map<String, dynamic> json) {
  return ProductSort(
    json['goodsName'],
    json['organName'],
    json['productId'],
    json['productName'],
    json['sales'],
    json['salesTotal'],
    json['inventorys'],
  );
}

Map<String, dynamic> _$ProductSortToJson(ProductSort instance) =>
    <String, dynamic>{
      'goodsName': instance.goodsName,
      'organName': instance.organName,
      'productId': instance.productId,
      'productName': instance.productName,
      'sales': instance.sales,
      'salesTotal': instance.salesTotal,
      'inventorys': instance.inventorys,
    };
