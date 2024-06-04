import 'package:flutter/material.dart';
import 'package:flutter_app/app/networking/api_service.dart';
import 'package:flutter_app/app/networking/searching_film_api.dart';

class SearchingPage extends StatefulWidget {
  const SearchingPage({Key? key}) : super(key: key);

  @override
  State<SearchingPage> createState() => _SearchingPageState();
}

class _SearchingPageState extends State<SearchingPage> {
  String? _selectedGenre;
  String? _selectedSort;
  final _apiService = ApiService();
  SearchingApi? _searchingApi;
  List<dynamic> movies = [];
  final Map<String, String> _genres = {
    'Hành động': '28',
    'Phiêu lưu': '12',
    'Hoạt hình': '16',
    'Hài': '35',
    'Tội phạm': '80',
    'Tài liệu': '99',
    'Kịch': '18',
    'Gia đình': '10751',
    'Huyền ảo': '14',
    'Lịch sử': '36',
    'Kinh dị': '27',
    'Âm nhạc': '10402',
    'Bí ẩn': '9648',
    'Lãng mạn': '10749',
    'Khoa học viễn tưởng': '878',
    'Phim truyền hình': '10770',
    'Hồi hộp': '53',
    'Chiến tranh': '10752',
    'Miền Tây': '37',
  };
  final Map<String, String> _sortOptions = {
    'Ngày phát hành': 'release_date.desc',
    'Xếp hạng': 'vote_average.desc',
  };
  @override
  void initState() {
    super.initState();
    _searchingApi = SearchingApi(_apiService);
  }

  Future<void> _fetchMovies() async {
    if (_selectedGenre != null && _selectedSort != null) {
      final res = await _searchingApi!
          .fetchMoviesWithGenner(_selectedGenre!, _selectedSort!);
      movies = res;
      print('MOVIES::: ');
      print(movies);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tìm kiếm phim'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: DropdownButton<String>(
                    value: _selectedGenre,
                    hint: const Text('Chọn thể loại'),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedGenre = newValue;
                      });
                    },
                    items: _genres.keys
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _selectedSort,
                  hint: const Text(
                    'Chọn sắp xếp',
                  ),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedSort = newValue;
                    });
                  },
                  items: _sortOptions.keys
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: _fetchMovies,
              child: Text(
                'Xác nhận',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
