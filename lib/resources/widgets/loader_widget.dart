import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({super.key});

  @override
  Widget build(BuildContext context) {
    switch (Theme.of(context).platform) {
      case TargetPlatform.android:
        return const Center(
            child: CircularProgressIndicator(
          color: Colors.blue,
        ));
      case TargetPlatform.iOS:
        return const Center(
            child: CupertinoActivityIndicator(color: Colors.blue));
      default:
        return const Center(
            child: CircularProgressIndicator(color: Colors.blue));
    }
  }
}
