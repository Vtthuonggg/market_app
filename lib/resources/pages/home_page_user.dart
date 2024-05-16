import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/resources/pages/headers/now_playing.dart';
import 'package:flutter_app/resources/pages/headers/upcoming.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePageUser extends StatefulWidget {
  String username;
  HomePageUser({Key? key, required this.username}) : super(key: key);

  @override
  State<HomePageUser> createState() => _HomePageUserState();
}

class _HomePageUserState extends State<HomePageUser> {
  List<String> images = [
    'public/assets/images/page_view/page1.png',
    'public/assets/images/page_view/page2.png',
    'public/assets/images/page_view/page3.jpg',
  ];
  late PageController _pageController;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      int nextPage = (_pageController.page!.toInt() + 1);
      _pageController.animateToPage(nextPage,
          duration: Duration(milliseconds: 800), curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  text: 'Chào ',
                  style: TextStyle(fontSize: 15),
                  children: <TextSpan>[
                    TextSpan(
                      text: '${widget.username}',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Icon(
                    Icons.person_2_outlined,
                    color: Colors.blue,
                    size: 16,
                  ),
                  Text(
                    'MEMBER',
                    style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 13),
                  ),
                  SizedBox(width: 20),
                  Icon(
                    Icons.star_border_rounded,
                    color: Colors.green,
                    size: 14,
                  ),
                  Text(
                    '0',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 20),
                  Icon(
                    FontAwesomeIcons.ticket,
                    color: Colors.orange,
                    size: 14,
                  ),
                  SizedBox(width: 10),
                  Text('0',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Container(
                  width: 70,
                  child: Image.asset(
                    'public/assets/images/logo_action.png',
                    scale: 0.2,
                  )),
            )
          ],
          bottom: TabBar(
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Colors.transparent,
            tabs: [
              Tab(text: 'SẮP CHIẾU'),
              Tab(text: 'ĐANG CHIẾU'),
            ],
            labelStyle:
                GoogleFonts.oswald(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: Column(
                children: [
                  Container(
                    height: 150,
                    child: PageView.builder(
                      itemCount: null,
                      controller: _pageController,
                      itemBuilder: (BuildContext context, int index) {
                        return Image.asset(images[index % images.length]);
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: TabBarView(
                      children: [
                        Upcoming(), // Nội dung của tab 'Sắp Chiếu'
                        NowPlaying(), // Nội dung của tab 'Đang Chiếu'
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
