import 'dart:convert' as convert;
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../code.dart';
import '../result_data.dart';

///是否需要弹提示
const NOT_TIP_KEY = "noTip";

/// 错误拦截
/// Created by Jacky.Cai
/// on 2019/3/23.
class ErrorInterceptors extends InterceptorsWrapper {
  ErrorInterceptors();

  // @override
  // void onError(DioError err, ErrorInterceptorHandler handler) {
  //   if (err.type == DioErrorType.connectTimeout) {
  //     Fluttertoast.showToast(msg: '请求超时');
  //   }else{
  //     String errJson = err.response?.toString() ?? '';
  //     Map<String, dynamic> errMap = convert.jsonDecode(errJson);
  //     String errMsg = errMap['msg'];
  //     if (errMsg.isNotEmpty) Fluttertoast.showToast(msg: errMsg);
  //   }
  //
  //   super.onError(err, handler);
  // }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    //没有网络
    var connectivityResult = (Connectivity().checkConnectivity());
    // ignore: unrelated_type_equality_checks
    if (connectivityResult == ConnectivityResult.none) {
      handler.resolve(Response(data: ResultData(Code.errorHandleFunction(Code.NETWORK_ERROR, "", false), false, Code.NETWORK_ERROR), requestOptions: RequestOptions(path: options.path)));
    }
    super.onRequest(options, handler);
  }
}
