import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rammus/rammus.dart';
import 'package:redux/redux.dart';
import 'package:smart_assistant/common/local/local_storage.dart';
import 'package:smart_assistant/page/aboutus_page.dart';
import 'package:smart_assistant/page/agreement_page.dart';
import 'package:smart_assistant/page/feedback_page.dart';
import 'package:smart_assistant/page/forget_pwd_page.dart';
import 'package:smart_assistant/page/guide_page.dart';
import 'package:smart_assistant/page/login_page.dart';
import 'package:smart_assistant/page/main/main_page.dart';
import 'package:smart_assistant/page/policy_page.dart';
import 'package:smart_assistant/page/webview_page.dart';
import 'package:smart_assistant/page/scan_page.dart';
import 'common/dao/repository_dao.dart';
import 'common/dao/user_dao.dart';
import 'common/event/http_error_event.dart';
import 'common/event/index.dart';
import 'common/net/address.dart';
import 'common/net/code.dart';
import 'common/style/hcyy_style.dart';
import 'common/utils/common_utils.dart';
import 'common/utils/helper_data.dart';
import 'common/utils/navigator_utils.dart';
import 'model/CommonDataEvent.dart';
import 'model/NotificationEvent.dart';
import 'model/TokenExpiredEvent.dart';
import 'model/User.dart';
import 'page/welcome_page.dart';
import 'redux/gsy_state.dart';
import 'package:rammus/rammus.dart' as rammus;

class FlutterReduxApp extends StatefulWidget {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  _FlutterReduxAppState createState() => _FlutterReduxAppState();
}

class _FlutterReduxAppState extends State<FlutterReduxApp> with HttpErrorListener, NavigatorObserver, WidgetsBindingObserver {

  late Size _lastSize;
  /// 创建Store，引用 GSYState 中的 appReducer 实现 Reducer 方法
  /// initialState 初始化 State
  final store = new Store<GSYState>(
    appReducer,

    ///拦截器
    middleware: middleware,

    ///初始化数据
    initialState: GSYState(userInfo: User.empty(), storeList: [], login: false, themeData: CommonUtils.getThemeData(HCYYColor.primarySwatch)),
  );

  @override
  void initState() {
    _lastSize = WidgetsBinding.instance!.window.physicalSize;
    WidgetsBinding.instance!.addObserver(this);
    rammus.configureNotificationPresentationOption();
    rammus.register();
    //接收阿里云通知、消息
    rammusInitState();

    // StreamController<CloudPushMessage> _onMessageArrivedController = StreamController.broadcast();
    // Stream<CloudPushMessage> get onMessageArrived => _onMessageArrivedController.stream;
    super.initState();
    initPlatformState();//获取设备ID
    //这里是点击通知栏回调的方法
    rammus.onNotificationOpened.listen((data){
      print("-----------> ${data.summary} 被点了");
      //点击通知后跳转的页面

    });

    Future.delayed(Duration(seconds: 0), () {
      /// 通过 with NavigatorObserver ，在这里可以获取可以往上获取到
      /// MaterialApp 和 StoreProvider 的 context
      /// 还可以获取到 navigator;
      /// 比如在这里增加一个监听，如果 token 失效就退回登陆页。
      navigator!.context;
      navigator;
    });
  }

  //注册监听
  void rammusInitState( ) {
    var channels = <rammus.NotificationChannel>[];
    // channels.add(rammus.NotificationChannel(
    //   "AliPushNotification",
    //   "rammus",
    //   "rammus test",
    //   importance: rammus.AndroidNotificationImportance.MAX,
    // ));
    rammus.setupNotificationManager(channels);
    print("----------->注册监听");
    rammus.onNotification.listen((data) async{
      print("----------->notification here ${data.summary}");
      // setState(() {
      //   _platformVersion = data.summary;
      // });
    });
    rammus.onNotificationOpened.listen((data) async{
      Map<String, dynamic> dataExtras = json.decode(data.extras!);
      Map<String, dynamic> map = json.decode(dataExtras['jsonData']);
      String jumpUrl = map['jumpUrl'];
      print('jumpUrl----------->${Address.APP_HTML_DOMAIN}$jumpUrl&token=${UserDao.getAccessToken()}');
      NavigatorUtils.goWebView(navigator!.context, '${Address.APP_HTML_DOMAIN}$jumpUrl&token=${UserDao.getAccessToken()}');
      print("-----------> ${data.summary} 被点了");
      print("-----------> ${data.extras} 被点了");
      print("-----------> ${data.subtitle} 被点了");
      print("-----------> ${data.badge} 被点了");
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
      // setState(() {
      //   _platformVersion = data.content;
      // });
    });
  }

  //获取device id的方法
  Future<void> initPlatformState() async {
    String deviceId;
    try {
      deviceId = (await rammus.deviceId)!;
      print('deviceId==>$deviceId');
    } on PlatformException {
      deviceId = 'Failed to get device id.';
    }
    if (!mounted) return;
    // setState(() {
    //   _deviceId = deviceId;
    //   //接下来你要做的事情
    //   //1.将device id通过接口post给后台，然后进行指定设备的推送
    //   //2.推送的时候，在Android8.0以上的设备都要设置通知通道
    // });
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    setState(() {
      _lastSize = WidgetsBinding.instance!.window.physicalSize;
      CommonData.devicePixelRatio =
          WidgetsBinding.instance!.window.devicePixelRatio;
      CommonData.screenH = _lastSize.height/CommonData.devicePixelRatio;
      CommonData.screenW = _lastSize.width/CommonData.devicePixelRatio;
      // print('CommonData.screenH: ${CommonData.screenH}');
      // print('CommonData.screenW: ${CommonData.screenW}');
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        {
          print('AppLifecycleState.resumed:${AppLifecycleState.resumed}');
          //发送通知监听
          eventBus.fire(NotificationEvent('CheckNotification'));
          break;
        }

      case AppLifecycleState.paused:
        {
          print('AppLifecycleState.paused:${AppLifecycleState.paused}');
          break;
        }
      case AppLifecycleState.inactive:
        {
          print('AppLifecycleState.inactive:${AppLifecycleState.inactive}');
          break;
        }
      case AppLifecycleState.detached:
        {
          print('AppLifecycleState.detached:${AppLifecycleState.detached}');
          break;
        }
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    /// 使用 flutter_redux 做全局状态共享
    /// 通过 StoreProvider 应用 store
    return StoreProvider(
      store: store,
      child: StoreBuilder<GSYState>(onInit: (store) {
        SPUtil.getInstance();
      }, builder: (context, store) {
        ///使用 StoreBuilder 获取 store 中的 theme 、locale
        store.state.platformLocale = WidgetsBinding.instance!.window.locale;
        return ScreenUtilInit(
          // iphone x分辨率
          designSize: Size(375, 812),
          builder: () => MaterialApp(
              debugShowCheckedModeBanner: false,
              navigatorKey: FlutterReduxApp.navigatorKey,
              title: '药店管家',
              builder: EasyLoading.init(),

              ///多语言实现代理
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                // GSYLocalizationsDelegate.delegate,
              ],
              // supportedLocales: [store.state.locale!],
              // locale: store.state.locale,
              theme: store.state.themeData,
              navigatorObservers: [this],
              ///命名式路由
              /// "/" 和 MaterialApp 的 home 参数一个效果
              routes: {
                WelcomePage.sName: (context) {
                  // DebugLabel.showDebugLabel(context);
                  return WelcomePage();
                },
                MainPage.sName: (context) {
                  return NavigatorUtils.pageContainer(MainPage(), context);
                },
                LoginPage.sName: (context) {
                  return NavigatorUtils.pageContainer(LoginPage(), context);
                },
                WebviewPage.sName: (context) {
                  return NavigatorUtils.pageContainer(WebviewPage(), context);
                },
                ForgetPwdPage.sName: (context) {
                  return NavigatorUtils.pageContainer(ForgetPwdPage(), context);
                },
                AboutUsPage.sName: (context) {
                  return NavigatorUtils.pageContainer(AboutUsPage(), context);
                },
                FeedbackPage.sName: (context) {
                  return NavigatorUtils.pageContainer(FeedbackPage(), context);
                },
                AgreementPage.sName: (context) {
                  return NavigatorUtils.pageContainer(AgreementPage(), context);
                },
                PolicyPage.sName: (context) {
                  return NavigatorUtils.pageContainer(PolicyPage(), context);
                },
                GuidePage.sName: (context) {
                  return NavigatorUtils.pageContainer(GuidePage(), context);
                },
                ScanPage.sName: (context) {
                  return NavigatorUtils.pageContainer(ScanPage(), context);
                },
          }),
        );
      }),
    );
  }
}

mixin HttpErrorListener on State<FlutterReduxApp> {
  StreamSubscription? stream;

  ///这里为什么用 _context 你理解吗？
  ///因为此时 State 的 context 是 FlutterReduxApp 而不是 MaterialApp
  ///所以如果直接用 context 是会获取不到 MaterialApp 的 Localizations 哦。

  @override
  void initState() {
    super.initState();

    ///Stream演示event bus
    stream = eventBus.on<HttpErrorEvent>().listen((event) {
      errorHandleFunction(event.code, event.message);
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (stream != null) {
      stream!.cancel();
      stream = null;
    }
  }

  ///网络错误提醒
  errorHandleFunction(int code, message) {
    switch (code) {
      case Code.NETWORK_ERROR:
        showToast('网络错误');
        break;
      case 401:
        showToast('[401错误可能: 未授权 \\ 授权登录失败 \\ 登录过期]');
        break;
      case 403:
        showToast('403权限错误');
        break;
      case 404:
        showToast('404错误');
        break;
      case 422:
        showToast('请求实体异常，请确保 Github ClientId 、账号秘密等信息正确。');
        break;
      case 424:
        showToast('token已过期');
        //发送监听
        FlutterReduxApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(LoginPage.sName, ModalRoute.withName("/"));
        // rammus.removeAlias(alias);
        break;
      case 426:
        showToast('用户名不存在或者密码错误，请重试');
        //发送监听
        eventBus.fire(CommonDataEvent('用户名不存在或者密码错误，请重试'));
        break;
      case 428:
        showToast('验证码不合法');
        //发送监听
        eventBus.fire(CommonDataEvent('验证码不合法'));
        break;
      case 501:
        showToast('服务器内部错误');
        break;
      case 503:
        showToast('服务器不可用');
        break;
      case Code.NETWORK_TIMEOUT:
        //超时
        showToast('请求超时!');
        break;
      default:
        showToast('其他异常 $message');
        break;
    }
  }

  showToast(String message) {
    Fluttertoast.showToast(msg: message, gravity: ToastGravity.CENTER, toastLength: Toast.LENGTH_LONG);
  }
}
