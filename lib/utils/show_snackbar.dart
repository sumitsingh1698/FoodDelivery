import 'package:flutter/material.dart';
import 'package:BellyDelivery/constants/Color.dart';
import 'package:BellyDelivery/constants/Style.dart';

class Utils {
  static showSnackBar(GlobalKey<ScaffoldState> scaffoldKey, String message) {
    scaffoldKey.currentState.removeCurrentSnackBar();
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      backgroundColor: blackColor,
      content: new Text(message ?? 'You are offline',
          style: CustomFontStyle.regularFormTextStyle(whiteColor)),
    ));
  }
}
