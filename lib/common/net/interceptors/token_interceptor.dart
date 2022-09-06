import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smart_assistant/common/config/config.dart';
import 'package:smart_assistant/common/dao/user_dao.dart';
import 'package:smart_assistant/common/local/local_storage.dart';
import 'package:smart_assistant/page/login_page.dart';

import '../../../app.dart';

/// Token拦截器
/// Created by Jacky.Cai
/// on 2019/3/23.
class TokenInterceptors extends InterceptorsWrapper {
  String? _token;

  @override
  void onError(DioError error, ErrorInterceptorHandler handler) {
    if (error.response != null && error.response!.statusCode == 401) {
      _token = null;
      // httpManager.cancelRequest();
      FlutterReduxApp.navigatorKey.currentState!.pushNamedAndRemoveUntil(LoginPage.sName, ModalRoute.withName(LoginPage.sName));
    }
    super.onError(error, handler);
  }

  // @override
  // void onResponse(Response response, ResponseInterceptorHandler handler) {
  //   try {
  //     var responseJson = response.data;
  //     if (response.statusCode == 201 && responseJson["token"] != null) {
  //       _token = 'token ' + responseJson["token"];
  //       LocalStorage.save(Config.TOKEN_KEY, _token);
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  //   super.onResponse(response, handler);
  // }

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (!options.path.contains("auth/mobile/token/sms") && !options.path.contains("pharmacy/checkcode/upw") && !options.path.contains("pharmacy/version/info")) {
      //登录
      //授权码
      // if (_token == null) {
      var authorizationCode = await getAuthorization();
      if (authorizationCode != null) {
        _token = authorizationCode;
        // initClient(_token);
      }
      // }
      options.headers["Authorization"] = _token;
    }
    super.onRequest(options, handler);
  }

  ///清除授权
  clearAuthorization() {
    this._token = null;
    SPUtil.remove(Config.TOKEN_KEY);
    // releaseClient();
  }

  ///获取授权token
  getAuthorization() {
    var token = UserDao.getToken();
    if (token == null) {
      String? basic = SPUtil.getString(Config.USER_BASIC_CODE);
      if (basic == null) {
        //提示输入账号密码
      } else {
        //通过 basic 去获取token，获取到设置，返回token
        return "Basic $basic";
      }
    } else {
      this._token = token;
      return token;
    }
  }
}
