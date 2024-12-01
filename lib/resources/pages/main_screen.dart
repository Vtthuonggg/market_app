// lib/main_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_app/resources/widgets/gradient_appbar.dart';

class MainScreen extends StatefulWidget {
  static const path = '/main_screen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: GradientAppBar(
          title: Text(
            'Bate - Mua bán trực tuyến',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Center());
  }
}
