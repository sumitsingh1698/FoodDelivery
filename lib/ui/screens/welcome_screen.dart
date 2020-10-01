import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:BellyDelivery/constants/Color.dart';
import 'package:BellyDelivery/constants/String.dart';
import 'package:BellyDelivery/constants/Style.dart';
import 'package:BellyDelivery/ui/screens/login_page.dart';
import 'package:BellyDelivery/ui/screens/sign_up_page.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePage createState() => _WelcomePage();
}

class _WelcomePage extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    double screen_width = MediaQuery.of(context).size.width;
    double screen_height = MediaQuery.of(context).size.height;
    return new Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/welcome_background.jpg"),
                    fit: BoxFit.contain)),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: whiteColor,
                shape: BoxShape.rectangle,
              ),
              child: Container(
                width: double.infinity,
                height: screen_height * .30,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        titleWelcomeText,
                        style: CustomFontStyle.mediumTextStyle(blackColor),
                        textScaleFactor: 1.2,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: <Widget>[
                          _buildLoginButton(context),
                          Spacer(),
                          _buildSignUpButton(context)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildLoginButton(context) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => (LoginPage())),
      );
    },
    child: Container(
      decoration: BoxDecoration(
        color: blackColor,
        shape: BoxShape.rectangle,
      ),
      child: Container(
        width: 160,
        height: 50,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Center(
            child: Text(
              login,
              style: CustomFontStyle.buttonTextStyle(whiteBellyColor),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget _buildSignUpButton(context) {
  return InkWell(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SignupPage()),
      );
    },
    child: Container(
      decoration: BoxDecoration(
        color: blackBellyColor,
        shape: BoxShape.rectangle,
      ),
      child: Container(
        width: 160,
        height: 50,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Center(
            child: Text(
              signup,
              style: CustomFontStyle.buttonTextStyle(whiteBellyColor),
            ),
          ),
        ),
      ),
    ),
  );
}
