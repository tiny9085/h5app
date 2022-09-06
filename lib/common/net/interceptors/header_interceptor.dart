import 'package:dio/dio.dart';

/// header拦截器
/// Created by Jacky.Cai
/// on 2019/3/23.
class HeaderInterceptors extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    ///超时
    options.connectTimeout = 30000;
    options.receiveTimeout = 30000;
    super.onRequest(options, handler);
  }
}
