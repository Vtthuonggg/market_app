import 'package:flutter/material.dart';
import 'package:flutter_app/app/controllers/controller.dart';
import 'package:nylo_framework/nylo_framework.dart';

class RegisterPage extends NyStatefulWidget {
  final Controller controller = Controller();

  static const path = '/register_page';
  RegisterPage({Key? key}) : super(path, key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends NyState<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
