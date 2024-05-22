import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/app/networking/api_service.dart';
import 'package:flutter_app/app/networking/detail_film_api.dart';
import 'package:flutter_app/resources/pages/book_ticker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DetailFilm extends StatefulWidget {
  final int movieId;
  const DetailFilm({Key? key, required this.movieId}) : super(key: key);

  @override
  State<DetailFilm> createState() => _DetailFilmState();
}

class _DetailFilmState extends State<DetailFilm> {
  Map<String, dynamic> detail = {};
  Map<String, dynamic> video = {};
  late MovieDetailApi movieDetailApi;
  final _apiService = ApiService();
  bool _loading = false;
  bool _showFullText = false;

  @override
  void initState() {
    super.initState();
    movieDetailApi = MovieDetailApi(_apiService, movieId: widget.movieId);
    fetchDetail();
    getVideo();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchDetail() async {
    setState(() {
      _loading = true;
    });
    try {
      var res = await movieDetailApi.fetchMovieDetail(widget.movieId);
      detail = res;
      print("DETAIL:${widget.movieId}:: $detail");
    } catch (e) {
      print('Lỗi detail: $e');
      detail = {};
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> getVideo() async {
    setState(() {
      _loading = true;
    });
    try {
      var res = await movieDetailApi.getTrailer(widget.movieId);
      if (res['results'][0] != null || (res['results'][0].isNotEmpty)) {
        video = res['results'][0];
      }
      print("link trailer: $video");
    } catch (e) {
      print('Lỗi video: $e');
      video = {};
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  String limitWords(String text, int limit) {
    List<String> words = text.split(' ');
    if (words.length <= limit) {
      return text;
    } else {
      return words.take(limit).join(' ') + '...';
    }
  }

  String formatDate(String date) {
    try {
      final inputFormat = DateFormat('yyyy-MM-dd', 'vi_VN');
      final inputDate = inputFormat.parseStrict(date);

      final outputFormat = DateFormat('dd/MM/yyyy', 'vi_VN');
      return outputFormat.format(inputDate);
    } catch (e) {
      print('Unable to parse date: $date');
      return date;
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double? voteAverage = detail['vote_average'];
    double? voteRatio = voteAverage != null ? voteAverage / 10.0 : null;
    Color progressColor = Colors.grey;

    if (voteAverage != null) {
      if (voteAverage < 5) {
        progressColor = Colors.red;
      } else if (voteAverage < 8) {
        progressColor = Colors.yellow;
      } else {
        progressColor = Colors.green;
      }
    }
    String? videoKey = video['key'].toString(); // replace with your video key

    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: videoKey,
      flags: YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết phim'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: _loading
              ? Center(
                  child: CircularProgressIndicator(
                  color: Colors.blue,
                ))
              : Column(
                  children: [
                    Container(
                      width: width,
                      child: Image.network(
                        detail['backdrop_path'] != null
                            ? 'https://image.tmdb.org/t/p/w780${detail['backdrop_path']}'
                            : 'https://via.placeholder.com/150',
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text(
                            detail['title'] ?? '',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Mô tả phim:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              detail['overview'] == null ||
                                      detail['overview'].isEmpty
                                  ? 'Tạm thời chưa có mô tả'
                                  : _showFullText
                                      ? detail['overview']
                                      : limitWords(detail['overview'], 50),
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                          if ((detail['overview'] ?? '').split(' ').length > 50)
                            TextButton(
                              child: Text(
                                _showFullText ? "Thu gọn" : "Xem thêm",
                                style: TextStyle(color: Colors.blue),
                                textAlign: TextAlign.justify,
                              ),
                              style: ButtonStyle(
                                overlayColor: MaterialStateProperty.resolveWith(
                                    (states) => Colors.transparent),
                              ),
                              onPressed: () {
                                setState(() {
                                  _showFullText = !_showFullText;
                                });
                              },
                            ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                child: Image.asset(
                                  'public/assets/images/date.png',
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(formatDate(
                                detail['release_date'] ?? '',
                              )),
                              SizedBox(width: 20),
                              Container(
                                width: 20,
                                height: 20,
                                child: Image.asset(
                                  'public/assets/images/clock.png',
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                detail['runtime'] == 0
                                    ? "Chưa rõ"
                                    : " ${detail['runtime']} phút",
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                'Đánh giá:',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(width: 10),
                              SizedBox(
                                width: 30,
                                height: 30,
                                child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        strokeWidth: 5,
                                        value: voteRatio,
                                        backgroundColor: Colors.grey[200],
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                progressColor),
                                      ),
                                      Text(
                                        voteAverage?.toStringAsFixed(1) ?? '',
                                        style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ]),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text("Trailer:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 10),
                          video['key'] == null
                              ? Text("Tạm thời chưa cập nhật")
                              : YoutubePlayer(
                                  controller: _controller,
                                  showVideoProgressIndicator: true,
                                  progressColors: ProgressBarColors(
                                    playedColor: Colors.amber,
                                    handleColor: Colors.amberAccent,
                                  ),
                                ),
                          SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: height / 16,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 0, 90, 164),
                Color.fromARGB(255, 139, 203, 255)
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BookTicket(
                            film: detail,
                          )),
                );
              },
              child: Text('ĐẶT VÉ',
                  style:
                      GoogleFonts.oswald(fontSize: 20, color: Colors.white))),
        ),
      ),
    );
  }
}
