import 'package:json_annotation/json_annotation.dart';

part 'MemberResp.g.dart';

@JsonSerializable()
class MemberResp {
  DataItem? member;
  ChartData? newMember;
  ChartData? memberOrder;
  ChartData? memberSales;

  MemberResp(this.member, this.newMember, this.memberOrder, this.memberSales);

  factory MemberResp.fromJson(Map<String, dynamic> json) => _$MemberRespFromJson(json);

  Map<String, dynamic> toJson() => _$MemberRespToJson(this);
}

@JsonSerializable()
class ChartData {
  double? max;
  List<double>? sum;
  List<double>? list;
  List<String>? avg;

  ChartData(this.max, this.sum, this.list,this.avg);

  factory ChartData.fromJson(Map<String, dynamic> json) => _$ChartDataFromJson(json);

  Map<String, dynamic> toJson() => _$ChartDataToJson(this);
}

@JsonSerializable()
class DataItem {
  var organId;
  var effectDate;
  var totalMember;
  var validMember;
  var memberSales;
  var memberOrders;
  var memberSalePercent;
  var memberGuestPercent;

  DataItem(this.organId, this.effectDate, this.totalMember, this.validMember, this.memberSales, this.memberOrders, this.memberSalePercent, this.memberGuestPercent);

  factory DataItem.fromJson(Map<String, dynamic> json) => _$DataItemFromJson(json);

  Map<String, dynamic> toJson() => _$DataItemToJson(this);
}