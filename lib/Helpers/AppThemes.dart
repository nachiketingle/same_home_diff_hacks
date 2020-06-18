import 'package:flutter/material.dart';


class AppThemes {
  static final Color primaryColor = Colors.deepPurple;
  static final Color secondaryColor = Colors.deepPurple[50];
  static final Color buttonColor = Colors.blue;
  static final Color buttonTextColor = Colors.white;
  static final Color textColor = Colors.deepPurple[50];

  static TextStyle basicTextStyle() {
    return TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 25,
        color: AppThemes.textColor
    );
  }
}