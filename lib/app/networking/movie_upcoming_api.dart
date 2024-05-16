import 'package:flutter_app/app/networking/api_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class MovieUpcomingApi {
  final ApiService _apiService;

  MovieUpcomingApi(this._apiService);

  Future<Map<String, dynamic>> fetchUpcomingMovie() async {
    try {
      final response = await _apiService.network(
        request: (request) => request.get("/movie/upcoming", queryParameters: {
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
