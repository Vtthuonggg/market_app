import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_app/app/networking/api_service.dart';

class TMDBLoginApi {
  final ApiService _apiService;

  TMDBLoginApi(this._apiService);

  Future<String?> getRequestToken() async {
    final response = await _apiService.network(
      request: (request) => request.get(
        "/authentication/token/new",
        queryParameters: {
          'api_key': dotenv.env['API_KEY'],
        },
      ),
    );

    return response?['request_token'];
  }

  Future<String?> login(String username, String password) async {
    final requestToken = await getRequestToken();

    if (requestToken == null) {
      return null;
    }

    try {
      final response = await _apiService.network(
        request: (request) => request.post(
          "/authentication/token/validate_with_login",
          queryParameters: {
            'api_key': dotenv.env['API_KEY'],
          },
          data: jsonEncode({
            'username': username,
            'password': password,
            'request_token': requestToken,
          }),
        ),
      );

      if (response != null && response['success']) {
        final sessionResponse = await _apiService.network(
          request: (request) => request.post(
            "/authentication/session/new",
            queryParameters: {
              'api_key': dotenv.env['API_KEY'],
            },
            data: jsonEncode({
              'request_token': response['request_token'],
            }),
          ),
        );

        if (sessionResponse != null && sessionResponse['success']) {
          return sessionResponse['session_id'];
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
