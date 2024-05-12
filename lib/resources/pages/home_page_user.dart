import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePageUser extends StatefulWidget {
  String username;
  HomePageUser({Key? key, required this.username}) : super(key: key);

  @override
  State<HomePageUser> createState() => _HomePageUserState();
}

class _HomePageUserState extends State<HomePageUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Icon(
                  Icons.person_2_outlined,
                  color: Colors.blue,
                  size: 20,
                ),
                Text(
                  'MEMBER',
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
                SizedBox(width: 20),
                Icon(Icons.star_border_rounded, color: Colors.green),
                Text(
                  '0',
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(width: 20),
                Icon(
                  FontAwesomeIcons.ticket,
                  color: Colors.orange,
                  size: 15,
                ),
                SizedBox(width: 10),
                Text('0',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Icon(Icons.shape_line),
          )
        ],
      ),
      body: Center(
        child: Text('Trang chủ người dùng'),
      ),
    );
  }
}
