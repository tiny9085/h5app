import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smart_assistant/common/config/config.dart';
import 'package:smart_assistant/common/dao/user_dao.dart';
import 'package:smart_assistant/common/net/address.dart';
import 'package:smart_assistant/common/net/api.dart';
import 'package:smart_assistant/model/AppVersionEntity.dart';
import 'package:smart_assistant/model/CommodityManaResp.dart';
import 'package:smart_assistant/model/IndexResp.dart';
import 'package:smart_assistant/model/MemberResp.dart';
import 'package:smart_assistant/model/SalesReportResp.dart';
import 'package:smart_assistant/model/StoreEntity.dart';
import 'package:smart_assistant/model/User.dart';
import 'dart:io' show Platform;

import 'dao_result.dart';

class RepositoryDao {
  static feedback(String content) async {
    String url = Address.feedback();
    Map<String, String> query = Map();
    query['content'] = content;
    Options options = Options(method: 'POST');
    var res = await httpManager.netFetch(url, query, null, options);
    if (res != null && res.data != null) {
      if (res.data['data'] is bool && res.data['data']) {
        return new DataResult(null, true);
      } else {
        return new DataResult(null, false);
      }
    } else {
      return new DataResult(null, false);
    }
  }

  static fetchOrganList() async {
    String url = Address.fetchOrganList();
    var res = await httpManager.netFetch(url, null, null, null);
    if (res != null && res.result) {
      var response = res.data;
      List<StoreEntity> list = [];
      for (int i = 0; i < response['data'].length; i++) {
        list.add(new StoreEntity.fromJson(response['data'][i]));
      }
      return new DataResult(list, true);
    }
    return new DataResult(null, false);
  }

  static fetchIndex({String? organId}) async {
    String url = Address.fetchIndex();
    Map<String, String> query = Map();
    if (organId != null && organId != '0') query['organId'] = organId;
    var res = await httpManager.netFetch(url, query, null, null);
    if (res != null && res.result) {
      var response = res.data;
      var data = response['data'];
      if (data != null) {
        IndexResp indexResp = IndexResp.fromJson(data);
        return DataResult(indexResp, true);
      } else {
        var msg = response['msg'];
        if (msg != null) Fluttertoast.showToast(msg: msg, gravity: ToastGravity.CENTER, toastLength: Toast.LENGTH_LONG);
      }
    }
    return new DataResult(null, false);
  }

  static fetchSalesReport({String? organId}) async {
    String url = Address.fetchSalesReport();
    Map<String, String> query = Map();
    if (organId != null && organId != '0') query['organId'] = organId;
    var res = await httpManager.netFetch(url, query, null, null);
    if (res != null && res.result) {
      var response = res.data;
      var data = response['data'];
      if (data != null) {
        SalesReportResp salesReportResp = SalesReportResp.fromJson(response['data']);
        return DataResult(salesReportResp, true);
      } else {
        var msg = response['msg'];
        if (msg != null) Fluttertoast.showToast(msg: msg, gravity: ToastGravity.CENTER, toastLength: Toast.LENGTH_LONG);
      }
    }
    return new DataResult(null, false);
  }

  static fetchCommodityMana({String? organId}) async {
    String url = Address.fetchCommodityMana();
    Map<String, String> query = Map();
    if (organId != null && organId != '0') query['organId'] = organId;
    var res = await httpManager.netFetch(url, query, null, null);
    if (res != null && res.result) {
      var response = res.data;
      var data = response['data'];
      if (data != null) {
        CommodityManaResp commodityManaResp = CommodityManaResp.fromJson(response['data']);
        return DataResult(commodityManaResp, true);
      } else {
        var msg = response['msg'];
        if (msg != null) Fluttertoast.showToast(msg: msg, gravity: ToastGravity.CENTER, toastLength: Toast.LENGTH_LONG);
      }
    }
    return new DataResult(null, false);
  }

  static fetchMemberManage({String? organId}) async {
    String url = Address.memberManage();
    Map<String, String> query = Map();
    if (organId != null && organId != '0') query['organId'] = organId;
    var res = await httpManager.netFetch(url, query, null, null);
    if (res != null && res.result) {
      var response = res.data;
      var data = response['data'];
      if (data != null) {
        MemberResp memberResp = MemberResp.fromJson(response['data']);
        return DataResult(memberResp, true);
      } else {
        var msg = response['msg'];
        if (msg != null) Fluttertoast.showToast(msg: msg, gravity: ToastGravity.CENTER, toastLength: Toast.LENGTH_LONG);
      }
    }
    return new DataResult(null, false);
  }

  static sendCode(String userMobile) async {
    String url = Address.sendCode(userMobile);
    var res = await httpManager.netFetch(url, null, null, null);
    if (res != null && res.data != null) {
      if (res.data['success'] is bool && res.data['success']) {
        return new DataResult(null, true);
      } else if (res.data['msg'] != null) {
        Fluttertoast.showToast(msg: res.data['msg'], gravity: ToastGravity.CENTER, toastLength: Toast.LENGTH_LONG);
      }
    }
    return new DataResult(null, false);
  }

  static modifyPwd(String userMobile, String oldPwd, String newPwd, String confirmPwd) async {
    String url = Address.modifyPwd();
    Map<String, String> query = Map();
    User user = UserDao.getUserInfoLocal().data;
    query['userId'] = '${user.userInfo!.id}';
    query['userName'] = user.userInfo!.username.toString();
    query['userMobile'] = userMobile;
    query['oldPwd'] = oldPwd;
    query['newPwd'] = newPwd;
    query['confirmPwd'] = confirmPwd;
    Options options = new Options(method: "PUT");
    var res = await httpManager.netFetch(url, query, null, options);
    if (res != null && res.data != null) {
      if (res.data['code']==0) {
        return new DataResult(null, true);
      } else if (res.data['msg'] != null) {
        Fluttertoast.showToast(msg: res.data['msg'], gravity: ToastGravity.CENTER, toastLength: Toast.LENGTH_LONG);
      }
    }
    return new DataResult(null, false);
  }

  //检查手机盘点权限
  static checkPermission() async {
    String url = Address.checkPermission();
    Options options = new Options(method: "GET");
    var res = await httpManager.netFetch(url, null, null, options);
    if (res != null && res.code==200) {
      return new DataResult('成功', true);
    } else {
      return new DataResult('请联系售后开通盘点功能权限', false);
    }
  }

  //检查远程审方权限
  static reviewerPermission() async {
    String url = Address.reviewerPermission();
    Options options = new Options(method: "POST");
    var res = await httpManager.netFetch(url, null, null, options);
    if (res != null && res.code==200) {
      return new DataResult('成功', true);
    } else {
      return new DataResult('请联系售后开通远程审方功能权限', false);
    }
    return new DataResult(null, false);
  }

  //检查版本更新
  static const IOS_VERSION = "1.1.1";
  static const ANDROID_VERSION = "3.0.2";
  static checkVersion() async {
    String url = Address.checkVersion(Platform.isAndroid?'Android':'IOS', Platform.isAndroid?Config.ANDROID_VERSION:Config.IOS_VERSION);
    print('版本更新url：$url');
    Options options = new Options(method: "GET");
    var res = await httpManager.netFetch(url, null, null, options);
    if (res != null && res.code==200) {
      print('版本更新内容：${res.data}');
      print('版本更新code：${res.code}');
      var response = res.data;
      if (response['code']==0) {
        AppVersionEntity appVersionEntity = AppVersionEntity.fromJson(response['data']);
        return DataResult(appVersionEntity, true);
      } else {
        return DataResult(response['msg'], false);
      }
    } else {
      return DataResult('系统异常，请稍等', false);
    }
  }
}
