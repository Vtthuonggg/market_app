import 'package:flutter/material.dart';

class GradientAppBar extends AppBar {
  GradientAppBar({
    Key? key,
    required Widget title,
    Widget? leading,
    List<Widget>? actions,
  }) : super(
          key: key,
          title: title,
          leading: leading,
          actions: actions,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xfff4a261), Color(0xffffc52d)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        );
}
