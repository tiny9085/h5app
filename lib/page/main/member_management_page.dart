import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:smart_assistant/common/dao/repository_dao.dart';
import 'package:smart_assistant/common/style/hcyy_style.dart';
import 'package:smart_assistant/common/utils/common_utils.dart';
import 'package:smart_assistant/model/MemberResp.dart';
import 'package:smart_assistant/model/StoreEntity.dart';
import 'package:smart_assistant/redux/gsy_state.dart';
import 'package:smart_assistant/widget/member_line_chart.dart';
import 'package:smart_assistant/widget/sliver_app_bar_delegate.dart';
import 'package:redux/redux.dart';

class MemberManagementPage extends StatefulWidget {
  static final String sName = 'memberManagement';

  //生命周期函数
  @override
  _MemberManagementPageState createState() => _MemberManagementPageState();
}

class _MemberManagementPageState extends State<MemberManagementPage> with AutomaticKeepAliveClientMixin {
  StoreEntity? selectStore;
  List<StoreEntity> _storeList = [];
  int? touchedIndex;
  int selectTabIndex = 0;
  int selectLabelIndex = 0;
  String selectLabel = '1周';
  MemberResp? _memberResp;
  EasyRefreshController _easyRefreshController = EasyRefreshController();
  List<String> _richTextArr = ['累计新增', '0', '名，日均增加', '0', '名'];
  bool _isHasPermission = true;

  @override
  bool get wantKeepAlive => true;

  List<PieChartSectionData> showingSections(int type, double percent) {
    return List.generate(2, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 20 : 14;
      final double radius = isTouched ? 40 : 30;
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: Color(type == 1 ? 0xffFFCB65 : 0xffFF8A8A),
            titlePositionPercentageOffset: -1.0,
            value: percent,
            title: '$percent%',
            radius: radius,
            titleStyle: TextStyle(fontSize: fontSize, color: Color(0xFF888888)),
          );
        case 1:
        default:
          return PieChartSectionData(
            color: Color(type == 1 ? 0x1AFFCB65 : 0x1AFF8A8A),
            value: 100 - percent,
            showTitle: false,
            radius: radius,
            titleStyle: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: const Color(0xffffffff)),
          );
      }
    });
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 500), () {
      _easyRefreshController.callRefresh();
    });
  }

  int getDays() {
    switch (selectLabelIndex) {
      case 0:
        return 7;
      case 1:
        return 30;
      case 2:
        return 90;
      case 3:
        return 180;
      default:
        return 1;
    }
  }

  void _changeRichText() {
    switch (selectTabIndex) {
      case 0:
        _richTextArr[0] = '累计新增';
        _richTextArr[1] = (_memberResp?.newMember?.sum![selectLabelIndex].round() ?? 0).toString();
        _richTextArr[2] = '名，日均增加';
        _richTextArr[3] = _memberResp?.newMember?.avg![selectLabelIndex] ?? '';
        _richTextArr[4] = '名';
        break;
      case 1:
        _richTextArr[0] = '累计销售额';
        _richTextArr[1] = (_memberResp?.memberSales?.sum![selectLabelIndex].round() ?? 0).toString();
        _richTextArr[2] = '元，日均销售额';
        _richTextArr[3] = _memberResp?.memberSales?.avg![selectLabelIndex] ?? '';
        _richTextArr[4] = '元';
        break;
      case 2:
      default:
        _richTextArr[0] = '累计增加';
        _richTextArr[1] = (_memberResp?.memberOrder?.sum![selectLabelIndex].round() ?? 0).toString();
        _richTextArr[2] = '单，日均增加';
        _richTextArr[3] = _memberResp?.memberOrder?.avg![selectLabelIndex] ?? '';
        _richTextArr[4] = '单';
        break;
    }
  }

  void doFetchMemberManage() {
    RepositoryDao.fetchMemberManage(organId: selectStore?.organCode).then((res) {
      if (res != null && res.result && res.data != null) {
        setState(() {
          _isHasPermission = true;
          _memberResp = res.data;
          _changeRichText();
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
              doFetchMemberManage();
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
                                      Image.asset('assets/images/ic_member_data.png', width: 18.0, height: 18.0),
                                      Padding(
                                        child: Text('会员数据概况', style: HCYYConstant.labelText),
                                        padding: EdgeInsets.only(left: 8.0),
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 16.0),
                                    child: Container(
                                      height: 66.0,
                                      child: Flex(direction: Axis.horizontal, children: [
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '总会员数',
                                                style: TextStyle(color: Color(0xFFBBBBBB), fontSize: 12.0),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(top: 4.0),
                                                child: Text(
                                                  _memberResp?.member?.totalMember?.toString() ?? '-',
                                                  style: TextStyle(color: Color(0XFFFF6565), fontSize: 18.0),
                                                ),
                                              ),
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
                                                '有效会员数',
                                                style: TextStyle(color: Color(0xFFBBBBBB), fontSize: 12.0),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(top: 4.0),
                                                child: Text(
                                                  _memberResp?.member?.validMember?.toString() ?? '-',
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
                                      child: Flex(direction: Axis.horizontal, children: [
                                        Expanded(
                                          flex: 1,
                                          child: Column(
                                            children: [
                                              Text(
                                                '会员来店占比',
                                                style: TextStyle(color: Color(0xFFBBBBBB), fontSize: 12.0),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(top: 14.0),
                                                child: Container(
                                                  width: 120.0,
                                                  height: 120.0,
                                                  alignment: Alignment.topCenter,
                                                  child: (_memberResp?.member?.memberGuestPercent == null || _memberResp?.member?.memberGuestPercent == 0)
                                                      ? Text('-')
                                                      : PieChart(
                                                          PieChartData(
                                                              pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
                                                                setState(() {
                                                                  final desiredTouch = pieTouchResponse.touchInput is! PointerExitEvent && pieTouchResponse.touchInput is! PointerUpEvent;
                                                                  if (desiredTouch && pieTouchResponse.touchedSection != null) {
                                                                    touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                                                                  } else {
                                                                    touchedIndex = -1;
                                                                  }
                                                                });
                                                              }),
                                                              borderData: FlBorderData(
                                                                show: false,
                                                              ),
                                                              centerSpaceColor: Colors.white,
                                                              startDegreeOffset: -90,
                                                              sectionsSpace: 0,
                                                              centerSpaceRadius: double.infinity,
                                                              sections: showingSections(
                                                                  1, CommonUtils.getPercent(_memberResp?.member?.memberGuestPercent, selectStore?.organCode == '0' ? (_storeList.length - 1) : 1)!)),
                                                        ),
                                                ),
                                              ),
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
                                            children: [
                                              Text(
                                                '会员销售额占比',
                                                style: TextStyle(color: Color(0xFFBBBBBB), fontSize: 12.0),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(top: 14.0),
                                                child: Container(
                                                  width: 120.0,
                                                  height: 120.0,
                                                  alignment: Alignment.topCenter,
                                                  child: (_memberResp?.member?.memberSalePercent == null || _memberResp?.member?.memberSalePercent == 0)
                                                      ? Text('-')
                                                      : PieChart(
                                                          PieChartData(
                                                              pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
                                                                setState(() {
                                                                  final desiredTouch = pieTouchResponse.touchInput is! PointerExitEvent && pieTouchResponse.touchInput is! PointerUpEvent;
                                                                  if (desiredTouch && pieTouchResponse.touchedSection != null) {
                                                                    touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                                                                  } else {
                                                                    touchedIndex = -1;
                                                                  }
                                                                });
                                                              }),
                                                              borderData: FlBorderData(
                                                                show: false,
                                                              ),
                                                              centerSpaceColor: Colors.white,
                                                              startDegreeOffset: -90,
                                                              sectionsSpace: 0,
                                                              centerSpaceRadius: double.infinity,
                                                              sections: showingSections(
                                                                  2, CommonUtils.getPercent(_memberResp?.member?.memberSalePercent, selectStore?.organCode == '0' ? (_storeList.length - 1) : 1)!)),
                                                        ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]),
                                      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 16.0, right: 16.0),
                                    ),
                                  ),
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
                                  Image.asset('assets/images/ic_trend_chart.png', width: 18.0, height: 18.0),
                                  Padding(
                                    child: Text('趋势图', style: HCYYConstant.labelText),
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
                                              '新会员数',
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
                                              _changeRichText();
                                            });
                                          },
                                        ),
                                        flex: 1,
                                      ),
                                      Expanded(
                                        child: GestureDetector(
                                          behavior: HitTestBehavior.opaque,
                                          child: Container(
                                            child: Text('会员销售额', style: TextStyle(color: selectTabIndex == 1 ? Colors.white : Color(0xFF6BBCFF), fontSize: 14.0)),
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
                                              _changeRichText();
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
                                            child: Text('会员成单数', style: TextStyle(color: selectTabIndex == 2 ? Colors.white : Color(0xFF6BBCFF), fontSize: 14.0)),
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
                                              _changeRichText();
                                            });
                                          },
                                        ),
                                        flex: 1,
                                      )
                                    ],
                                  ),
                                  margin: EdgeInsets.only(top: 16.0, bottom: 14.0),
                                  height: 32.0,
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 1, color: Color(0xFF6BBCFF)),
                                    borderRadius: BorderRadius.all(Radius.circular(6.0)),
                                  )),
                              Row(children: [
                                Expanded(
                                  child: Text(
                                    '近$selectLabel趋势',
                                    style: TextStyle(fontSize: 13.0, color: Color(0xFF666666)),
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    style: TextStyle(
                                      color: Color(0xFF888888),
                                      fontSize: 12.0,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: _richTextArr[0],
                                      ),
                                      TextSpan(
                                          text: _richTextArr[1],
                                          style: TextStyle(
                                            color: Color(0xFFFF6565),
                                            fontSize: 12.0,
                                          )),
                                      TextSpan(
                                        text: _richTextArr[2],
                                      ),
                                      TextSpan(
                                          text: _richTextArr[3],
                                          style: TextStyle(
                                            color: Color(0xFFFF6565),
                                            fontSize: 12.0,
                                          )),
                                      TextSpan(
                                        text: _richTextArr[4],
                                      ),
                                    ],
                                  ),
                                ),
                              ]),
                              Container(
                                margin: EdgeInsets.only(top: 14.0),
                                height: 212.0,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 1, color: Color(0xFFD7F3FF)),
                                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                ),
                                child: MemberLineChart(_memberResp, selectTabIndex, selectLabelIndex),
                              ),
                              Container(
                                height: 28.0,
                                margin: EdgeInsets.only(top: 14.0, bottom: 10.0),
                                child: Flex(
                                  direction: Axis.horizontal,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        child: Container(
                                          child: Text('1周', style: TextStyle(color: selectLabelIndex == 0 ? Colors.white : Color(0xFF666666), fontSize: 14.0)),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                              gradient: selectLabelIndex == 0
                                                  ? LinearGradient(
                                                      begin: Alignment.centerLeft,
                                                      end: Alignment.centerRight,
                                                      colors: [
                                                        Color(0xff9566FF),
                                                        Color(0xff68C0FF),
                                                      ],
                                                    )
                                                  : null,
                                              border: Border.all(color: Color(0xFFEEEEEE), width: 1, style: BorderStyle.solid)),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            selectLabelIndex = 0;
                                            selectLabel = '1周';
                                            _changeRichText();
                                          });
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10.0),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        child: Container(
                                          child: Text('1个月', style: TextStyle(color: selectLabelIndex == 1 ? Colors.white : Color(0xFF666666), fontSize: 14.0)),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                              gradient: selectLabelIndex == 1
                                                  ? LinearGradient(
                                                      begin: Alignment.centerLeft,
                                                      end: Alignment.centerRight,
                                                      colors: [
                                                        Color(0xff9566FF),
                                                        Color(0xff68C0FF),
                                                      ],
                                                    )
                                                  : null,
                                              border: Border.all(color: Color(0xFFEEEEEE), width: 1, style: BorderStyle.solid)),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            selectLabelIndex = 1;
                                            selectLabel = '1个月';
                                            _changeRichText();
                                          });
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10.0),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        child: Container(
                                          child: Text('3个月', style: TextStyle(color: selectLabelIndex == 2 ? Colors.white : Color(0xFF666666), fontSize: 14.0)),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                              gradient: selectLabelIndex == 2
                                                  ? LinearGradient(
                                                      begin: Alignment.centerLeft,
                                                      end: Alignment.centerRight,
                                                      colors: [
                                                        Color(0xff9566FF),
                                                        Color(0xff68C0FF),
                                                      ],
                                                    )
                                                  : null,
                                              border: Border.all(color: Color(0xFFEEEEEE), width: 1, style: BorderStyle.solid)),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            selectLabelIndex = 2;
                                            selectLabel = '3个月';
                                            _changeRichText();
                                          });
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10.0),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        child: Container(
                                          child: Text('6个月', style: TextStyle(color: selectLabelIndex == 3 ? Colors.white : Color(0xFF666666), fontSize: 14.0)),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                              gradient: selectLabelIndex == 3
                                                  ? LinearGradient(
                                                      begin: Alignment.centerLeft,
                                                      end: Alignment.centerRight,
                                                      colors: [
                                                        Color(0xff9566FF),
                                                        Color(0xff68C0FF),
                                                      ],
                                                    )
                                                  : null,
                                              border: Border.all(color: Color(0xFFEEEEEE), width: 1, style: BorderStyle.solid)),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            selectLabelIndex = 3;
                                            selectLabel = '6个月';
                                            _changeRichText();
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          padding: const EdgeInsets.only(top: 16.0, bottom: 10.0, left: 16.0, right: 16.0),
                          margin: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(20.0))),
                        ),
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
