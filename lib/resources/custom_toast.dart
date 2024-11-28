import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomToast {
  static bool _isShowing = false;
  static void showToast(
    BuildContext context,
    String message, {
    IconData? icon,
    ToastGravity gravity = ToastGravity.TOP,
    Color backgroundColor = const Color.fromRGBO(255, 255, 255, 1),
    Color textColor = Colors.black,
    Color iconColor = Colors.black,
    double fontSize = 16.0,
    Duration duration = const Duration(milliseconds: 1200),
    Color borderColor = Colors.transparent,
  }) {
    if (_isShowing) return;

    _isShowing = true;
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50.0,
        left: 0,
        right: 0,
        child: Center(
          child: IntrinsicWidth(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: borderColor),
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black45,
                        blurRadius: 20.0,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, color: iconColor),
                      SizedBox(width: 10.0),
                      Expanded(
                        child: AnimatedSwitcher(
                          duration: Duration(milliseconds: 800),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            return ScaleTransition(
                                child: child, scale: animation);
                          },
                          child: Text(
                            message,
                            style: TextStyle(
                              color: textColor,
                              fontSize: fontSize,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);
    Future.delayed(duration, () {
      overlayEntry.remove();
      _isShowing = false;
    });
  }

  static void showToastSuccess(BuildContext context,
      {required String description}) {
    showToast(
      context,
      description,
      textColor: Colors.green[900]!,
      icon: Icons.check_circle_outline_rounded,
      iconColor: Colors.green,
    );
  }

  static void showToastWarning(BuildContext context,
      {required String description}) {
    showToast(context, description,
        icon: Icons.warning,
        textColor: Colors.white,
        iconColor: Colors.white,
        backgroundColor: Color(0xffEB5757));
  }

  // static void showToastFail(BuildContext context,
  //     {required String description}) {
  //   showToast(context, description,
  //       icon: Icons.info_outline,
  //       textColor: Colors.white,
  //       iconColor: Colors.white,
  //       backgroundColor: Color(0xffF2C94C));
  // }
}
