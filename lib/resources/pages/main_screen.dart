import 'package:flutter/material.dart';
import 'package:flutter_app/resources/pages/bottomnavi_page/actor_page.dart';
import 'package:flutter_app/resources/pages/bottomnavi_page/favorite_page.dart';
import 'package:flutter_app/resources/pages/bottomnavi_page/searching_page.dart';
import 'package:flutter_app/resources/pages/bottomnavi_page/setting.dart';
import 'package:flutter_app/resources/pages/home_page_user.dart';

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);
  static const String path = '/main_screen';
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    HomePageUser(),
    SearchingPage(),
    FavoritePage(),
    SettingPage(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.grey[100],
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Color(0xffA1AAB9),
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          selectedIconTheme: IconThemeData(size: 30),
          selectedLabelStyle:
              TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Trang chủ',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Tìm kiếm',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Yêu thích',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Cài đặt',
            ),
          ],
        ),
      ),
    );
  }
}
