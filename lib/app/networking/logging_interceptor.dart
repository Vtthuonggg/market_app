import 'dart:convert';
import 'dart:developer';
import 'package:nylo_framework/nylo_framework.dart';

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    NyLogger.debug(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');

    handler.next(response);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');

    handler.next(err);
  }
}
