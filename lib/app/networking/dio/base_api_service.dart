import 'package:flutter/material.dart';
import 'package:flutter_app/resources/custom_toast.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '/config/decoders.dart';
import 'package:dio/dio.dart'; // Import Dio

class BaseApiService extends NyBaseApiService {
  final Dio dio;

  BaseApiService(BuildContext? context)
      : dio = Dio(),
        super(context) {
    // Thiết lập cấu hình cơ bản cho Dio
    dio.options.baseUrl = baseUrl;
    dio.interceptors.addAll(interceptors.values);

    // Thêm PrettyDioLogger nếu đang ở chế độ debug
    if (getEnv('APP_DEBUG', defaultValue: false) == true) {
      dio.interceptors.add(PrettyDioLogger());
    }
  }

  /// Map decoders to modelDecoders
  @override
  final Map<Type, dynamic> decoders = modelDecoders;

  /// Default interceptors
  @override
  final Map<Type, Interceptor> interceptors = {
    // Thêm các interceptors mặc định ở đây nếu cần
  };

  /// Thêm phương thức setRetry để cấu hình số lần thử lại
  void setRetry(int retries) {
    dio.interceptors.add(
      RetryInterceptor(
        dio: dio,
        retries: retries,
        retryDelays: List.generate(retries, (index) => Duration(seconds: 2)),
      ),
    );
  }

  /// Make a GET request
  Future<T?> get<T>(
    String url, {
    Object? data,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    if (T.toString() == 'dynamic') {
      return await network(
        request: (request) => request.getUri(Uri.parse(url),
            data: data,
            options: options,
            cancelToken: cancelToken,
            onReceiveProgress: onReceiveProgress),
      );
    }
    return await network<T>(
      request: (request) => request.getUri(Uri.parse(url),
          data: data,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress),
    );
  }

  /// Make a POST request
  Future<T?> post<T>(
    String url, {
    Object? data,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    if (T.toString() == 'dynamic') {
      return await network(
        request: (request) => request.postUri(Uri.parse(url),
            data: data,
            options: options,
            cancelToken: cancelToken,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress),
      );
    }
    return await network<T>(
      request: (request) => request.postUri(Uri.parse(url),
          data: data,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress),
    );
  }

  /// Make a PUT request
  Future<T?> put<T>(
    String url, {
    Object? data,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    if (T.toString() == 'dynamic') {
      return await network(
        request: (request) => request.putUri(Uri.parse(url),
            data: data,
            options: options,
            cancelToken: cancelToken,
            onSendProgress: onSendProgress,
            onReceiveProgress: onReceiveProgress),
      );
    }
    return await network<T>(
      request: (request) => request.putUri(Uri.parse(url),
          data: data,
          options: options,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress),
    );
  }

  /// Make a DELETE request
  Future<T?> delete<T>(
    String url, {
    Object? data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    if (T.toString() == 'dynamic') {
      return await network(
        request: (request) => request.deleteUri(Uri.parse(url),
            data: data, options: options, cancelToken: cancelToken),
      );
    }
    return await network<T>(
      request: (request) => request.deleteUri(Uri.parse(url),
          data: data, options: options, cancelToken: cancelToken),
    );
  }

  @override
  void displayError(DioException dioError, BuildContext context) {
    NyLogger.error(dioError.message ?? "");
    CustomToast.showToastWarning(context, description: "Something went wrong");
  }
}

/// Interceptor để quản lý số lần retry cho các yêu cầu mạng thất bại
class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int retries;
  final List<Duration> retryDelays;

  RetryInterceptor({
    required this.dio,
    required this.retries,
    required this.retryDelays,
  });

  @override
  Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
    var retriesCount = err.requestOptions.extra['retries'] ?? 0;

    if (retriesCount < retries) {
      retriesCount++;
      err.requestOptions.extra['retries'] = retriesCount;

      await Future.delayed(retryDelays[retriesCount - 1]);

      try {
        var response = await dio.request(
          err.requestOptions.path,
          options: Options(
            method: err.requestOptions.method,
            headers: err.requestOptions.headers,
          ),
          data: err.requestOptions.data,
          queryParameters: err.requestOptions.queryParameters,
        );
        return handler.resolve(response);
      } catch (e) {
        return handler.next(e as DioError);
      }
    }

    return handler.next(err);
  }
}
