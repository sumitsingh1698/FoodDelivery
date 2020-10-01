import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:BellyDelivery/constants/Color.dart';
import 'package:BellyDelivery/constants/Style.dart';
import 'package:BellyDelivery/ui/screens/home_screen.dart';

Future<dynamic> showTrackingDialog(BuildContext context) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => _buildDialog(context));
}

Widget _buildDialog(context) {
  return Dialog(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0)), //this right here
    child: SingleChildScrollView(
      child: Container(
        width: 360.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.location_on,
                    color: blackColor,
                    size: 40,
                  ),
                ),
                Expanded(
                  child: Text(
                    "Share location information",
                    style: CustomFontStyle.mediumBoldTextStyle(blackColor),
                  ),
                ),
              ],
            ),
            Padding(padding: EdgeInsets.only(top: 10.0, bottom: 20)),
            Text(
              "Location information is shared with users until delivery is complete",
              textAlign: TextAlign.center,
              style: CustomFontStyle.regularFormTextStyle(blackColor),
            ),
            Container(
              height: 50,
            ),
            Container(
              width: double.infinity,
              color: blackColor,
              child: FlatButton(
                  color: blackColor,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Return",
                    style: CustomFontStyle.buttonTextStyle(whiteColor),
                  )),
            )
          ],
        ),
      ),
    ),
  );
}
