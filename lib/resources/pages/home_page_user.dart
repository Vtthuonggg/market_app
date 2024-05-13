import 'package:flutter/material.dart';
import 'package:flutter_app/resources/pages/headers/chieu_som.dart';
import 'package:flutter_app/resources/pages/headers/dan_chieu.dart';
import 'package:flutter_app/resources/pages/headers/sap_chieu.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_app/resources/pages/headers/sap_chieu.dart';

class HomePageUser extends StatefulWidget {
  String username;
  HomePageUser({Key? key, required this.username}) : super(key: key);

  @override
  State<HomePageUser> createState() => _HomePageUserState();
}

class _HomePageUserState extends State<HomePageUser> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Số lượng tab
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
              Tab(text: 'SUẤT CHIẾU SỚM'),
            ],
            labelStyle:
                GoogleFonts.oswald(fontSize: 15, fontWeight: FontWeight.bold),
          ),
        ),
        body: TabBarView(
          children: [
            BecomingFilms(), // Nội dung của tab 'Sắp Chiếu'
            NowShowing(), // Nội dung của tab 'Đang Chiếu'
            ComingSoon(), // Nội dung của tab 'Sắp Tới'
          ],
        ),
      ),
    );
  }
}
