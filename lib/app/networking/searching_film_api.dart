import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter_app/app/networking/api_service.dart';

class SearchingApi {
  final ApiService _apiService;
  SearchingApi(this._apiService);

  final apiKey = dotenv.env['API_KEY'] ?? '';
  Future<List<dynamic>> fetchMoviesWithGenner(
      String genreId, String sort) async {
    final response = await _apiService.get(
      '/discover/movie',
      queryParameters: {
        'api_key': apiKey,
        'language': 'vi',
        'with_genres': genreId,
        'sort_by': sort,
      },
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      final movies = responseBody['results'];
      return movies;
    } else {
      throw Exception('Failed to load movies');
    }
  }
}
