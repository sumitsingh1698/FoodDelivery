import 'package:flutter/material.dart';

class CustomFontStyle {
  static TextStyle RegularTextStyle(Color color) {
    return TextStyle(
        color: color,
        fontWeight: FontWeight.w100,
        fontFamily: 'NotoSansJP',
        fontSize: 14.0);
  }

  static TextStyle mediumTextStyle(Color color) {
    return TextStyle(
      color: color,
      fontWeight: FontWeight.w400,
      fontFamily: 'NotoSansJP',
      fontSize: 15.0,
    );
  }
  static TextStyle pageTitleTextStyle(Color color) {
    return TextStyle(
      color: color,
      fontWeight: FontWeight.w500,
      fontFamily: 'NotoSansJP',
      fontSize: 15.0,
    );
  }

  static TextStyle regularBoldTextStyle(Color color) {
    return TextStyle(
      color: color,
      fontWeight: FontWeight.w500,
      fontFamily: 'NotoSansJP',
      fontSize: 18.0,
    );
  }

  static TextStyle mediumBoldTextStyle(Color color) {
    return TextStyle(
      color: color,
      fontWeight: FontWeight.w600,
      fontFamily: 'NotoSansJP',
      fontSize: 20.0,
    );
  }

  static TextStyle MediumHeadingStyle(Color color) {
    return TextStyle(
        color: color,
        fontWeight: FontWeight.w600,
        fontFamily: 'NotoSansJP',
        fontSize: 30.0);
  }

  static TextStyle regularFormTextStyle(Color color) {
    return TextStyle(
      color: color,
      fontWeight: FontWeight.w400,
      fontFamily: 'NotoSansJP',
      fontSize: 15.0,
    );
  }

  static TextStyle Medium4TextStyle(Color color) {
    return TextStyle(
        color: color,
        fontWeight: FontWeight.w200,
        fontFamily: 'NotoSansJP',
        fontSize: 50.0);
  }

  static TextStyle buttonTextStyle(Color color) {
    return TextStyle(
        color: color,
        fontWeight: FontWeight.w500,
        fontFamily: 'NotoSansJP',
        fontSize: 18.0);
  }

  static TextStyle bottomButtonTextStyle(Color color) {
    return TextStyle(
        color: color,
        fontWeight: FontWeight.w500,
        fontFamily: 'NotoSansJP',
        fontSize: 16.0);
  }

  static TextStyle smallTextStyle(Color color) {
    return TextStyle(
      color: color,
      fontWeight: FontWeight.w500,
      fontFamily: 'NotoSansJP',
      fontSize: 12.0,
    );
  }
}
