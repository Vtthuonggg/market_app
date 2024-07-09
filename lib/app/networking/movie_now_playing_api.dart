import 'package:flutter_app/app/networking/api_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MovieNowPlayingApi {
  final ApiService _apiService;

  MovieNowPlayingApi(this._apiService);

  Future<Map<String, dynamic>> fetchNowPlayingMovies() async {
    try {
      final response = await _apiService.network(
        request: (request) =>
            request.get("/movie/now_playing", queryParameters: {
          'api_key': dotenv.env['API_KEY'],
          'language': 'vi',
        }),
      );

      if (response != null) {
        return response;
      } else {
        print('Failed to load now playing movies ');
        return {};
      }
    } catch (e) {
      print('Failed to fetch now playing movies: $e');
      return {};
    }
  }
}
