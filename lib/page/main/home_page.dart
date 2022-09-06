import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_assistant/common/dao/repository_dao.dart';
import 'package:smart_assistant/common/style/hcyy_style.dart';
import 'package:smart_assistant/common/utils/common_utils.dart';
import 'package:smart_assistant/common/utils/helper_data.dart';
import 'package:smart_assistant/model/IndexResp.dart';
import 'package:smart_assistant/model/StoreEntity.dart';
import 'package:smart_assistant/redux/gsy_state.dart';
import 'package:smart_assistant/redux/store_redux.dart';
import 'package:smart_assistant/widget/sliver_app_bar_delegate.dart';
import 'package:smart_assistant/widget/swiper.dart';

class HomePage extends StatefulWidget {
  static final String sName = "home";

  final ValueChanged<String> valueChanged;

  HomePage(this.valueChanged);

  //生命周期函数
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  StoreEntity? selectStore;
  List<StoreEntity> _storeList = [];
  List<BannerItem> _bannerList = [];
  List<Module> _moduleList = [];
  IndexResp? _indexResp;
  EasyRefreshController _easyRefreshController = EasyRefreshController();
  bool _isHasPermission = true;

  @override
  bool get wantKeepAlive => true;

  List<Widget> _buildGridItem() {
    List<Widget> list = [];
    for (int index = 0; index < _moduleList.length; index++) {
      Module module = _moduleList[index];
      list.add(
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Column(
            children: [
              Image.network(
                module.funcImage,
                width: 24.0,
                height: 24.0,
                fit: BoxFit.contain,
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: Text(
                  module.moduleName,
                  style: TextStyle(fontSize: 14.0, color: Color(0xff888888)),
                ),
              )
            ],
          ),
          onTap: () => widget.valueChanged(module.moduleName),
        ),
      );
    }
    return list;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      _easyRefreshController.callRefresh();
    });
  }

  void doFetchIndex() {
    RepositoryDao.fetchIndex(organId: selectStore?.organCode).then((res) {
      print('res==>${res.data}');
      if (res != null && res.result && res.data != null) {
        setState(() {
          _isHasPermission = true;
          _indexResp = res.data;
          _bannerList.clear();
          _bannerList.addAll(_indexResp!.bannerList);
          _storeList.clear();
          if (selectStore == null) {
            selectStore = StoreEntity('0', '', '所有门店', '');
            _storeList.add(selectStore!);
          } else {
            _storeList.add(StoreEntity('0', '', '所有门店', ''));
          }
          _storeList.addAll(_indexResp!.orgList);
          StoreProvider.of<GSYState>(context).dispatch(UpdateStoreAction(_storeList));
          _moduleList.clear();
          _moduleList.addAll(_indexResp!.moduleList);
        });
        _easyRefreshController.finishRefresh();
      } else {
        setState(() {
          _isHasPermission = false;
        });
      }
    });
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
            enableControlFinishRefresh: true,
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
              doFetchIndex();
            },
            controller: _easyRefreshController,
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
                          width: double.infinity,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: AssetImage('assets/images/bg_home_down.png'),
                            fit: BoxFit.fill,
                          )),
                          padding: EdgeInsets.only(left: 16.0, right: 16.0),
                          height: (CommonData.screenW - 40) / 2.4,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Swiper(
                              formatBannerData(_bannerList),
                              showIndicator: _bannerList.length > 1,
                              activeColor: Color(0xFF6DB9FF),
                              defaultColor: Color(0x336DB9FF),
                              indicatorSize: Size(6, 6),
                              onTap: (value) {
                                print(value);
                              },
                              height: (CommonData.screenW - 40) / 2.4,
                            ),
                          ),
                        ),
                        Card(
                            elevation: 0.0,
                            shape: new RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
                            color: Colors.white,
                            margin: const EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                            child: GridView.count(
                              physics: NeverScrollableScrollPhysics(),
                              crossAxisCount: 3,
                              children: _buildGridItem(),
                              padding: EdgeInsets.only(top: 30.0, bottom: 10.0),
                              shrinkWrap: true,
                              mainAxisSpacing: 2,
                              crossAxisSpacing: 2,
                              childAspectRatio: 1.7,
                            )),
                        Container(
                            height: 60.0,
                            margin: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                            padding: EdgeInsets.only(left: 16.0, right: 16.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xffFFC42E),
                                  Color(0xffFFA8A8),
                                ],
                              ),
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/ic_sales.png',
                                  width: 16.0,
                                  height: 16.0,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text('销售额', style: HCYYConstant.whiteText),
                                  ),
                                ),
                                Text(
                                  _indexResp?.sale?.sales?.toString() ?? '-',
                                  style: TextStyle(color: Colors.white, fontSize: 24.0),
                                )
                              ],
                            )),
                        Container(
                          height: 92.0,
                          margin: EdgeInsets.only(left: 16.0, right: 16.0),
                          color: Color(0xfffbfbfb),
                          child: Flex(direction: Axis.horizontal, children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 16.0, top: 16.0),
                                    child: Text(
                                      '毛利额（元）',
                                      style: TextStyle(color: Color(0xffbbbbbb), fontSize: 12.0),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 16.0, top: 4.0),
                                        child: Text(
                                          _indexResp?.sale?.grossProfit?.toString() ?? '-',
                                          style: TextStyle(color: Color(0xff666666), fontSize: 18.0),
                                        ),
                                      ),
                                    ],
                                  )
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 16.0, top: 16.0),
                                    child: Text(
                                      '订单数（单）',
                                      style: TextStyle(color: Color(0xffbbbbbb), fontSize: 12.0),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(left: 16.0, top: 4.0),
                                        child: Text(
                                          _indexResp?.sale?.orderQuantity?.toString() ?? '-',
                                          style: TextStyle(color: Color(0xff666666), fontSize: 18.0),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ]),
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
                                        padding: EdgeInsets.only(left: 16.0, top: 16.0),
                                        child: Text(
                                          '毛利率',
                                          style: TextStyle(color: Color(0xffbbbbbb), fontSize: 12.0),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 16.0, top: 4.0),
                                        child: Text(
                                          CommonUtils.formatPercent(_indexResp?.sale?.profitRate, selectStore?.organCode == '0' ? (_storeList.length - 1) : 1),
                                          style: TextStyle(color: Color(0xff666666), fontSize: 18.0),
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
                                          '客流量',
                                          style: TextStyle(color: Color(0xffbbbbbb), fontSize: 12.0),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 4.0),
                                        child: Text(
                                          _indexResp?.sale?.guestFlow?.toString() ?? '-',
                                          style: TextStyle(color: Color(0xff666666), fontSize: 18.0),
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
                                        padding: EdgeInsets.only(top: 16.0, right: 16.0),
                                        child: Text(
                                          '客单价',
                                          style: TextStyle(color: Color(0xffbbbbbb), fontSize: 12.0),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 4.0, right: 16.0),
                                        child: Text(
                                          _indexResp?.sale?.guestUnitPrice?.toString() ?? '-',
                                          style: TextStyle(color: Color(0xff666666), fontSize: 18.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            height: 90.0,
                            margin: EdgeInsets.only(left: 16.0, right: 16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0)),
                            )),
                        Container(
                            height: 60.0,
                            margin: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                            padding: EdgeInsets.only(left: 16.0, right: 16.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xff25BEFF),
                                  Color(0xffAAB3FF),
                                ],
                              ),
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/ic_inventory_cost.png',
                                  width: 16.0,
                                  height: 16.0,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text('库存成本金额', style: HCYYConstant.whiteText),
                                  ),
                                ),
                                Text(
                                  _indexResp?.inventory?.inventoryAmount?.toString() ?? '-',
                                  style: TextStyle(color: Colors.white, fontSize: 24.0),
                                )
                              ],
                            )),
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
                                        padding: EdgeInsets.only(left: 16.0, top: 16.0),
                                        child: Text(
                                          '新品品种数',
                                          style: TextStyle(color: Color(0xffbbbbbb), fontSize: 12.0),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 16.0, top: 4.0),
                                        child: Text(
                                          _indexResp?.inventory?.newBreed?.toString() ?? '-',
                                          style: TextStyle(color: Color(0xff666666), fontSize: 18.0),
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
                                          '断货品种数',
                                          style: TextStyle(color: Color(0xffbbbbbb), fontSize: 12.0),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 4.0),
                                        child: Text(
                                          _indexResp?.inventory?.outBreed?.toString() ?? '-',
                                          style: TextStyle(color: Color(0xff666666), fontSize: 18.0),
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
                                        padding: EdgeInsets.only(top: 16.0, right: 16.0),
                                        child: Text(
                                          '效期品种数',
                                          style: TextStyle(color: Color(0xffbbbbbb), fontSize: 12.0),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 4.0, right: 16.0),
                                        child: Text(
                                          _indexResp?.inventory?.expiryBreed?.toString() ?? '-',
                                          style: TextStyle(color: Color(0xff666666), fontSize: 18.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            height: 90.0,
                            margin: EdgeInsets.only(left: 16.0, right: 16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0)),
                            )),
                        Container(
                            height: 60.0,
                            margin: EdgeInsets.only(top: 16.0, left: 16.0, right: 16.0),
                            padding: EdgeInsets.only(left: 16.0, right: 16.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Color(0xff00E9BF),
                                  Color(0xff0EB7FF),
                                ],
                              ),
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/images/ic_new_member.png',
                                  width: 16.0,
                                  height: 16.0,
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 8.0),
                                    child: Text('新增会员数', style: HCYYConstant.whiteText),
                                  ),
                                ),
                                Text(
                                  _indexResp?.member?.members?.toString() ?? '-',
                                  style: TextStyle(color: Colors.white, fontSize: 24.0),
                                )
                              ],
                            )),
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
                                        padding: EdgeInsets.only(left: 16.0, top: 16.0),
                                        child: Text(
                                          '交易会员数',
                                          style: TextStyle(color: Color(0xffbbbbbb), fontSize: 12.0),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 16.0, top: 4.0),
                                        child: Text(
                                          _indexResp?.member?.tradeMembers?.toString() ?? '-',
                                          style: TextStyle(color: Color(0xff666666), fontSize: 18.0),
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
                                          '会员销售占比',
                                          style: TextStyle(color: Color(0xffbbbbbb), fontSize: 12.0),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 4.0),
                                        child: Text(
                                          CommonUtils.formatPercent(_indexResp?.member?.memberSalePercent, selectStore?.organCode == '0' ? (_storeList.length - 1) : 1),
                                          style: TextStyle(color: Color(0xff666666), fontSize: 18.0),
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
                                        padding: EdgeInsets.only(top: 16.0, right: 16.0),
                                        child: Text(
                                          '会员来客占比',
                                          style: TextStyle(color: Color(0xffbbbbbb), fontSize: 12.0),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 4.0, right: 16.0),
                                        child: Text(
                                          CommonUtils.formatPercent(_indexResp?.member?.memberGuestPercent, selectStore?.organCode == '0' ? (_storeList.length - 1) : 1),
                                          style: TextStyle(color: Color(0xff666666), fontSize: 18.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            height: 90.0,
                            margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0)),
                            ))
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

  List<String> formatBannerData(List<BannerItem> bannerList) {
    List<String> dataList = [];
    _bannerList.forEach((element) {
      dataList.add(element.bannerUrl);
    });
    return dataList;
  }
}
