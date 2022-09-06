import 'package:dio/dio.dart';

import 'dart:collection';

import 'code.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/header_interceptor.dart';
import 'interceptors/log_interceptor.dart';
import 'interceptors/response_interceptor.dart';
import 'interceptors/token_interceptor.dart';
import 'result_data.dart';

///http请求
class HttpManager {
  static const CONTENT_TYPE_JSON = "application/json";
  static const CONTENT_TYPE_FORM = "application/x-www-form-urlencoded";

  Dio _dio = Dio(); // 使用默认配置

  HttpManager() {
    _dio.interceptors.add(HeaderInterceptors());

    _dio.interceptors.add(TokenInterceptors());

    _dio.interceptors.add(LogsInterceptors());

    _dio.interceptors.add(ErrorInterceptors());

    _dio.interceptors.add(ResponseInterceptors());
  }

  CancelToken _cancelToken = CancelToken();

  void cancelRequest() {
    _cancelToken.cancel();
  }

  ///发起网络请求
  ///[ url] 请求url
  ///[ params] 请求参数
  ///[ header] 外加头
  ///[ option] 配置
  Future<ResultData?> netFetch(url, params, Map<String, dynamic>? header, Options? option, {noTip = false}) async {
    Map<String, dynamic> headers = HashMap();

    if (header != null) {
      headers.addAll(header);
    }

    if (option == null) {
      option = Options(method: "GET");
    }
    option.headers = headers;

    resultError(DioError e) {
      Response? errorResponse;
      if (e.response != null) {
        errorResponse = e.response;
      } else {
        errorResponse = Response(statusCode: 666, requestOptions: RequestOptions(path: url));
      }
      if (e.type == DioErrorType.connectTimeout || e.type == DioErrorType.receiveTimeout) {
        errorResponse!.statusCode = Code.NETWORK_TIMEOUT;
      }
      return new ResultData(Code.errorHandleFunction(errorResponse!.statusCode, e.message, noTip), false, errorResponse.statusCode!);
    }

    Response response;
    try {
      if (option.method == "GET") {
        response = await _dio.request(url, queryParameters: params, options: option, cancelToken: _cancelToken);
      } else {
        response = await _dio.request(url, data: params, queryParameters: params, options: option, cancelToken: _cancelToken);
      }
    } on DioError catch (e) {
      return resultError(e);
    }
    if (response.data is DioError) {
      return resultError(response.data);
    }
    return response.data;
  }
}

final HttpManager httpManager = new HttpManager();
