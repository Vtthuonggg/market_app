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

    final movies = response['results'];
    return movies;
  }

  Future<List<dynamic>> searchMovies(String query) async {
    try {
      final response = await _apiService.network(
        request: (request) => request.get("/search/movie", queryParameters: {
          'api_key': dotenv.env['API_KEY'],
          'language': 'vi',
          'query': query,
        }),
      );

      if (response != null && response['results'] != null) {
        return response['results'];
      } else {
        print('Failed to load search results');
        return [];
      }
    } catch (e) {
      print('Failed to fetch search results: $e');
      return [];
    }
  }
}
