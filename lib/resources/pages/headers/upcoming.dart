import 'package:flutter/material.dart';
import 'package:flutter_app/app/networking/api_service.dart';
import 'package:flutter_app/app/networking/movie_now_playing_api.dart';
import 'package:flutter_app/app/networking/movie_upcoming_api.dart';
import 'package:google_fonts/google_fonts.dart';

class Upcoming extends StatefulWidget {
  const Upcoming({super.key});

  @override
  State<Upcoming> createState() => _UpcomingState();
}

class _UpcomingState extends State<Upcoming> {
  late MovieUpcomingApi movieNowPlayingApi;
  List<dynamic> movies = [];
  @override
  void initState() {
    super.initState();
    movieNowPlayingApi = MovieUpcomingApi(ApiService());
    fetchMovies();
  }

  Future fetchMovies() async {
    try {
      var res = await movieNowPlayingApi.fetchUpcomingMovie();
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
                    crossAxisCount: 3,
                    childAspectRatio: 1 / 2,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 10),
                itemCount: movies.length,
                itemBuilder: ((context, index) {
                  print(movies[0]['poster_path']);
                  return Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w500${movies[index]['poster_path']}',
                            fit: BoxFit.cover,
                          ),
                        ),
                        Text(
                          movies[index]['title'],
                          style: GoogleFonts.oswald(),
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
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
