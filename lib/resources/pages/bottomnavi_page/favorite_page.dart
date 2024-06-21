import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/app/networking/api_service.dart';
import 'package:flutter_app/app/networking/favorite_api.dart';
import 'package:flutter_app/resources/pages/detail_film.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final _apiService = ApiService();
  List<dynamic> movies = [];
  bool favorite = false;
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
  }

  Future<void> cancelFavorite(int id) async {
    try {
      await FavoriteApi(_apiService)
          .addFavoriteMovie(movieId: id, isFavorite: favorite);
      setState(() {
        movies.removeWhere((movie) => movie['id'] == id);
      });
    } catch (e) {
      print('Lỗi toggling favorite: $e');
    }
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
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: movies.length,
                    itemBuilder: ((context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Slidable(
                          key: ValueKey(context),
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          secondaryActions: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: IconSlideAction(
                                color: Colors.transparent,
                                icon: Icons.heart_broken_outlined,
                                foregroundColor: Colors.white,
                                onTap: () async {
                                  cancelFavorite(movies[index]['id']);
                                },
                                closeOnTap: true,
                              ),
                            )
                          ],
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DetailFilm(
                                          movieId: movies[index]['id'],
                                        )),
                              );
                            },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 150,
                                  height: 80,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.network(
                                      'https://image.tmdb.org/t/p/w500${movies[index]['backdrop_path']}',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    movies[index]['title'],
                                    style: GoogleFonts.oswald(),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ));
  }
}
