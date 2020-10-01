import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:BellyDelivery/constants/Color.dart';
import 'package:BellyDelivery/constants/String.dart';
import 'package:BellyDelivery/data/authentication_data.dart';
import 'package:BellyDelivery/ui/widgets/custom_close_app_bar.dart';
import 'package:BellyDelivery/constants/Style.dart';
import 'package:BellyDelivery/utils/show_snackbar.dart';
import '../screens/otp_verification_password_reset.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPage createState() => _ForgotPasswordPage();
}

class _ForgotPasswordPage extends State<ForgotPasswordPage> {
  TextEditingController _phoneController = new TextEditingController();

  bool _loader = false;
  bool validPhoneFlag = false;
  bool otpSentFlag = false;
  final _key = new GlobalKey<ScaffoldState>();
  AuthDataSource authData = new AuthDataSource();

  _handlePhoneVerification() async {
    setState(() {
      _loader = true;
    });
    otpSentFlag = await authData.sendOtpCode(
        _phoneController.text.substring(_phoneController.text.length - 10));
    if (otpSentFlag) {
      _loader = false;
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => OtpPasswordResetPage(
                  phone: _phoneController.text
                      .substring(_phoneController.text.length - 10),
                )),
      );
    } else {
      setState(() {
        _loader = false;
      });
      Utils.showSnackBar(_key, invalidPhoneNumber);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _key,
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      appBar: CustomCloseAppBar(title: ""),
      body: (_loader)
          ? Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
              ),
            )
          : Stack(
              children: <Widget>[
                _buildAuthenticationUi(context),
              ],
            ),
      bottomNavigationBar: _buildBottomButton(context),
    );
  }

  Widget _buildAuthenticationUi(context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Text(
              forgotPassword,
              style: CustomFontStyle.mediumTextStyle(greenColor),
              textScaleFactor: 1.2,
            ),
          ),
          SizedBox(height: 60),
          Text(
            pleaseEnterPhoneNumber,
            style: CustomFontStyle.mediumTextStyle(blackColor),
            textScaleFactor: 1.2,
          ),
          SizedBox(height: 30),
          Container(
            width: 400,
            decoration: BoxDecoration(
                color: cloudsColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                )),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: TextFormField(
                validator: validateMobile,
                controller: _phoneController,
                style: CustomFontStyle.regularFormTextStyle(blackColor),
                keyboardType: TextInputType.phone,
                decoration:
                    new InputDecoration.collapsed(hintText: phoneNumber),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(context) {
    return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: InkWell(
          onTap: () {
            _handlePhoneVerification();
          },
          child: Container(
            decoration: BoxDecoration(
              color: blackColor,
              shape: BoxShape.rectangle,
            ),
            child: Container(
              width: double.infinity,
              height: 50,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Center(
                  child: Text(
                    send,
                    style: CustomFontStyle.bottomButtonTextStyle(whiteColor),
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  String validateMobile(String value) {
    String pattern = r'(^[0-9]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return noEmptyFields;
    } else if (value.length != 11) {
      return phoneShouldbe10Digits;
    } else if (!regExp.hasMatch(value)) {
      return "Invalid phone number";
    }
    return null;
  }
}
