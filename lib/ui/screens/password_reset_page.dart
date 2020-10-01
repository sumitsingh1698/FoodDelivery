import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:BellyDelivery/constants/Color.dart';
import 'package:BellyDelivery/constants/String.dart';
import 'package:BellyDelivery/data/authentication_data.dart';
import 'package:BellyDelivery/ui/widgets/custom_close_app_bar.dart';
import 'package:BellyDelivery/constants/Style.dart';
import 'login_page.dart';

class PasswordResetPage extends StatefulWidget {
  final String phone;

  const PasswordResetPage({
    Key key,
    @required this.phone,
  }) : super(key: key);

  @override
  _PasswordResetPageState createState() => _PasswordResetPageState();
}

class _PasswordResetPageState extends State<PasswordResetPage> {
  TextEditingController _passwordController = new TextEditingController();
  bool resetSucessFlag = false;
  final _key = new GlobalKey<ScaffoldState>();
  var passKey = GlobalKey<FormFieldState>();
  GlobalKey<FormState> _formKey = new GlobalKey();
  bool _validate = false;
  AuthDataSource authData = new AuthDataSource();

  _handlePasswordReset() async {
    resetSucessFlag =
        await authData.resetPassword(widget.phone, _passwordController.text);
    if (resetSucessFlag) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      _showSnackBar(errorText);
    }
  }

  _showSnackBar(text) {
    _key.currentState.showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: mainColor,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _key,
      backgroundColor: Colors.white,
      resizeToAvoidBottomPadding: false,
      appBar: CustomCloseAppBar(title: resetting_password),
      body: Stack(
        children: <Widget>[
          _buildAuthenticationUi(context),
        ],
      ),
      bottomNavigationBar: _buildBottomButton(context),
    );
  }

  Widget _buildAuthenticationUi(context) {
    return Form(
      key: _formKey,
      autovalidate: _validate,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 26),
            Text(
              enter_new_password,
              style: CustomFontStyle.mediumTextStyle(blackColor),
            ),
            SizedBox(height: 50),
            Container(
              width: 400,
              decoration: BoxDecoration(
                  color: formBgColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  )),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: TextFormField(
                  style: CustomFontStyle.regularFormTextStyle(blackColor),
                  keyboardType: TextInputType.text,
                  decoration: new InputDecoration.collapsed(hintText: password),
                  key: passKey,
                  obscureText: true,
                  controller: _passwordController,
                  validator: (password) {
                    String pattern =
                        r'^(?=.*[a-zA-Z])(?=.*\d)[A-Za-z\d!@#$%^&*()_+]{8,20}';
                    RegExp regExp = new RegExp(pattern);
                    if (password.length == 0) {
                      return noEmptyFields;
                    } else if (!regExp.hasMatch(password)) {
                      return passwordShould8digits;
                    } else {
                      return null;
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 30),
            Container(
              width: 400,
              decoration: BoxDecoration(
                  color: formBgColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  )),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: TextFormField(
                  obscureText: true,
                  style: CustomFontStyle.regularFormTextStyle(blackColor),
                  keyboardType: TextInputType.text,
                  decoration:
                      new InputDecoration.collapsed(hintText: confirmPassword),
                  validator: (confirmation) {
                    var password = passKey.currentState.value;
                    return (confirmation == password)
                        ? null
                        : passwordDoNotMatch;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton(context) {
    return InkWell(
      onTap: () {
        if (_formKey.currentState.validate()) {
          _handlePasswordReset();
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color:blackBellyColor,
          shape: BoxShape.rectangle,
        ),
        child: Container(
          width: double.infinity,
          height: 50,
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Center(
              child: Text(
                set,
                style: CustomFontStyle.bottomButtonTextStyle(greenBellyColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
