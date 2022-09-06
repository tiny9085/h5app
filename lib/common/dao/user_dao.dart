import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:redux/redux.dart';
import 'package:smart_assistant/common/config/config.dart';
import 'package:smart_assistant/common/local/local_storage.dart';
import 'package:smart_assistant/common/net/address.dart';
import 'package:smart_assistant/common/net/api.dart';
import 'package:smart_assistant/model/User.dart';
import 'package:smart_assistant/redux/user_redux.dart';

import 'dao_result.dart';

class UserDao {
  static login(name, pwd, code, randomStr, store) async {
    Map<String, String> query = Map();
    query['mobile'] = name;
    query['password'] = pwd;
    query['code'] = code;
    query['randomStr'] = randomStr;
    query['grant_type'] = 'mobile';
    String url = Address.login();
    var res = await httpManager.netFetch(
        url,
        query,
        {
          HttpHeaders.authorizationHeader: 'Basic cGlnOnBpZw==',
        },
        null);
    if (res != null) {
      return DataResult(res.data, true);
    } else {
      return DataResult(null, false);
    }
  }

  ///初始化用户信息
  static initUserInfo(Store store) async {
    var token = SPUtil.getString(Config.TOKEN_KEY);
    var res = getUserInfoLocal();
    if (res != null && res.result && token != null) {
      store.dispatch(UpdateUserAction(res.data));
    }
    return DataResult(res.data, (res.result && (token != null)));
  }

  ///获取token
  static getToken() {
    return SPUtil.getString(Config.TOKEN_KEY);
  }

  ///获取本地登录用户信息
  static getUserInfoLocal() {
    var userText = SPUtil.getString(Config.USER_INFO);
    if (userText != null) {
      var userMap = json.decode(userText);
      User user = User.fromJson(userMap);
      return DataResult(user, true);
    } else {
      return DataResult(null, false);
    }
  }

  static saveUserInfo(User? user) {
    SPUtil.putString(Config.TOKEN_KEY, user!.tokenInfo!.tokenType! + " " + user.tokenInfo!.accessToken!);
    SPUtil.putString(Config.USER_INFO, json.encode(user.toJson()));
  }

  static clearAll(Store store) {
    SPUtil.remove(Config.TOKEN_KEY);
    SPUtil.remove(Config.USER_INFO);
    store.dispatch(UpdateUserAction(User.empty()));
  }

  static saveAccessToken(User? user) {
    SPUtil.putString(Config.ACCESS_TOKEN_KEY, user!.tokenInfo!.accessToken!);
  }

  static getAccessToken() {
    return SPUtil.getString(Config.ACCESS_TOKEN_KEY);
  }

  //设置禁止日期
  static setDisableUpdateDate(String disableUpdateDate) {
    SPUtil.putString(Config.DISABLE_UPDATE_DATE, disableUpdateDate);
  }

  //获取禁止日期
  static getDisableUpdateDate() {
    return SPUtil.getString(Config.DISABLE_UPDATE_DATE);
  }
}
