import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';
import 'package:redux/redux.dart';
import 'package:smart_assistant/common/config/config.dart';
import 'package:smart_assistant/common/dao/user_dao.dart';
import 'package:smart_assistant/common/event/index.dart';
import 'package:smart_assistant/common/net/address.dart';
import 'package:smart_assistant/common/net/api.dart';
import 'package:smart_assistant/common/utils/navigator_utils.dart';
import 'package:smart_assistant/model/CommonDataEvent.dart';
import 'package:smart_assistant/model/User.dart';
import 'package:smart_assistant/redux/user_redux.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'gsy_state.dart';
import 'middleware/epic_store.dart';
import 'package:rammus/rammus.dart' as rammus;
import 'package:device_info_plus/device_info_plus.dart';

final LoginReducer = combineReducers<bool>([
  TypedReducer<bool, LoginSuccessAction>(_loginResult),
  TypedReducer<bool, LogoutAction>(_logoutResult),
]);

bool _loginResult(bool result, LoginSuccessAction action) {
  if (action.success == true) {
    NavigatorUtils.goMain(action.context);
    // Config.IS_LOGIN_PAGE = false;
  }
  return action.success;
}

bool _logoutResult(bool result, LogoutAction action) {
  return true;
}

class LogoutAction {
  final BuildContext context;

  LogoutAction(this.context);
}

class LoginSuccessAction {
  final BuildContext context;
  final bool success;

  LoginSuccessAction(this.context, this.success);
}

class LoginAction {
  final BuildContext context;
  final String username;
  final String password;
  final String code;
  final String randomStr;
  LoginAction(this.context, this.username, this.password, this.code, this.randomStr);
}

class LoginMiddleware implements MiddlewareClass<GSYState> {
  @override
  void call(Store<GSYState> store, dynamic action, NextDispatcher next) {
    if (action is LogoutAction) {
      UserDao.clearAll(store);
      CookieManager().clearCookies();
      NavigatorUtils.goLogin(action.context);
    }
    // Make sure to forward actions to the next middleware in the chain!
    next(action);
  }
}

Stream<dynamic> loginEpic(Stream<dynamic> actions, EpicStore<GSYState> store) {
  Stream<dynamic> _loginIn(LoginAction action, EpicStore<GSYState> store) async* {
    var res = await UserDao.login(action.username, action.password, action.code, action.randomStr, store);
    EasyLoading.dismiss();
    if (res != null) {
      var response = res.data;
      print('response code：${response['code']}');
      if (response['code']!=0) {
        //登录失败
        int statusCode = response['code'];
        var data = response['data'];
        if (response['msg'] != null) {
          Fluttertoast.showToast(msg: response['msg'], gravity: ToastGravity.CENTER, toastLength: Toast.LENGTH_LONG);
        }
      } else {
        //登录成功
        var resultMap = new Map<String, dynamic>.from(response['data']);
        User? user;
        if (response != null) {
          user = User.fromJson(resultMap);
          //注册别名
          print('ydgj_${action.username}');
          rammus.addAlias('ydgj_${action.username}').then((value) {
            print('isSuccessful:${value.isSuccessful}');
            print('errorMessage:${value.errorMessage}');
            print('response:${value.response}');
          });
        }
        //保存用户信息
        store.dispatch(new UpdateUserAction(user!));
        UserDao.saveUserInfo(user);
        UserDao.saveAccessToken(user);
        //登录日志
        loginLog();
        //返回上一页面
        NavigatorUtils.pop(action.context);
        yield LoginSuccessAction(action.context, (res != null && res.result));
        //发送监听
        eventBus.fire(CommonDataEvent(''));
      }
    }
  }
  return actions.whereType<LoginAction>().switchMap((action) => _loginIn(action, store));
}

Future<void> loginLog() async {
  DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  Map<String, dynamic> deviceData = <String, dynamic>{};
  Map<String, dynamic> queryParam = Map();
  User user = UserDao.getUserInfoLocal().data;
  if (Platform.isAndroid) {
    deviceData =
        _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
    queryParam['userName'] = user.userInfo?.username ?? '';
    queryParam['deviceType'] = 1;
    queryParam['deviceNo'] = deviceData['id'];
    // queryParam['loginIp'] = deviceData['host'];
  } else if (Platform.isIOS) {
    deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
    queryParam['userName'] = user.userInfo?.username ?? '';
    queryParam['deviceType'] = 2;
    queryParam['deviceNo'] = deviceData['name'];
  }
  print('queryParam:$queryParam');
  Options options = Options(method: 'POST');
  var result = await httpManager.netFetch(Address.userLoginLog(), queryParam, null, options);
  if (result != null && result.result) {
    var response = result.data;
    var data = response['data'];
    print('msg:${response['msg']}');
    if (data != null) {

    } else {
      
    }
  } else {

  }
}

Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
  return <String, dynamic>{
    'version.securityPatch': build.version.securityPatch,
    'version.sdkInt': build.version.sdkInt,
    'version.release': build.version.release,
    'version.previewSdkInt': build.version.previewSdkInt,
    'version.incremental': build.version.incremental,
    'version.codename': build.version.codename,
    'version.baseOS': build.version.baseOS,
    'board': build.board,
    'bootloader': build.bootloader,
    'brand': build.brand,
    'device': build.device,
    'display': build.display,
    'fingerprint': build.fingerprint,
    'hardware': build.hardware,
    'host': build.host,
    'id': build.id,
    'manufacturer': build.manufacturer,
    'model': build.model,
    'product': build.product,
    'supported32BitAbis': build.supported32BitAbis,
    'supported64BitAbis': build.supported64BitAbis,
    'supportedAbis': build.supportedAbis,
    'tags': build.tags,
    'type': build.type,
    'isPhysicalDevice': build.isPhysicalDevice,
    'systemFeatures': build.systemFeatures,
  };
}

Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
  return <String, dynamic>{
    'name': data.name,
    'systemName': data.systemName,
    'systemVersion': data.systemVersion,
    'model': data.model,
    'localizedModel': data.localizedModel,
    'identifierForVendor': data.identifierForVendor,
    'isPhysicalDevice': data.isPhysicalDevice,
    'utsname.sysname:': data.utsname.sysname,
    'utsname.nodename:': data.utsname.nodename,
    'utsname.release:': data.utsname.release,
    'utsname.version:': data.utsname.version,
    'utsname.machine:': data.utsname.machine,
  };
}
