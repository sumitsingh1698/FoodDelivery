import 'package:flutter/material.dart';
import 'package:BellyDelivery/constants/String.dart';
import 'dart:ui';
import 'package:BellyDelivery/constants/Color.dart';
import 'package:BellyDelivery/constants/Style.dart';
import 'package:BellyDelivery/data/authentication_data.dart';
import 'package:BellyDelivery/data/location_list_data.dart';
import 'package:BellyDelivery/models/campus_model.dart';
import 'package:BellyDelivery/models/university_model.dart';
import 'package:BellyDelivery/models/user_signup_model.dart';
import 'package:BellyDelivery/ui/screens/otp_signup_verification.dart';
import 'package:BellyDelivery/ui/widgets/custom_close_app_bar.dart';
import 'package:flutter/gestures.dart';
import 'package:BellyDelivery/utils/show_snackbar.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPage createState() => _SignupPage();
}

class _SignupPage extends State<SignupPage> {
  TextEditingController _nameController;
  TextEditingController _lastnameController;
  TextEditingController _emailController;
  TextEditingController _passwordController;
  TextEditingController _phoneController;

  var universitySelectedItem = "Waseda University",
      campusSelectedItem = "Waseda Campus";
  TapGestureRecognizer _recognizer1;
  TapGestureRecognizer _recognizer2;
  bool otpSentFlag = false;
  final _key = new GlobalKey<ScaffoldState>();
  FocusNode _focusNode = new FocusNode();
  UniversityResponse selectedUniversity;
  CampusResponse selectedCampus;
  AuthDataSource authData = new AuthDataSource();
  ListData listData = new ListData();
  bool _loader = true;
  bool signUpSuccessFlag = false;
  GlobalKey<FormState> _formKey = new GlobalKey();
  bool _validate = false;
  var passKey = GlobalKey<FormFieldState>();
  var signUpResponse;
  List<UniversityResponse> universityData = [];
  List<CampusResponse> campusData = [];

  @override
  void initState() {
    super.initState();
    _phoneController = new TextEditingController();
    _nameController = new TextEditingController();
    _lastnameController = new TextEditingController();
    _emailController = new TextEditingController();
    _passwordController = new TextEditingController();
    _focusNode.addListener(_focusNodeListener);
    _recognizer1 = TapGestureRecognizer()
      ..onTap = () {
        // launch('https://wasedeli-term-of-use.studio.design/');
      };
    _recognizer2 = TapGestureRecognizer()
      ..onTap = () {
        // launch('https://wasedeli-privacy-policy.studio.design/');
      };
    // getUniversities();
    setState(() {
      _loader = false;
    });
  }

  void getUniversities() async {
    _loader = true;
    var universitiesRes = await listData.getUniversities();
    List<dynamic> universities = universitiesRes['results'];
    universityData =
        (universities).map((i) => UniversityResponse.fromJson(i)).toList();
    setState(() {
      selectedUniversity = universityData.toList()[0];
    });
    getCampuses(selectedUniversity.slug);
  }

  void getCampuses(String universitySlug) async {
    var campusRes = await listData.getCampuses(universitySlug);
    List<dynamic> campuses = campusRes['results'];
    setState(() {
      _loader = false;
      campusData = (campuses).map((i) => CampusResponse.fromJson(i)).toList();
      selectedCampus = campusData.toList()[0];
    });
  }

  Future<Null> _focusNodeListener() async {
    if (_focusNode.hasFocus) {
      print('TextField got the focus');
    } else {
      print('TextField lost the focus');
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_focusNodeListener);
    super.dispose();
  }

  _handleSignUpDataSubmission() async {
    setState(() {
      _loader = true;
    });
    // var tempPhone =
    //     _phoneController.text.substring(_phoneController.text.length - 10);
    var tempPhone = _phoneController.text;
    print('ssssssssssssssssssssssssssssssssssssss$tempPhone');
    UserSignupModel _userData = UserSignupModel(
        _emailController.text,
        _passwordController.text,
        _nameController.text,
        _lastnameController.text,
        'xxxx',
        tempPhone);

    var res = await authData.sendSignUpOtpCode(tempPhone);

    if (res[0]) {
      _loader = false;
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                OtpSignUpVerificationPage(userData: _userData)),
      );
    } else {
      setState(() {
        _loader = false;
      });
      Utils.showSnackBar(_key, res[1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _key,
      backgroundColor: whiteColor,
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: CustomCloseAppBar(title: createAccount),
      body: (_loader)
          ? Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
              ),
            )
          : SingleChildScrollView(
              reverse: false,
              child: _buildAuthenticationUi(context),
            ),
      bottomNavigationBar: _buildBottomButton(context),
    );
  }

  Widget _buildAuthenticationUi(context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidate: _validate,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 0),
              Container(
                width: 400,
                decoration: BoxDecoration(
                    color: formBgColor,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    )),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 8.0),
                  child: TextFormField(
                    validator: validateEmail,
                    controller: _emailController,
                    decoration:
                        new InputDecoration.collapsed(hintText: 'Email'),
                    style: TextStyle(
                      letterSpacing: 1.0,
                      fontFamily: 'MontserratMedium',
                      color: Colors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w300,
                    ),
                    keyboardType: TextInputType.emailAddress,
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
                  padding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 8.0),
                  child: TextFormField(
                    controller: _phoneController,
                    decoration:
                        new InputDecoration.collapsed(hintText: phoneNumber),
                    style: TextStyle(
                      letterSpacing: 1.0,
                      fontFamily: 'MontserratMedium',
                      color: Colors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w300,
                    ),
                    keyboardType: TextInputType.phone,
                    validator: validateMobile,
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
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 8.0),
                      child: TextFormField(
                        controller: _lastnameController,
                        validator: validateName,
                        style: TextStyle(
                          letterSpacing: 1.0,
                          fontFamily: 'MontserratMedium',
                          color: Colors.black,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w300,
                        ),
                        keyboardType: TextInputType.text,
                        decoration:
                            new InputDecoration.collapsed(hintText: surname),
                      ),
                    ),
                    Container(
                      height: 1,
                      color: lightGrey,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 8.0),
                      child: TextFormField(
                        validator: validateName,
                        controller: _nameController,
                        style: TextStyle(
                          letterSpacing: 1.0,
                          fontFamily: 'MontserratMedium',
                          color: Colors.black,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w300,
                        ),
                        keyboardType: TextInputType.text,
                        decoration:
                            new InputDecoration.collapsed(hintText: firstname),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              // Container(
              //   width: 400,
              //   decoration: BoxDecoration(
              //       color: cloudsColor,
              //       shape: BoxShape.rectangle,
              //       borderRadius: BorderRadius.all(
              //         Radius.circular(8.0),
              //       )),
              //   child: Column(
              //     children: <Widget>[
              //       Padding(
              //         padding: const EdgeInsets.symmetric(
              //             vertical: 4.0, horizontal: 8.0),
              //         child: DropdownButtonHideUnderline(
              //           child: DropdownButton<UniversityResponse>(
              //             isExpanded: true,
              //             items: universityData.map((UniversityResponse val) {
              //               return new DropdownMenuItem<UniversityResponse>(
              //                 value: val,
              //                 child: new Text(val.name,
              //                     style: CustomFontStyle.bottomButtonTextStyle(
              //                         blackColor)),
              //               );
              //             }).toList(),
              //             value:
              //                 selectedUniversity ?? universityData.toList()[0],
              //             onChanged: (UniversityResponse val) {
              //               selectedUniversity = val;
              //               universitySelectedItem = val.name;
              //               setState(() {
              //                 getCampuses(val.slug);
              //               });
              //             },
              //           ),
              //         ),
              //       ),
              //       Container(
              //         height: 1,
              //         color: lightGrey,
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.symmetric(
              //             vertical: 4.0, horizontal: 8.0),
              //         child: DropdownButtonHideUnderline(
              //           child: DropdownButton<CampusResponse>(
              //             isExpanded: true,
              //             items: campusData.map((CampusResponse val) {
              //               return new DropdownMenuItem<CampusResponse>(
              //                 value: val,
              //                 child: new Text(val.name,
              //                     style: CustomFontStyle.bottomButtonTextStyle(
              //                         blackColor)),
              //               );
              //             }).toList(),
              //             value: selectedCampus ?? campusData.toList()[0],
              //             onChanged: (CampusResponse val) {
              //               selectedCampus = val;
              //               campusSelectedItem = val.name;
              //               setState(() {});
              //             },
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              SizedBox(height: 30),
              Container(
                width: 400,
                decoration: BoxDecoration(
                    color: formBgColor,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    )),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 8.0),
                      child: TextFormField(
                        key: passKey,
                        obscureText: true,
                        controller: _passwordController,
                        style: TextStyle(
                          letterSpacing: 1.0,
                          fontFamily: 'MontserratMedium',
                          color: Colors.black,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w300,
                        ),
                        keyboardType: TextInputType.text,
                        decoration:
                            new InputDecoration.collapsed(hintText: password),
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
                    Container(
                      height: 1,
                      color: lightGrey,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4.0, horizontal: 8.0),
                      child: TextFormField(
                        style: TextStyle(
                          letterSpacing: 1.0,
                          fontFamily: 'MontserratMedium',
                          color: Colors.black,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w300,
                        ),
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        decoration: new InputDecoration.collapsed(
                            hintText: confirmPassword),
                        validator: (confirmation) {
                          var password = passKey.currentState.value;
                          return (confirmation == password)
                              ? null
                              : passwordDoNotMatch;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              RichText(
                text: TextSpan(
                  text: disclaimer1,
                  style: CustomFontStyle.smallTextStyle(blackColor),
                  children: <TextSpan>[
                    TextSpan(
                      text: termsOfService,
                      recognizer: _recognizer1,
                      style: CustomFontStyle.smallTextStyle(blueColor),
                    ),
                    TextSpan(
                      text: disclaimer2,
                      style: CustomFontStyle.smallTextStyle(blackColor),
                    ),
                    TextSpan(
                      text: privacyPolicy,
                      recognizer: _recognizer2,
                      style: CustomFontStyle.smallTextStyle(blueColor),
                    ),
                    TextSpan(
                      text: disclaimer3,
                      style: CustomFontStyle.smallTextStyle(blackColor),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton(context) {
    return Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: InkWell(
          onTap: () {
            if (_formKey.currentState.validate()) {
              FocusScope.of(context).requestFocus(new FocusNode());
              _handleSignUpDataSubmission();
            }
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
                    signUp,
                    style:
                        CustomFontStyle.bottomButtonTextStyle(whiteBellyColor),
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}

String validateName(String value) {
  if (value.length == 0) {
    return noEmptyFields;
  }
  return null;
}

String validateEmail(String value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return noEmptyFields;
  } else if (!regExp.hasMatch(value)) {
    return invalidEmail;
  } else {
    return null;
  }
}

String validateMobile(String value) {
  String pattern = r'(^[0-9]*$)';
  RegExp regExp = new RegExp(pattern);
  if (value.length == 0) {
    return noEmptyFields;
  } else if (value.length != 10) {
    return phoneShouldbe10Digits;
  } else if (!regExp.hasMatch(value)) {
    return "Invalid phone number";
  }
  return null;
}
