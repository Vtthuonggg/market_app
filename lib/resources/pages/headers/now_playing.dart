import 'package:flutter/material.dart';
import 'package:flutter_app/app/networking/api_service.dart';
import 'package:flutter_app/app/networking/movie_now_playing_api.dart';

class NowPlaying extends StatefulWidget {
  const NowPlaying({super.key});

  @override
  State<NowPlaying> createState() => _NowPlayingState();
}

class _NowPlayingState extends State<NowPlaying> {
  late MovieNowPlayingApi movieNowPlayingApi;
  List<dynamic> movies = [];
  @override
  void initState() {
    super.initState();
    movieNowPlayingApi = MovieNowPlayingApi(ApiService());
    fetchMovies();
  }

  Future fetchMovies() async {
    try {
      var res = await movieNowPlayingApi.fetchNowPlayingMovies();
      if (res != null && res.containsKey('results')) {
        movies = res['results'];
      } else {
        print('No results found');
      }
    } catch (e) {
      print('Lỗi: $e');
    }
    print('Movies::: $movies');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchMovies(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.blue,
            ),
          );
        } else {
          if (snapshot.hasError)
            return Center(child: Text('Error: ${snapshot.error}'));
          else
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2 / 3,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10),
                itemCount: movies.length,
                itemBuilder: ((context, index) {
                  print(movies[0]['poster_path']);
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      'https://image.tmdb.org/t/p/w500${movies[index]['poster_path']}',
                      fit: BoxFit.cover,
                    ),
                  );
                }),
              ),
            );
        }
      },
    );
  }
}
