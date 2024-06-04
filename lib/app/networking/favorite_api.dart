import 'dart:convert';

import 'package:flutter_app/app/networking/api_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteApi extends NyBaseApiService {
  final ApiService _apiService;
  FavoriteApi(this._apiService) : super(null);
  Future<String?> getSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('sessionId');
  }

  Future<int> getAccountId() async {
    final sessionId = await getSessionId();
    final response = await _apiService.get(
      '/account',
      queryParameters: {
        'api_key': dotenv.env['API_KEY'] ?? '',
        'language': 'vi',
        'session_id': sessionId ?? '',
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
    required bool isFavorite,
  }) async {
    final sessionId = await getSessionId();
    final accountId = await getAccountId();
    final apiKey = dotenv.env['API_KEY'] ?? '';
    print("CHECK MOVIEID");
    print(movieId);
    print(isFavorite);
    final response = await _apiService.post(
      'https://api.themoviedb.org/3/account/$accountId/favorite?api_key=$apiKey&session_id=$sessionId&language=vi',
      data: {
        "media_type": "movie",
        "media_id": movieId,
        "favorite": isFavorite
      },
      options: Options(headers: {
        'accept': 'application/json',
      }),
    );

    if (response['success'] != true) {
      return response;
    }
  }

  Future<List<dynamic>> getFavoriteMovies() async {
    final sessionId = await getSessionId();
    final accountId = await getAccountId();
    final apiKey = dotenv.env['API_KEY'] ?? '';

    final response = await _apiService.get(
      'https://api.themoviedb.org/3/account/$accountId/favorite/movies?api_key=$apiKey&session_id=$sessionId&language=vi',
    );

    return response['results'];
  }
}
