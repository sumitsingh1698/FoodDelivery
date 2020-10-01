import 'package:flutter/material.dart';
import 'package:BellyDelivery/constants/Color.dart';
import 'package:BellyDelivery/constants/Style.dart';
import 'package:BellyDelivery/utils/app_config.dart';

Future<dynamic> showOtherNotificationDialog(
    BuildContext context, Map<String, dynamic> message) {
  return showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
      child: SingleChildScrollView(
        child: Container(
          color: whiteColor,
          width: 327.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      message['aps']['alert'] != null
                          ? message['aps']['alert']['title']
                          : "",
                      style: CustomFontStyle.mediumBoldTextStyle(blackColor),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                  message['aps']['alert']['body'],
                  style: CustomFontStyle.regularBoldTextStyle(blackColor),
                ),
              ),
              Padding(padding: EdgeInsets.only(top: 50.0)),
              Container(
                height: 1,
                color: cloudsColor,
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
                      "OK",
                      style: CustomFontStyle.buttonTextStyle(whiteColor),
                    )),
              )
            ],
          ),
        ),
      ),
    ),
  );
}
