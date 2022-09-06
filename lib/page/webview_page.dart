import 'dart:async';
import 'dart:io';

// import 'package:barcode_scan2/gen/protos/protos.pb.dart';
import 'package:barcode_scan2/gen/protos/protos.pbenum.dart';
import 'package:barcode_scan2/model/android_options.dart';
import 'package:barcode_scan2/model/scan_options.dart';
import 'package:barcode_scan2/model/scan_result.dart';
import 'package:barcode_scan2/platform_wrapper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_assistant/common/dao/user_dao.dart';
import 'package:smart_assistant/common/event/index.dart';
import 'package:smart_assistant/common/utils/common_utils.dart';
import 'package:smart_assistant/common/utils/jsbridge/js_bridge.dart';
import 'package:smart_assistant/common/utils/navigator_utils.dart';
import 'package:smart_assistant/model/CommonDataEvent.dart';
import 'package:smart_assistant/model/NotificationEvent.dart';
import 'package:smart_assistant/model/StoreEntity.dart';
import 'package:smart_assistant/redux/gsy_state.dart';
import 'package:smart_assistant/widget/custom_appbar.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:app_settings/app_settings.dart';

/// WebView页面
class WebviewPage extends StatefulWidget {
  static final String sName = "webview";

  WebviewPage({Key? key}) : super(key: key);

  @override
  WebViewState createState() => WebViewState();
}

class WebViewState extends State<WebviewPage> {
  String title = '';
  String? token;
  List<StoreEntity> _storeList = [];
  bool isRefreshFinish = false;
  bool isLoadedFirstStore = false;
  double beginX = 0.0;
  double beginY = 0.0;
  double updateX = 0.0;
  double updateY = 0.0;
  bool isHideHorizontalListen = true;

  final Completer<WebViewController> _controller = Completer<WebViewController>();
  final JsBridge _jsBridge = JsBridge();
  ScanResult? _scanResult;
  WebViewController? _webViewController;
  var _aspectTolerance = 0.00;
  var _numberOfCameras = 0;
  var _selectedCamera = -1;
  var _useAutoFocus = true;
  var _autoEnableFlash = false;
  MethodChannel _channel = const MethodChannel('com.hcyy.jygw/userdefault');
  bool _isOpen = false;

  static final _possibleFormats = BarcodeFormat.values.toList()
    ..removeWhere((e) => e == BarcodeFormat.unknown);

  List<BarcodeFormat> selectedFormats = [..._possibleFormats];

  @override
  void initState() {
    super.initState();
    EasyLoading.show(status: '加载中...');
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    token = UserDao.getToken();
    //注册监听
    eventBus.on<NotificationEvent>().listen((event) {
      print('event.code==>${event.code}');
      checkNotificationStatus();
    });
    Future.delayed(Duration.zero, () async {
      _numberOfCameras = await BarcodeScanner.numberOfCameras;
    });
  }

  void checkNotificationStatus () async {
    // _isOpen = await _channel.invokeMethod('checkNotificationStatus') as bool;//获取通知权限状态
    if (await Permission.notification.isGranted) {
      _isOpen = true;
    } else {
      _isOpen = false;
    }
    //将通知权限状态通知到前端、
    print('通知状态是否打开：$_isOpen');
    _jsBridge.callHandler('notificationStatus', data:_isOpen, onCallBack: (data) {
      print('接收到了');
    });
  }

  void jumpToAppSettings () async {
    // await _channel.invokeMethod('jumpToAppSettings');//跳转到app设置页面
    // checkNotificationStatus();

    AppSettings.openAppSettings();

  }

  @override
  void dispose() {
    super.dispose();
    EasyLoading.dismiss();
  }

  Future<void> _scan() async {
    try {
      final result = await BarcodeScanner.scan(
        options: ScanOptions(
          strings: {
            'cancel': '取消',
            'flash_on': '开灯',
            'flash_off': '关灯',
          },
          restrictFormat: selectedFormats,
          useCamera: _selectedCamera,
          autoEnableFlash: _autoEnableFlash,
          android: AndroidOptions(
            aspectTolerance: _aspectTolerance,
            useAutoFocus: _useAutoFocus,
          ),
        ),
      );
      setState(() {
        _scanResult = result;
        print('result.rawContent==>${result.rawContent}');
        _jsBridge.callHandler('scanResult', data:result.rawContent, onCallBack: (data) {
          // Fluttertoast.showToast(msg: data, gravity: ToastGravity.CENTER, toastLength: Toast.LENGTH_LONG);
        });
      });

    } on PlatformException catch (e) {
      setState(() {
        _scanResult = ScanResult(
          type: ResultType.Error,
          format: BarcodeFormat.unknown,
          rawContent: e.code == BarcodeScanner.cameraAccessDenied
              ? 'The user did not grant the camera permission!'
              : 'Unknown error: $e',
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String? url = ModalRoute.of(context)!.settings.arguments as String?; //3.在build方法中，接收传递过来的值
    return StoreBuilder<GSYState>(onInit: (store) {
      if (store.state.storeList != null) {
        _storeList.clear();
        _storeList.addAll(store.state.storeList!);
      }
    }, builder: (context, store) {
      return Scaffold(
          appBar: CustomAppBar(
            titleText: title,
            // brightness: SystemUiOverlayStyle.dark,
            backgroundColor: Colors.white,
            leftActions: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (!isRefreshFinish) {
                    NavigatorUtils.pop(context);
                  } else {
                    _jsBridge.callHandler('goBack', onCallBack: (data) {
                      Fluttertoast.showToast(msg: data, gravity: ToastGravity.CENTER, toastLength: Toast.LENGTH_LONG);
                    });
                  }
                },
                child: Container(
                  width: 38.0,
                  height: 38.0,
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/ic_top_back_grey.png',
                    width: 18.0,
                    height: 18.0,
                  ),
                ),
              )
            ],
          ),
          body: WebView(
            initialUrl: url,
            // scrollViewBounces: false,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) async {
              this._webViewController = webViewController;
              _jsBridge.loadJs(webViewController);
              _controller.complete(webViewController);
              _jsBridge.registerHandler('finish', onCallBack: (data, func) {
                NavigatorUtils.pop(context);
                func('finish');
              });
              _jsBridge.registerHandler('startRefresh', onCallBack: (data, func) {
                EasyLoading.show(status: '加载中...');
                func('startRefresh');
              });
              _jsBridge.registerHandler('finishRefresh', onCallBack: (data, func) {
                EasyLoading.dismiss();
                func('finishRefresh');
              });
              _jsBridge.registerHandler('toLogin', onCallBack: (data, func) {
                NavigatorUtils.goLogin(context);
                func('toLogin');
              });
              _jsBridge.registerHandler('getToken', onCallBack: (data, func) {
                func(token);
              });
              _jsBridge.registerHandler('setTitle', onCallBack: (data, func) {
                if (data != null) {
                  setState(() {
                    title = data.replaceAll('\"', '');
                  });
                }
                func('');
              });
              _jsBridge.registerHandler('selectStore', onCallBack: (data, func) {
                if (data != null) data = data.replaceAll('\"', '');
                if (!isLoadedFirstStore) {
                  if (_storeList.isNotEmpty) {
                    if (data == '1') {
                      _storeList = _storeList.sublist(1);
                    }
                    func(_storeList[0]);
                    print('_storeList[0].organCode>>>${_storeList[0].toJson().toString()}');
                  }
                  isLoadedFirstStore = true;
                } else {
                  setState(() {
                    print('_storeList.length>>>${_storeList.length}');
                    CommonUtils.showStoreListDialog(context, _storeList, (value) {
                      print('value>>>${value.toJson().toString()}');
                      func(value);
                    }, selectOrgCode: data);
                  });
                }
              });

              //显示键盘
              _jsBridge.registerHandler('showKeyboard', onCallBack: (data, func) {
                SystemChannels.textInput.invokeMethod('TextInput.show');
              });

              //扫一扫
              _jsBridge.registerHandler('scanCode', onCallBack: (data, func) {
                _scan();
              });

              //推送开关
              _jsBridge.registerHandler('pushSwitch', onCallBack: (data, func) {
                jumpToAppSettings();
              });

              //获取推送状态
              _jsBridge.registerHandler('checkNotificationStatus', onCallBack: (data, func) {
                print('test');
                checkNotificationStatus();
              });

              // //注册监听
              // eventBus.on<CommonDataEvent>().listen((event) {
              //   print('event.content==>${event.content}');
              //   _jsBridge.callHandler('scanResult', data:event.content, onCallBack: (data) {
              //     // Fluttertoast.showToast(msg: data, gravity: ToastGravity.CENTER, toastLength: Toast.LENGTH_LONG);
              //   });
              // });
            },

            ///scheme  hcyy://commodity/commodityDetail?proSid=xxxx
            navigationDelegate: (NavigationRequest request) {
              if (request.url.startsWith('hcyy')) {
                Uri uri = Uri.parse(request.url);
                if (uri.host == 'commodity') {
                  //商品详情
                  // String id = uri.queryParameters['proSid'];
                  // NavigatorUtils.goCommodityDetail(context, int.parse(id));
                }
                return NavigationDecision.prevent;
              }
              if (_jsBridge.handlerUrl(request.url)) {
                return NavigationDecision.navigate;
              }
              return NavigationDecision.prevent;
            },
            onPageFinished: (url) {
              _jsBridge.init();
              isRefreshFinish = true;
            },
          ));
    });
  }


}
