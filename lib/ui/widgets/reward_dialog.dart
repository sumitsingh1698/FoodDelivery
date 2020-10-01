import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:BellyDelivery/constants/Color.dart';
import 'package:BellyDelivery/constants/Style.dart';
import 'package:BellyDelivery/ui/screens/home_screen.dart';

Future<dynamic> showRewardDialog(BuildContext context, int reward) {
  return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => _buildDialog(context, reward));
}

Widget _buildDialog(context, int _reward) {
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
            Text(
              "₹ " + _reward.toString(),
              style: CustomFontStyle.MediumHeadingStyle(blackColor),
            ),
            Padding(padding: EdgeInsets.only(top: 10.0, bottom: 20)),
            Text(
              "thank you for your hard work!\n Added to sales.",
              textAlign: TextAlign.center,
              style: CustomFontStyle.regularFormTextStyle(blackColor),
            ),
            Container(
              height: 70,
            ),
            Container(
              width: double.infinity,
              color: blackColor,
              child: FlatButton(
                  color: blackColor,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    );
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
