import 'package:flutter/material.dart';
import 'package:flutter_app/resources/widgets/gradient_appbar.dart';

class DashboardPage extends StatefulWidget {
  static const path = '/dashboard_page';

  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
          title: Text(
        'Bate - Mua bán trực tuyến',
        style: TextStyle(fontWeight: FontWeight.bold),
      )),
    );
  }
}
