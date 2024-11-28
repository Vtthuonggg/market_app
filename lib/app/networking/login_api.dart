import 'package:flutter/material.dart';
import 'package:flutter_app/app/models/user.dart';
import 'package:flutter_app/app/networking/dio/base_api_service.dart';
import 'package:flutter_app/app/networking/logging_interceptor.dart';
import 'package:flutter_app/config/storage_keys.dart';
import 'package:nylo_framework/nylo_framework.dart';

class AccountApi extends BaseApiService {
  AccountApi({BuildContext? buildContext}) : super(buildContext);
  @override
  final interceptors = {LoggingInterceptor: LoggingInterceptor()};
  @override
  String get baseUrl => getEnv('API_BASE_URL');

  Future<User?> login(dynamic data) async {
    return await network(
        request: (request) => request.post("/login", data: data),
        handleFailure: (error) => throw error,
        handleSuccess: (response) async {
          User user = User.fromJson(response.data["data"]["user"]);

          await NyStorage.store(
              StorageKey.userToken, response.data["data"]["access_token"],
              inBackpack: true);
          return user;
        });
  }
}
