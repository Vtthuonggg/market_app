import 'package:flutter_app/app/networking/api_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MovieDetailApi {
  final ApiService _apiService;

  MovieDetailApi(this._apiService, {required int movieId});

  Future<Map<String, dynamic>> fetchMovieDetail(int movieId) async {
    try {
      final response = await _apiService.network(
        request: (request) => request.get("/movie/$movieId", queryParameters: {
          'api_key': dotenv.env['API_KEY'],
          'language': 'vi',
        }),
      );
      if (response != null) {
        return response;
      } else {
        print('Failed to load movie details');
        return {};
      }
    } catch (e) {
      print('Failed to fetch movie details: $e');
      return {};
    }
  }
}
