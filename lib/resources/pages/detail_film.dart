import 'package:flutter/material.dart';
import 'package:flutter_app/app/networking/api_service.dart';
import 'package:flutter_app/app/networking/detail_film_api.dart';

class DetailFilm extends StatefulWidget {
  final int movieId;
  const DetailFilm({Key? key, required this.movieId}) : super(key: key);

  @override
  State<DetailFilm> createState() => _DetailFilmState();
}

class _DetailFilmState extends State<DetailFilm> {
  Map<String, dynamic> detail = {};
  late MovieDetailApi movieDetailApi;
  final _apiService = ApiService();
  @override
  void initState() {
    super.initState();
    movieDetailApi = MovieDetailApi(_apiService, movieId: widget.movieId);
    fetchDetail();
  }

  Future fetchDetail() async {
    try {
      var res = await movieDetailApi.fetchMovieDetail(widget.movieId);
      detail = res;
      print("DETAIL:${widget.movieId}:: $detail");
    } catch (e) {
      print('Lỗi: $e');
      detail = {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phim'),
      ),
      body: Padding(
          padding: EdgeInsets.all(10),
          child: FutureBuilder(
            future: fetchDetail(), // Gọi API
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                  ),
                ); // Hiển thị spinner khi đang tải
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}'); // Hiển thị lỗi nếu có
              } else {
                // Cập nhật UI khi dữ liệu đã sẵn sàng
                return Column(
                  children: [
                    if (snapshot.data == null)
                      CircularProgressIndicator()
                    else
                      Image.network(
                          'https://image.tmdb.org/t/p/w780${snapshot.data['backdrop_path']}'),
                    if (snapshot.data == null) CircularProgressIndicator(),
                    if (snapshot.data['overview'] == null)
                      Center(
                        child: CircularProgressIndicator(
                          color: Colors.blue,
                        ),
                      )
                    else if (snapshot.data['overview'].isEmpty)
                      Text("Tạm thời chưa có mô tả")
                    else
                      Text(snapshot.data['overview']),
                  ],
                );
              }
            },
          )),
    );
  }
}
