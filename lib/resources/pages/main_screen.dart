import 'package:flutter/material.dart';
import 'package:flutter_app/app/controllers/controller.dart';
import 'package:nylo_framework/nylo_framework.dart';

class MainScreen extends NyStatefulWidget {
  final Controller controller = Controller();
  static const path = '/main_screen';
  MainScreen({Key? key}) : super(path, key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends NyState<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
