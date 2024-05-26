import 'package:flutter/material.dart';
import 'package:flutter_app/resources/pages/bottomnavi_page/actor_page.dart';
import 'package:flutter_app/resources/pages/bottomnavi_page/favorite_page.dart';
import 'package:flutter_app/resources/pages/bottomnavi_page/searching_page.dart';
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
    ActorPage(),
    FavoritePage(),
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
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Actor',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
        ],
      ),
    );
  }
}
