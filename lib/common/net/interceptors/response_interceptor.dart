import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smart_assistant/common/config/config.dart';
import 'package:smart_assistant/common/local/local_storage.dart';
import 'package:smart_assistant/page/login_page.dart';

import '../../../app.dart';
import '../code.dart';
import '../result_data.dart';

/// Token拦截器
/// Created by Jacky.Cai
/// on 2019/3/23.
class ResponseInterceptors extends InterceptorsWrapper {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    RequestOptions option = response.requestOptions;
    var value;
    try {
      var header = response.headers[Headers.contentTypeHeader];
      if ((header != null && header.toString().contains("text"))) {
        value = new ResultData(response.data, true, Code.SUCCESS);
      } else if (response.statusCode! >= 200 && response.statusCode! < 300) {
        //登录超时
        // if ((response.data["code"] == 181005 || response.data["code"] == 181006) && !Config.IS_LOGIN_PAGE) {
        //   SPUtil.remove(Config.TOKEN_KEY);
        //   SPUtil.remove(Config.USER_INFO);
        //   FlutterReduxApp.navigatorKey.currentState!.pushNamedAndRemoveUntil(LoginPage.sName, ModalRoute.withName(LoginPage.sName));
        //
        //   Config.IS_LOGIN_PAGE = true;
        //   return null;
        // }
        value = new ResultData(response.data, true, Code.SUCCESS, headers: response.headers);
      }
    } catch (e) {
      print(e.toString() + option.path);
      value = new ResultData(response.data, false, response.statusCode!, headers: response.headers);
    }
    response.data = value;
    super.onResponse(response, handler);
  }
}
