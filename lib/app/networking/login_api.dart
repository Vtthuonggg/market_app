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

  Future<bool> login(String username, String password) async {
    final requestToken = await getRequestToken();

    if (requestToken == null) {
      print('Failed to get request token');
      return false;
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

      if (response != null) {
        return response['success'];
      } else {
        print('Failed to login');
        return false;
      }
    } catch (e) {
      print('Failed to login: $e');
      return false;
    }
  }
}
