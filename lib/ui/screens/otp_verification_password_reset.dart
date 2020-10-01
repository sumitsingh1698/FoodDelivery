import 'package:flutter/material.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:BellyDelivery/Constants/Color.dart';
import 'package:BellyDelivery/constants/Style.dart';
import 'package:BellyDelivery/constants/String.dart';
import 'package:BellyDelivery/data/authentication_data.dart';
import 'package:BellyDelivery/ui/screens/home_screen.dart';
import 'package:BellyDelivery/ui/screens/password_reset_page.dart';
import 'package:BellyDelivery/ui/widgets/custom_close_app_bar.dart';
import 'package:BellyDelivery/utils/app_config.dart';

class OtpPasswordResetPage extends StatefulWidget {
  final String phone;

  const OtpPasswordResetPage({
    Key key,
    @required this.phone,
  }) : super(key: key);

  @override
  _OtpState createState() => new _OtpState();
}

class _OtpState extends State<OtpPasswordResetPage>
    with SingleTickerProviderStateMixin {
  // Constants
  final int time = 30;
  AnimationController _controller;
  TextEditingController controller = TextEditingController();
  String thisText = "";
  int pinLength = 4;

  bool hasError = false;
  String errorMessage;

  int totalTimeInSeconds;
  bool _hideResendButton;

  AuthDataSource authData = new AuthDataSource();
  bool otpCorrectFlag = false;
  bool otpResentFlag = false;

  final _key = new GlobalKey<ScaffoldState>();

  AppConfig _screenConfig;

  _showSnackBar(text) {
    _key.currentState.showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: mainColor,
    ));
  }

  _handleOTPVerification(String otp) async {
    otpCorrectFlag = await authData.verifyOtpCode(widget.phone, otp);
    if (otpCorrectFlag) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PasswordResetPage(
                  phone: widget.phone,
                )),
      );
    } else
      _showSnackBar(invalidCode);
  }

  _handleResendOtp() async {
    otpResentFlag = await authData.sendOtpCode(widget.phone);
    if (otpResentFlag) {
      _showSnackBar(invalidPhoneNumber);
    }
  }

  @override
  void initState() {
    totalTimeInSeconds = time;
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: time))
          ..addStatusListener((status) {
            if (status == AnimationStatus.dismissed) {
              setState(() {
                _hideResendButton = !_hideResendButton;
              });
            }
          });
    _controller.reverse(
        from: _controller.value == 0.0 ? 1.0 : _controller.value);
    _startCountdown();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _screenConfig = AppConfig(context);
    return new Scaffold(
      key: _key,
      appBar: CustomCloseAppBar(
        title: resetting_password,
      ),
      backgroundColor: Colors.white,
      body: _getInputPart,
    );
  }

  get _getInputPart {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
            left: _screenConfig.rW(10), right: _screenConfig.rW(10)),
        child: Column(
          //mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: _screenConfig.rH(4)),
            _getVerificationCodeLabel,
            SizedBox(height: _screenConfig.rH(10)),
            _getInputField(),
            SizedBox(height: _screenConfig.rH(4)),
            _getResendButton,
          ],
        ),
      ),
    );
  }

  get _getVerificationCodeLabel {
    return new Text(enter_passcode,
        textAlign: TextAlign.left,
        style: CustomFontStyle.regularFormTextStyle(blackColor));
  }

  Widget _getInputField() {
    return Container(
      child: Padding(
        padding: EdgeInsets.only(left: _screenConfig.rW(10)),
        child: PinCodeTextField(
          pinBoxWidth: _screenConfig.rW(12),
          pinBoxOuterPadding:
              EdgeInsets.symmetric(horizontal: _screenConfig.rW(2)),
          autofocus: false,
          controller: controller,
          hideCharacter: false,
          defaultBorderColor: disabledGrey,
          hasTextBorderColor: blackColor,
          maxLength: pinLength,
          hasError: hasError,
          onTextChanged: (text) {
            setState(() {
              hasError = false;
            });
          },
          onDone: (text) {
            _handleOTPVerification(text);
          },
          wrapAlignment: WrapAlignment.start,
          pinBoxDecoration: ProvidedPinBoxDecoration.underlinedPinBoxDecoration,
          pinTextStyle: TextStyle(fontSize: 20.0),
          pinTextAnimatedSwitcherTransition:
              ProvidedPinBoxTextAnimation.scalingTransition,
          pinTextAnimatedSwitcherDuration: Duration(milliseconds: 300),
        ),
      ),
    );
  }

  get _getResendButton {
    return new Center(
        child: InkWell(
      child: Padding(
        padding: EdgeInsets.all(_screenConfig.rH(2)),
        child: new Container(
          alignment: Alignment.center,
          child: new Text(
            resend_passcode,
            style: CustomFontStyle.smallTextStyle(blueColor),
          ),
        ),
      ),
      onTap: () {
        _handleResendOtp();
      },
    ));
  }

  Future<Null> _startCountdown() async {
    setState(() {
      _hideResendButton = true;
      totalTimeInSeconds = time;
    });
    _controller.reverse(
        from: _controller.value == 0.0 ? 1.0 : _controller.value);
  }
}
