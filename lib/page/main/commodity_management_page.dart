import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:smart_assistant/common/dao/repository_dao.dart';
import 'package:smart_assistant/common/net/address.dart';
import 'package:smart_assistant/common/style/hcyy_style.dart';
import 'package:smart_assistant/common/utils/common_utils.dart';
import 'package:smart_assistant/common/utils/navigator_utils.dart';
import 'package:smart_assistant/model/CommodityManaResp.dart';
import 'package:smart_assistant/model/StoreEntity.dart';
import 'package:smart_assistant/redux/gsy_state.dart';
import 'package:smart_assistant/widget/sliver_app_bar_delegate.dart';
import 'package:redux/redux.dart';

class CommodityManagementPage extends StatefulWidget {
  static final String sName = "commodityManagement";

  //生命周期函数
  @override
  _CommodityManagementPageState createState() => _CommodityManagementPageState();
}

class _CommodityManagementPageState extends State<CommodityManagementPage> with AutomaticKeepAliveClientMixin {
  StoreEntity? selectStore;
  List<StoreEntity> _storeList = [];
  CommodityManaResp? _commodityManaResp;
  int selectTabIndex = 0;
  EasyRefreshController _easyRefreshController = EasyRefreshController();
  bool _isHasPermission = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      _easyRefreshController.callRefresh();
    });
  }

  void doFetchCommodityMana() {
    RepositoryDao.fetchCommodityMana(organId: selectStore?.organCode).then((res) {
      if (res != null && res.result && res.data != null) {
        setState(() {
          _isHasPermission = true;
          _commodityManaResp = res.data;
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
    return StoreBuilder<GSYState>(builder: (context, store) {
      return Scaffold(
        body: Container(
          color: Color(0xffF4F4F4),
          height: double.infinity,
          child: EasyRefresh.builder(
            controller: _easyRefreshController,
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
              doFetchCommodityMana();
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
                                      Image.asset('assets/images/ic_stock_mana.png', width: 18.0, height: 18.0),
                                      Expanded(
                                        child: Padding(
                                          child: Text('库存管理', style: HCYYConstant.labelText),
                                          padding: EdgeInsets.only(left: 8.0),
                                        ),
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            NavigatorUtils.goWebView(context, Address.checkStock());
                                          },
                                          style: ButtonStyle(
                                            padding: MaterialStateProperty.all(EdgeInsets.zero),
                                            minimumSize: MaterialStateProperty.all(Size(50, 22)),
                                            shape: MaterialStateProperty.all(
                                              RoundedRectangleBorder(
                                                side: BorderSide(
                                                  width: 1,
                                                  color: Color(0xFF4BA9FF),
                                                ),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                            ),
                                          ),
                                          child: Text(
                                            '查库存',
                                            style: TextStyle(fontSize: 10.0, color: Color(0xFF4BA9FF)),
                                          ))
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 4.0),
                                    child: Container(
                                      height: 64.0,
                                      child: Flex(direction: Axis.horizontal, children: [
                                        Expanded(
                                          flex: 1,
                                          child: GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: () {
                                              NavigatorUtils.goWebView(context, Address.stockInventoryAmount());
                                            },
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      '库存成本金额',
                                                      style: TextStyle(color: Color(0xFFBBBBBB), fontSize: 12.0),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(left: 4.0),
                                                      child: Image.asset(
                                                        'assets/images/ic_arrow_right_blue.png',
                                                        width: 10.0,
                                                        height: 10.0,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(top: 2.0),
                                                  child: Text(
                                                    _commodityManaResp?.inventoryManage?.inventoryAmount?.toString() ?? '-',
                                                    style: TextStyle(color: Color(0xFFFF6565), fontSize: 18.0),
                                                  ),
                                                ),
                                              ],
                                            ),
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
                                                '周转天数',
                                                style: TextStyle(color: Color(0xFFBBBBBB), fontSize: 12.0),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(top: 2.0),
                                                child: Text(
                                                  _commodityManaResp?.inventoryManage?.turnoverDays?.toString() ?? '-',
                                                  style: TextStyle(color: Color(0xFF5BC4FF), fontSize: 18.0),
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
                                      height: 64.0,
                                      child: Flex(direction: Axis.horizontal, children: [
                                        Expanded(
                                          flex: 1,
                                          child: GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            onTap: () {
                                              NavigatorUtils.goWebView(context, Address.outBreed());
                                            },
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      '断货品种',
                                                      style: TextStyle(color: Color(0xFFBBBBBB), fontSize: 12.0),
                                                    ),
                                                    Padding(
                                                      padding: EdgeInsets.only(left: 4.0),
                                                      child: Image.asset(
                                                        'assets/images/ic_arrow_right_blue.png',
                                                        width: 10.0,
                                                        height: 10.0,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(top: 2.0),
                                                  child: Text(
                                                    _commodityManaResp?.inventoryManage?.outBreed?.toString() ?? '-',
                                                    style: TextStyle(color: Color(0xFFFF6565), fontSize: 18.0),
                                                  ),
                                                ),
                                              ],
                                            ),
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
                                                '断货率',
                                                style: TextStyle(color: Color(0xFFBBBBBB), fontSize: 12.0),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(top: 2.0),
                                                child: Text(
                                                  CommonUtils.formatPercent(_commodityManaResp?.inventoryManage?.outBreedRate, selectStore?.organCode == '0' ? (_storeList.length - 1) : 1),
                                                  style: TextStyle(color: Color(0xFF5BC4FF), fontSize: 18.0),
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
                                ],
                              ),
                              margin: const EdgeInsets.only(left: 16.0, right: 16.0),
                              padding: const EdgeInsets.only(top: 2.0, left: 16.0, right: 16.0, bottom: 16.0),
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20.0))),
                            )
                          ],
                        )),
                        Container(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Image.asset('assets/images/ic_move_sell.png', width: 18.0, height: 18.0),
                                  Padding(
                                    child: Text('动销管理', style: HCYYConstant.labelText),
                                    padding: EdgeInsets.only(left: 8.0),
                                  )
                                ],
                              ),
                              Container(
                                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                        '全部品种数 (个)',
                                        style: TextStyle(fontSize: HCYYConstant.minTextSize, color: HCYYColor.grey_88),
                                      )),
                                      Text(_commodityManaResp?.saleManage?.allBreeds?.toString() ?? '-', style: TextStyle(fontSize: HCYYConstant.middleTextWhiteSize, color: HCYYColor.grey_66))
                                    ],
                                  ),
                                  margin: EdgeInsets.only(top: 12.0),
                                  height: 42.0,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF9F9F9),
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  )),
                              Container(
                                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Row(
                                        children: [
                                          Text(
                                            '新品品种(个)',
                                            style: TextStyle(fontSize: HCYYConstant.minTextSize, color: HCYYColor.grey_88),
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                NavigatorUtils.goWebView(context, Address.newBreeds());
                                              },
                                              child: Text('查明细', style: TextStyle(color: Color(0xFF4BA9FF), fontSize: HCYYConstant.minTextSize)))
                                        ],
                                      )),
                                      Text(_commodityManaResp?.saleManage?.newBreed?.toString() ?? '-', style: TextStyle(fontSize: HCYYConstant.middleTextWhiteSize, color: HCYYColor.grey_66))
                                    ],
                                  ),
                                  margin: EdgeInsets.only(top: 12.0),
                                  height: 42.0,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF9F9F9),
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  )),
                              Container(
                                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                        '月动销率',
                                        style: TextStyle(fontSize: HCYYConstant.minTextSize, color: HCYYColor.grey_88),
                                      )),
                                      Text(CommonUtils.formatPercent(_commodityManaResp?.saleManage?.monthSaleRate, selectStore?.organCode == '0' ? (_storeList.length - 1) : 1),
                                          style: TextStyle(fontSize: HCYYConstant.middleTextWhiteSize, color: HCYYColor.grey_66))
                                    ],
                                  ),
                                  margin: EdgeInsets.only(top: 12.0),
                                  height: 42.0,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF9F9F9),
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  )),
                              Container(
                                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Text(
                                        '季动销率',
                                        style: TextStyle(fontSize: HCYYConstant.minTextSize, color: HCYYColor.grey_88),
                                      )),
                                      Text(CommonUtils.formatPercent(_commodityManaResp?.saleManage?.seasonSaleRate, selectStore?.organCode == '0' ? (_storeList.length - 1) : 1),
                                          style: TextStyle(fontSize: HCYYConstant.middleTextWhiteSize, color: HCYYColor.grey_66))
                                    ],
                                  ),
                                  margin: EdgeInsets.only(top: 12.0),
                                  height: 42.0,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF9F9F9),
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  )),
                              Container(
                                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Row(
                                        children: [
                                          Text(
                                            '60天-90天不动销(个)',
                                            style: TextStyle(fontSize: HCYYConstant.minTextSize, color: HCYYColor.grey_88),
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                NavigatorUtils.goWebView(context, Address.sixtyNoSale());
                                              },
                                              child: Text('查明细', style: TextStyle(color: Color(0xFF4BA9FF), fontSize: HCYYConstant.minTextSize)))
                                        ],
                                      )),
                                      Text(_commodityManaResp?.saleManage?.sixtyNoSale?.toString() ?? '-', style: TextStyle(fontSize: HCYYConstant.middleTextWhiteSize, color: HCYYColor.grey_66))
                                    ],
                                  ),
                                  margin: EdgeInsets.only(top: 12.0),
                                  height: 42.0,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF9F9F9),
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  )),
                              Container(
                                  padding: EdgeInsets.only(left: 16.0, right: 16.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          child: Row(
                                        children: [
                                          Text(
                                            '> 90天不动销(个)',
                                            style: TextStyle(fontSize: HCYYConstant.minTextSize, color: HCYYColor.grey_88),
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                NavigatorUtils.goWebView(context, Address.ninetyNoSale());
                                              },
                                              child: Text('查明细', style: TextStyle(color: Color(0xFF4BA9FF), fontSize: HCYYConstant.minTextSize)))
                                        ],
                                      )),
                                      Text(_commodityManaResp?.saleManage?.ninetyNoSale?.toString() ?? '-', style: TextStyle(fontSize: HCYYConstant.middleTextWhiteSize, color: HCYYColor.grey_66))
                                    ],
                                  ),
                                  margin: EdgeInsets.only(top: 12.0),
                                  height: 42.0,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFF9F9F9),
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                  )),
                            ],
                          ),
                          padding: const EdgeInsets.only(top: 16.0, bottom: 10.0, left: 16.0, right: 16.0),
                          margin: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20.0))),
                        ),
                        Container(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Image.asset('assets/images/ic_expire_mana.png', width: 18.0, height: 18.0),
                                  Expanded(
                                    child: Padding(
                                      child: Text('效期管理', style: HCYYConstant.labelText),
                                      padding: EdgeInsets.only(left: 8.0),
                                    ),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        NavigatorUtils.goWebView(context, Address.expiredDetailsCheck());
                                      },
                                      style: ButtonStyle(
                                        padding: MaterialStateProperty.all(EdgeInsets.zero),
                                        minimumSize: MaterialStateProperty.all(Size(50, 22)),
                                        shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                            side: BorderSide(
                                              width: 1,
                                              color: Color(0xFF4BA9FF),
                                            ),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        '查明细',
                                        style: TextStyle(fontSize: 10.0, color: Color(0xFF4BA9FF)),
                                      ))
                                ],
                              ),
                              Container(
                                child: Flex(
                                  direction: Axis.horizontal,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(top: 16.0),
                                            child: Text(
                                              '近1个月',
                                              style: TextStyle(color: Color(0xFFBBBBBB), fontSize: 12.0),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 4.0),
                                            child: Text(
                                              _commodityManaResp?.expiryManage?.oneMonthExpiry?.toString() ?? '-',
                                              style: TextStyle(color: Color(0xFF666666), fontSize: 18.0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      child: VerticalDivider(width: 2.0, color: Color(0xfff3f3f3)),
                                      padding: EdgeInsets.only(top: 32.0, bottom: 32.0),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(top: 16.0),
                                            child: Text(
                                              '近1-3个月',
                                              style: TextStyle(color: Color(0xFFBBBBBB), fontSize: 12.0),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 4.0),
                                            child: Text(
                                              _commodityManaResp?.expiryManage?.threeMonthExpiry?.toString() ?? '-',
                                              style: TextStyle(color: Color(0xFF666666), fontSize: 18.0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      child: VerticalDivider(width: 2.0, color: Color(0xfff3f3f3)),
                                      padding: EdgeInsets.only(top: 32.0, bottom: 32.0),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(top: 16.0),
                                            child: Text(
                                              '近3-6个月',
                                              style: TextStyle(color: Color(0xFFBBBBBB), fontSize: 12.0),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 4.0),
                                            child: Text(
                                              _commodityManaResp?.expiryManage?.sixMonthExpiry?.toString() ?? '-',
                                              style: TextStyle(color: Color(0xFF666666), fontSize: 18.0),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.only(top: 5.0, bottom: 10.0, left: 16.0, right: 16.0),
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
}
