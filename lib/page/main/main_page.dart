import 'dart:io';

import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:smart_assistant/common/dao/repository_dao.dart';
import 'package:smart_assistant/common/dao/user_dao.dart';
import 'package:smart_assistant/common/event/index.dart';
import 'package:smart_assistant/common/net/address.dart';
import 'package:smart_assistant/common/style/hcyy_style.dart';
import 'package:smart_assistant/common/utils/common_utils.dart';
import 'package:smart_assistant/common/utils/navigator_utils.dart';
import 'package:smart_assistant/model/AppVersionEntity.dart';
import 'package:smart_assistant/model/TokenExpiredEvent.dart';
import 'package:smart_assistant/page/login_page.dart';
import 'package:smart_assistant/page/main/sell_chart_page.dart';

import 'commodity_management_page.dart';
import 'home_page.dart';
import 'member_management_page.dart';
import 'mine_page.dart';

import 'package:flutter/material.dart';
import 'package:rammus/rammus.dart' as rammus;

class MainPage extends StatefulWidget {
  static final String sName = "main";

  //生命周期函数
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _tabIndex = 0;
  var _pageController = PageController();
  bool _permission = false;
  String? _platformVersion = 'Unknown';

  /// 不退出
  Future<bool> _dialogExitApp(BuildContext context) async {
    ///如果是 android 回到桌面
    if (Platform.isAndroid) {
      AndroidIntent intent = AndroidIntent(
        action: 'android.intent.action.MAIN',
        category: "android.intent.category.HOME",
      );
      await intent.launch();
    }

    return Future.value(false);
  }

  void _pageChanged(int index) {
    setState(() {
      if (_tabIndex != index) _tabIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //注册监听，返回
    eventBus.on<TokenExpiredEvent>().listen((event) {
      print('event.content==>${event.content}');
      NavigatorUtils.goLogin(context);
    });

    // var res = UserDao.getUserInfoLocal();
    // res.d
    // ///获取本地登录用户信息
    // static getUserInfoLocal() {
    //   var userText = SPUtil.getString(Config.USER_INFO);
    //   if (userText != null) {
    //     var userMap = json.decode(userText);
    //     User user = User.fromJson(userMap);
    //     return DataResult(user, true);
    //   } else {
    //     return DataResult(null, false);
    //   }
    // }
    initPlatformState();
    if (!Platform.isAndroid) {
      rammus.configureNotificationPresentationOption();
    }
    rammus.initCloudChannelResult.listen((data) {
      print(
          "----------->init successful ${data.isSuccessful} ${data.errorCode} ${data.errorMessage}");
    });

    var channels = <rammus.NotificationChannel>[];
    channels.add(rammus.NotificationChannel(
      "centralized_activity",
      "集中活动",
      "集中活动",
      importance: rammus.AndroidNotificationImportance.MAX,
    ));
    channels.add(rammus.NotificationChannel(
      "psychological_tests",
      "心理测评",
      "心理测评",
      importance: rammus.AndroidNotificationImportance.MAX,
    ));
    channels.add(rammus.NotificationChannel(
      "system_notice",
      "公告信息",
      "公告信息",
      importance: rammus.AndroidNotificationImportance.MAX,
    ));
    getDeviceId();
    rammus.setupNotificationManager(channels);

    rammus.onNotification.listen((data) {
      print("----------->notification here ${data.summary}");
      setState(() {
        _platformVersion = data.summary;
      });
    });
    rammus.onNotificationOpened.listen((data) {
      print("-----------> ${data.summary} 被点了");
      setState(() {
        _platformVersion = "${data.summary} 被点了";
      });
    });

    rammus.onNotificationRemoved.listen((data) {
      print("-----------> $data 被删除了");
    });

    rammus.onNotificationReceivedInApp.listen((data) {
      print("-----------> ${data.summary} In app");
    });

    rammus.onNotificationClickedWithNoAction.listen((data) {
      print("${data.summary} no action");
    });

    rammus.onMessageArrived.listen((data) {
      print("received data -> ${data.content}");
      setState(() {
        _platformVersion = data.content;
      });
    });

    //判断是否检查版本更新
    DateTime today = DateTime.now();
    DateTime disableDate = DateTime.parse(UserDao.getDisableUpdateDate() ?? '1970-01-01 00:00:00');
    print('disableDate==>year:${disableDate.year} month:${disableDate.month} day:${disableDate.day}');
    if (!(today.year==disableDate.year && today.month==disableDate.month && today.day==disableDate.day)) {
      Future.delayed(Duration(seconds: 2), (){
        RepositoryDao.checkVersion().then((res) {
          if (res != null && res.result) {
            AppVersionEntity appVersionEntity = res.data;
            CommonUtils.showVersionUpdateDialog(context, appVersionEntity.description!, appVersionEntity.forceUpdate==1, appVersionEntity.downloadUrl!);
          }
        });
      });
    }
  }

  getDeviceId() async {
    var deviceId = await rammus.deviceId;
    print("deviceId:::$deviceId");
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String? platformVersion;

    // Platform messages may fail, so we use a try/catch PlatformException.
//    try {
//      platformVersion = await Rammus.platformVersion;
//    } on PlatformException {
//      platformVersion = 'Failed to get platform version.';
//    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return _dialogExitApp(context);
      },
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: this._tabIndex,
          selectedFontSize: 10.0,
          unselectedFontSize: 10.0,
          selectedItemColor: HCYYColor.blue_6d,
          type: BottomNavigationBarType.fixed,
          onTap: (index) {
            _pageController.jumpToPage(index);
          },
          items: [
            BottomNavigationBarItem(
              icon: Image.asset("assets/images/ic_navi_home.png", width: 24, height: 24),
              activeIcon: Image.asset("assets/images/ic_navi_home_s.png", width: 24, height: 24),
              label: ("首页"),
            ),
            BottomNavigationBarItem(
              icon: Image.asset("assets/images/ic_navi_sell_chart.png", width: 24, height: 24),
              activeIcon: Image.asset("assets/images/ic_navi_sell_chart_s.png", width: 24, height: 24),
              label: ("销售报表"),
            ),
            BottomNavigationBarItem(
              icon: Image.asset("assets/images/ic_navi_commodity_mana.png", width: 24, height: 24),
              activeIcon: Image.asset("assets/images/ic_navi_commodity_mana_s.png", width: 24, height: 24),
              label: ("商品管理"),
            ),
            BottomNavigationBarItem(
              icon: Image.asset("assets/images/ic_navi_member_mana.png", width: 24, height: 24),
              activeIcon: Image.asset("assets/images/ic_navi_member_mana_s.png", width: 24, height: 24),
              label: ("会员管理"),
            ),
            BottomNavigationBarItem(
              icon: Image.asset("assets/images/ic_navi_mine.png", width: 24, height: 24),
              activeIcon: Image.asset("assets/images/ic_navi_mine_s.png", width: 24, height: 24),
              label: ("我的"),
            ),
          ],
        ),
        body: PageView.builder(
            //要点1
            physics: NeverScrollableScrollPhysics(),
            //禁止页面左右滑动切换
            controller: _pageController,
            onPageChanged: _pageChanged,
            //回调函数
            itemCount: 5,
            itemBuilder: (context, index) {
              switch(index){
                case 0:
                  return HomePage((value) {
                    switch (value) {
                      case '查库存':
                        NavigatorUtils.goWebView(context, Address.checkStock());
                        break;
                      case '效期品种':
                        NavigatorUtils.goWebView(context, Address.expiredDetailsCheck());
                        break;
                      case '门店排行':
                        NavigatorUtils.goWebView(context, Address.storeRank());
                        break;
                      case '断货榜':
                        NavigatorUtils.goWebView(context, Address.outStockList());
                        break;
                      case '品种销售榜':
                        NavigatorUtils.goWebView(context, Address.productRank());
                        break;
                      case '不动销榜':
                        NavigatorUtils.goWebView(context, Address.fixedPinRank());
                        break;
                    }
                  });
                case 1:
                  return SellChartPage();
                case 2:
                  return CommodityManagementPage();
                case 3:
                  return MemberManagementPage();
                case 4:
                  return MinePage() ;
                default:
                  return Container();
              }
            }),
      ),
    );
  }
}
