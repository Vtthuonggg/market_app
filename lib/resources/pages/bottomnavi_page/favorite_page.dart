import 'package:flutter/material.dart';
import 'package:flutter_app/app/networking/api_service.dart';
import 'package:flutter_app/app/networking/favorite_api.dart';
import 'package:flutter_app/resources/pages/detail_film.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final _apiService = ApiService();
  List<dynamic> movies = [];
  bool _loading = false;
  @override
  void initState() {
    super.initState();
    getFavoriteMovies();
  }

  getFavoriteMovies() async {
    setState(() {
      _loading = true;
    });
    var res = await FavoriteApi(_apiService).getFavoriteMovies();
    movies = res;
    setState(() {
      _loading = false;
    });
    print('FAVORITE MOVIES::: ');
    print(movies);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _loading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            )
          : Scaffold(
              appBar: AppBar(
                title: Text('Phim yêu thích'),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1 / 2,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 10),
                  itemCount: movies.length,
                  itemBuilder: ((context, index) {
                    print(movies[0]['poster_path']);
                    return GestureDetector(
                      onTap: () {
                        print(movies[index]['id']);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailFilm(
                                    movieId: movies[index]['id'],
                                  )),
                        );
                      },
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
              ),
            ),
    );
  }
}
