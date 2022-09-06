import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:smart_assistant/common/dao/repository_dao.dart';
import 'package:smart_assistant/common/net/address.dart';
import 'package:smart_assistant/common/style/hcyy_style.dart';
import 'package:smart_assistant/common/utils/common_utils.dart';
import 'package:smart_assistant/common/utils/navigator_utils.dart';
import 'package:smart_assistant/model/SalesReportResp.dart';
import 'package:smart_assistant/model/StoreEntity.dart';
import 'package:smart_assistant/redux/gsy_state.dart';
import 'package:smart_assistant/widget/item/category_rank_item.dart';
import 'package:smart_assistant/widget/item/product_rank_item.dart';
import 'package:smart_assistant/widget/item/store_rank_item.dart';
import 'package:smart_assistant/widget/sliver_app_bar_delegate.dart';
import 'package:redux/redux.dart';

class SellChartPage extends StatefulWidget {
  static final String sName = "sellChart";

  //生命周期函数
  @override
  SellChartPageState createState() => SellChartPageState();
}

class SellChartPageState extends State<SellChartPage> with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  StoreEntity? selectStore;
  List<StoreEntity> _storeList = [];
  SalesReportResp? _salesReportResp;
  int selectTabIndex = 0;
  EasyRefreshController _easyRefreshController = EasyRefreshController();
  bool _isHasPermission = true;

  // TabController? _tabController;
  PageController? controller;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    controller = PageController(initialPage: selectTabIndex);
    Future.delayed(const Duration(milliseconds: 500), () {
      _easyRefreshController.callRefresh();
    });
  }

  void doFetchSalesReport() {
    RepositoryDao.fetchSalesReport(organId: selectStore?.organCode).then((res) {
      if (res != null && res.result && res.data != null) {
        setState(() {
          _isHasPermission = true;
          _salesReportResp = res.data;
        });
        _easyRefreshController.finishRefresh();
      } else {
        setState(() {
          _isHasPermission = false;
        });
      }
    });
  }

  void initStoreList(Store<GSYState> store) {
    if (store.state.storeList != null) {
      _storeList.clear();
      _storeList.addAll(store.state.storeList!);
      if (_storeList.isNotEmpty && selectStore == null) {
        selectStore = _storeList[0];
      }
    }
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return StoreBuilder<GSYState>(onInit: (store) {
      if (store.state.storeList != null) {
        _storeList.clear();
        _storeList.addAll(store.state.storeList!);
        if (_storeList.isNotEmpty) {
          selectStore = _storeList[0];
        }
      }
    }, builder: (context, store) {
      return Scaffold(
        body: Container(
          color: Color(0xffF4F4F4),
          height: double.infinity,
          child: EasyRefresh.builder(
            controller: _easyRefreshController,
            footer: MaterialFooter(),
            header: ClassicalHeader(
                showInfo: false,
                textColor: Colors.white,
                refreshedText: '刷新完成',
                refreshFailedText: '刷新失败',
                refreshingText: '正在刷新数据中... ',
                refreshText: '下拉可以刷新',
                refreshReadyText: '松开立即刷新',
                bgColor: Color(0xff7D97FF)),
            onRefresh: () async {
              initStoreList(store);
              doFetchSalesReport();
            },
            builder: (context, physics, header, footer) {
              return !_isHasPermission?Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/bg_no_permission.png', fit: BoxFit.fill, width: 240, height: 178,),
                          Container(
                            margin: EdgeInsets.only(top: 14),
                            child: Text('你没有相关权限', style: TextStyle(color: Color(0xFF333333), fontSize: 18, fontWeight: FontWeight.normal),),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ):CustomScrollView(
                physics: physics,
                slivers: <Widget>[
                  SliverPersistentHeader(
                      pinned: true, //是否固定在顶部
                      delegate: SliverAppBarDelegate(
                        minHeight: 90,
                        maxHeight: 90,
                        child: Container(
                          height: 90,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage('assets/images/bg_home_up.png'),
                            fit: BoxFit.fill,
                          )),
                          child: Container(
                            padding: EdgeInsets.only(top: 40.0, left: 16.0, right: 16.0),
                            child: Row(
                              children: [
                                Expanded(
                                    child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    CommonUtils.showStoreListDialog(context, _storeList, (value) {
                                      setState(() {
                                        selectStore = value;
                                      });
                                      _easyRefreshController.callRefresh();
                                    }, selectOrgCode: selectStore?.organCode);
                                  },
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/ic_shop.png',
                                        width: 24.0,
                                        height: 24.0,
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(left: 10.0),
                                          child: Text(
                                            selectStore?.organShort ?? '所有门店',
                                            style: TextStyle(fontSize: HCYYConstant.normalTextSize, color: Colors.white),
                                          )),
                                      Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Image.asset(
                                          'assets/images/ic_arrow_down.png',
                                          width: 12.0,
                                          height: 6.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                                Text(
                                  CommonUtils.fetchCurrentDate(),
                                  style: TextStyle(fontSize: HCYYConstant.smallTextSize, color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ),
                      )),
                  header!,
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        Container(
                            child: Stack(
                          children: [
                            Image.asset(
                              'assets/images/bg_home_down.png',
                              width: double.infinity,
                              fit: BoxFit.fill,
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Image.asset('assets/images/ic_switch.png', width: 18.0, height: 18.0),
                                      Padding(
                                        child: Text('销售情况', style: HCYYConstant.labelText),
                                        padding: EdgeInsets.only(left: 8.0),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 16.0),
                                    child: Container(
                                      height: 94.0,
                                      child: Flex(direction: Axis.horizontal, children: [
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '销售金额(元)',
                                                style: TextStyle(color: Color(0xFFBBBBBB), fontSize: 12.0),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(top: 4.0),
                                                child: Text(
                                                  _salesReportResp?.sale?.sales?.toString() ?? '-',
                                                  style: TextStyle(color: Color(0xff666666), fontSize: 18.0),
                                                ),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.only(top: 10.0),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        '环比',
                                                        style: TextStyle(color: Color(0xFFBBBBBB), fontSize: 12.0),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.only(left: 6.0),
                                                        child: Text(
                                                          CommonUtils.formatPercentValue(_salesReportResp?.sale?.momSales, selectStore?.organCode == '0' ? (_storeList.length - 1) : 1),
                                                          style: TextStyle(color: Color((_salesReportResp?.sale?.momSales ?? 1) > 0 ? 0xFFFF9901 : 0xFF62C017), fontSize: 12.0),
                                                        ),
                                                      )
                                                    ],
                                                  ))
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          child: VerticalDivider(width: 2.0, color: Color(0xFFEEEEEE)),
                                          padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 16.0),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '上周同期(元)',
                                                style: TextStyle(color: Color(0xFFBBBBBB), fontSize: 12.0),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(top: 4.0),
                                                child: Text(
                                                  _salesReportResp?.sale?.lastWeekSales?.toString() ?? '-',
                                                  style: TextStyle(color: Color(0xff666666), fontSize: 18.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]),
                                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
                                      decoration: BoxDecoration(color: Color(0xFFF9F9F9), borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 16.0),
                                    child: Container(
                                      height: 94.0,
                                      child: Flex(direction: Axis.horizontal, children: [
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '毛利额(元)',
                                                style: TextStyle(color: Color(0xFFBBBBBB), fontSize: 12.0),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(top: 4.0),
                                                child: Text(
                                                  _salesReportResp?.sale?.grossProfit?.toString() ?? '-',
                                                  style: TextStyle(color: Color(0xff666666), fontSize: 18.0),
                                                ),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.only(top: 10.0),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        '环比',
                                                        style: TextStyle(color: Color(0xFFBBBBBB), fontSize: 12.0),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.only(left: 6.0),
                                                        child: Text(
                                                          CommonUtils.formatPercentValue(_salesReportResp?.sale?.momGrossProfit, selectStore?.organCode == '0' ? (_storeList.length - 1) : 1),
                                                          style: TextStyle(color: Color((_salesReportResp?.sale?.momGrossProfit ?? 1) > 0 ? 0xFFFF9901 : 0xFF62C017), fontSize: 12.0),
                                                        ),
                                                      )
                                                    ],
                                                  ))
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          child: VerticalDivider(width: 2.0, color: Color(0xFFEEEEEE)),
                                          padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 16.0),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '上周同期(元)',
                                                style: TextStyle(color: Color(0xFFBBBBBB), fontSize: 12.0),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(top: 4.0),
                                                child: Text(
                                                  _salesReportResp?.sale?.lastWeekGrossProfit?.toString() ?? '-',
                                                  style: TextStyle(color: Color(0xff666666), fontSize: 18.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]),
                                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
                                      decoration: BoxDecoration(color: Color(0xFFF9F9F9), borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 16.0),
                                    child: Container(
                                      height: 94.0,
                                      child: Flex(direction: Axis.horizontal, children: [
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '订单数(单)',
                                                style: TextStyle(color: Color(0xFFBBBBBB), fontSize: 12.0),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(top: 4.0),
                                                child: Text(
                                                  _salesReportResp?.sale?.orderQuantity?.toString() ?? '-',
                                                  style: TextStyle(color: Color(0xff666666), fontSize: 18.0),
                                                ),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.only(top: 10.0),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        '环比',
                                                        style: TextStyle(color: Color(0xFFBBBBBB), fontSize: 12.0),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.only(left: 6.0),
                                                        child: Text(
                                                          CommonUtils.formatPercentValue(_salesReportResp?.sale?.momOrderQuantity, selectStore?.organCode == '0' ? (_storeList.length - 1) : 1),
                                                          style: TextStyle(color: Color((_salesReportResp?.sale?.momOrderQuantity ?? 1) > 0 ? 0xFFFF9901 : 0xFF62C017), fontSize: 12.0),
                                                        ),
                                                      )
                                                    ],
                                                  ))
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          child: VerticalDivider(width: 2.0, color: Color(0xFFEEEEEE)),
                                          padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 16.0),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '上周同期(单)',
                                                style: TextStyle(color: Color(0xFFBBBBBB), fontSize: 12.0),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(top: 4.0),
                                                child: Text(
                                                  _salesReportResp?.sale?.lastWeekOrder?.toString() ?? '-',
                                                  style: TextStyle(color: Color(0xff666666), fontSize: 18.0),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]),
                                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
                                      decoration: BoxDecoration(color: Color(0xFFF9F9F9), borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 16.0),
                                    child: Container(
                                      height: 94.0,
                                      child: Flex(direction: Axis.horizontal, children: [
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '客流量(个)',
                                                style: TextStyle(color: Color(0xFFBBBBBB), fontSize: 12.0),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(top: 4.0),
                                                child: Text(
                                                  _salesReportResp?.sale?.guestFlow?.toString() ?? '-',
                                                  style: TextStyle(color: Color(0xff666666), fontSize: 18.0),
                                                ),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.only(top: 10.0),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        '环比',
                                                        style: TextStyle(color: Color(0xFFBBBBBB), fontSize: 12.0),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.only(left: 6.0),
                                                        child: Text(
                                                          CommonUtils.formatPercentValue(_salesReportResp?.sale?.momGuestFlow, selectStore?.organCode == '0' ? (_storeList.length - 1) : 1),
                                                          style: TextStyle(color: Color((_salesReportResp?.sale?.momGuestFlow ?? 1) > 0 ? 0xFFFF9901 : 0xFF62C017), fontSize: 12.0),
                                                        ),
                                                      )
                                                    ],
                                                  ))
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          child: VerticalDivider(width: 2.0, color: Color(0xFFEEEEEE)),
                                          padding: EdgeInsets.only(top: 10.0, bottom: 10.0, right: 16.0),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '客单价(元)',
                                                style: TextStyle(color: Color(0xFFBBBBBB), fontSize: 12.0),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(top: 4.0),
                                                child: Text(
                                                  _salesReportResp?.sale?.guestUnitPrice?.toString() ?? '-',
                                                  style: TextStyle(color: Color(0xff666666), fontSize: 18.0),
                                                ),
                                              ),
                                              Padding(
                                                  padding: EdgeInsets.only(top: 10.0),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        '环比',
                                                        style: TextStyle(color: Color(0xFFBBBBBB), fontSize: 12.0),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.only(left: 6.0),
                                                        child: Text(
                                                          CommonUtils.formatPercentValue(_salesReportResp?.sale?.momGuestUnitPrice, selectStore?.organCode == '0' ? (_storeList.length - 1) : 1),
                                                          style: TextStyle(color: Color((_salesReportResp?.sale?.momGuestUnitPrice ?? 1) > 0 ? 0xFFFF9901 : 0xFF62C017), fontSize: 12.0),
                                                        ),
                                                      )
                                                    ],
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ]),
                                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
                                      decoration: BoxDecoration(color: Color(0xFFF9F9F9), borderRadius: BorderRadius.all(Radius.circular(20.0))),
                                    ),
                                  )
                                ],
                              ),
                              margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                              padding: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20.0))),
                            )
                          ],
                        )),
                        Container(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Image.asset('assets/images/ic_sales_rank.png', width: 18.0, height: 18.0),
                                  Padding(
                                    child: Text('销售排行', style: HCYYConstant.labelText),
                                    padding: EdgeInsets.only(left: 8.0),
                                  )
                                ],
                              ),
                              Container(
                                  child: Flex(
                                    direction: Axis.horizontal,
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text(
                                              '门店榜',
                                              style: TextStyle(color: selectTabIndex == 0 ? Colors.white : Color(0xFF6BBCFF), fontSize: 14.0),
                                            ),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(5.0), bottomLeft: Radius.circular(5.0)),
                                              gradient: selectTabIndex == 0
                                                  ? LinearGradient(
                                                      begin: Alignment.centerLeft,
                                                      end: Alignment.centerRight,
                                                      colors: [
                                                        Color(0xff9566FF),
                                                        Color(0xff68C0FF),
                                                      ],
                                                    )
                                                  : null,
                                            ),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              selectTabIndex = 0;
                                            });
                                          },
                                        ),
                                        flex: 1,
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          child: Container(
                                            child: Text('品类榜', style: TextStyle(color: selectTabIndex == 1 ? Colors.white : Color(0xFF6BBCFF), fontSize: 14.0)),
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                gradient: selectTabIndex == 1
                                                    ? LinearGradient(
                                                        begin: Alignment.centerLeft,
                                                        end: Alignment.centerRight,
                                                        colors: [
                                                          Color(0xff9566FF),
                                                          Color(0xff68C0FF),
                                                        ],
                                                      )
                                                    : null,
                                                border: Border(
                                                  left: BorderSide(color: Color(0xFF6BBCFF), width: 1, style: BorderStyle.solid),
                                                  right: BorderSide(color: Color(0xFF6BBCFF), width: 1, style: BorderStyle.solid),
                                                )),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              selectTabIndex = 1;
                                            });
                                          },
                                        ),
                                        flex: 1,
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          child: Container(
                                            alignment: Alignment.center,
                                            child: Text('品种榜', style: TextStyle(color: selectTabIndex == 2 ? Colors.white : Color(0xFF6BBCFF), fontSize: 14.0)),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(topRight: Radius.circular(5.0), bottomRight: Radius.circular(5.0)),
                                              gradient: selectTabIndex == 2
                                                  ? LinearGradient(
                                                      begin: Alignment.centerLeft,
                                                      end: Alignment.centerRight,
                                                      colors: [
                                                        Color(0xff9566FF),
                                                        Color(0xff68C0FF),
                                                      ],
                                                    )
                                                  : null,
                                            ),
                                          ),
                                          onTap: () {
                                            setState(() {
                                              selectTabIndex = 2;
                                            });
                                          },
                                        ),
                                        flex: 1,
                                      )
                                    ],
                                  ),
                                  margin: EdgeInsets.only(top: 16.0),
                                  height: 32.0,
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 1, color: Color(0xFF6BBCFF)),
                                    borderRadius: BorderRadius.all(Radius.circular(6.0)),
                                  )),
                              ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.only(top: 0),
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: getItemCount(),
                                  itemBuilder: (context, index) {
                                    switch (selectTabIndex) {
                                      case 0:
                                        return StoreRankItem(_salesReportResp?.organSaleSort?[index], index);
                                      case 1:
                                        return CategoryRankItem(_salesReportResp?.categorySort?[index], index);
                                      case 2:
                                        return ProductRankItem(_salesReportResp?.productSort?[index], index);
                                      default:
                                        return Container();
                                    }
                                  }),
                              Offstage(
                                offstage: selectTabIndex == 1,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  onTap: () {
                                    if (selectTabIndex == 0)
                                      NavigatorUtils.goWebView(context, Address.organSaleDetails());
                                    else
                                      NavigatorUtils.goWebView(context, Address.productRank());
                                  },
                                  child: Container(
                                    // alignment: Alignment.center,
                                    padding: EdgeInsets.only(top: 15.0, bottom: 5.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '更多',
                                          style: TextStyle(fontSize: 14.0, color: Color(0xFF888888)),
                                        ),
                                        Image.asset('assets/images/ic_arrow_down_grey.png', width: 14, height: 7),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
                          margin: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20.0))),
                        )
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),
      );
    });
  }

  int getItemCount() {
    switch (selectTabIndex) {
      case 0:
        return _salesReportResp?.organSaleSort?.length ?? 0;
      case 1:
        return _salesReportResp?.categorySort?.length ?? 0;
      case 2:
        return _salesReportResp?.productSort?.length ?? 0;
      default:
        return 0;
    }
  }
}
