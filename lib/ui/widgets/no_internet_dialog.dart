import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:BellyDelivery/constants/Color.dart';
import 'package:BellyDelivery/constants/String.dart';
import 'package:BellyDelivery/constants/Style.dart';

Future<dynamic> showDialogNoInternet(BuildContext context) {
  return showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) => _buildNoInternetDialog(context));
}

Widget _buildNoInternetDialog(context) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: CupertinoActionSheet(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Expanded(
              child: Text(
                networkError,
                style: CustomFontStyle.regularBoldTextStyle(blackColor),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
        message: Text(
          networkError2,
          textAlign: TextAlign.left,
          style: CustomFontStyle.smallTextStyle(blackColor),
        ),
      ),
    ),
  );
}
