import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomToast {
  static void showToast(
    String message, {
    ToastGravity gravity = ToastGravity.TOP,
    Color backgroundColor = Colors.black87,
    Color textColor = Colors.white,
    double fontSize = 16.0,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: fontSize,
    );
    Future.delayed(Duration(milliseconds: 1000), () {
      Fluttertoast.cancel();
    });
  }

  static void showToastSuccess({required String description}) {
    showToast(description, backgroundColor: Colors.green);
  }

  static void showToastWarning({required String description}) {
    showToast(description, backgroundColor: Colors.red);
  }

  static void showToastOops({required String description}) {
    showToast(description, backgroundColor: Colors.red);
  }

  static void showToastInfo({required String description}) {
    showToast(description, backgroundColor: Colors.red);
  }

  static void showToastDanger({required String description}) {
    showToast(description, backgroundColor: Colors.red);
  }

  static void showToastCustom({required String description}) {
    showToast(description, backgroundColor: Colors.red);
  }

  static void showToastSorry({required String description}) {
    showToast(description, backgroundColor: Colors.red);
  }

  static void showToastNotification({required String description}) {
    showToast(description, backgroundColor: Colors.red);
  }
}
