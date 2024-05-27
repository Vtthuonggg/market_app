import 'dart:convert';

import 'package:flutter_app/app/networking/api_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nylo_framework/nylo_framework.dart';

class FavoriteApi extends NyBaseApiService {
  final ApiService _apiService;
  FavoriteApi(this._apiService) : super(null);

  Future<int> getAccountId(String sessionId) async {
    final response = await _apiService.get(
      '/account',
      queryParameters: {
        'api_key': dotenv.env['API_KEY'] ?? '',
        'language': 'vi',
        'session_id': sessionId,
      },
    );
    try {
      if (response != null) {
        final data = response;
        if (data['id'] != null) {
          print('GETACCOUNTID:: ${data['id']}');
          return data['id'];
        } else {
          throw Exception('ID not found in response');
        }
      } else {
        throw Exception('Failed to get account id');
      }
    } catch (e) {
      print('Lỗi GetAccound $e');
      return 0;
    }
  }

  Future<void> addFavoriteMovie({
    required int movieId,
    required String accessToken,
    required bool isFavorite,
  }) async {
    final accountId = await getAccountId(accessToken);
    final apiKey = dotenv.env['API_KEY'] ?? '';

    final response = await _apiService.post(
      'https://api.themoviedb.org/3/account/$accountId/favorite?api_key=$apiKey&language=vi',
      data: {
        "media_type": "movie",
        "media_id": movieId,
        "favorite": isFavorite
      },
      options: Options(headers: {
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIxZDE2MmJkMzgxNjgwZjUzZjg2NWI0ZWJlODBlNTAxZSIsInN1YiI6IjY2NDFlNzQyOTA5YWVkY2FiM2YxMzI3NCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.x826zaFBAr4Oh8-YN5j9hmmcy_VH6wf4tv1ShlzCHEU',
        'accept': 'application/json',
      }),
    );

    if (response['success'] != true) {
      throw Exception('Failed to add movie to favorites');
    }
  }
}
