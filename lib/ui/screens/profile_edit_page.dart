import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:BellyDelivery/constants/Constants.dart';
import 'package:BellyDelivery/constants/Style.dart';
import 'package:BellyDelivery/constants/String.dart';
import 'package:BellyDelivery/data/location_list_data.dart';
import 'package:BellyDelivery/data/my_profile_data.dart';
import 'package:BellyDelivery/models/campus_model.dart';
import 'package:BellyDelivery/models/university_model.dart';
import 'package:BellyDelivery/models/user_provider_model.dart';
import 'package:BellyDelivery/ui/widgets/custom_close_app_bar.dart';
import 'package:BellyDelivery/constants/Color.dart';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart' as Picker;
import 'package:BellyDelivery/utils/base_url.dart';
import 'package:BellyDelivery/utils/show_snackbar.dart';

class ProfileEditPage extends StatefulWidget {
  @override
  _ProfileEditPageState createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  TextEditingController _nameController;
  TextEditingController _lastnameController;
  TextEditingController _emailController;
  TextEditingController _passwordController;
  TextEditingController _newPasswordController;
  TextEditingController _mobileController;

  final _key = new GlobalKey<ScaffoldState>();
  var universitySelectedItem, campusSelectedItem;
  String userName, lastName, token;
  UniversityResponse selectedUniversity;
  CampusResponse selectedCampus;
  User _userResponse;
  ProfileDataSource profileData = new ProfileDataSource();
  ListData listData = new ListData();
  File _image;
  bool _loader = true;
  // List<UniversityResponse> universityData = [];
  // List<CampusResponse> campusData = [];
  GlobalKey<FormState> _formKey = new GlobalKey();
  bool _validate = false;
  var passKey = GlobalKey<FormFieldState>();
  static final baseUrl = BaseUrl().mainUrl;
  static final saveEditProfileUrl = baseUrl + "editprofile/";

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      setState(() {
        userName = prefs.getString('user_name');
        lastName = prefs.getString('last_name');
        token = prefs.getString('token');
      });
    } on Exception catch (error) {
      print(error);
      return null;
    }
    getInitialData();
  }

  void getInitialData() async {
    var _response = await profileData.getMyProfileData(token);
    if (_response[0] == true) _userResponse = _response[1];
    _nameController = new TextEditingController(text: _userResponse.firstName);
    _lastnameController =
        new TextEditingController(text: _userResponse.lastName);
    _emailController =
        new TextEditingController(text: _userResponse.emailAddress);
    _mobileController = new TextEditingController(text: _userResponse.phone);
    _passwordController = new TextEditingController();
    _newPasswordController = new TextEditingController();
    // getUniversities();
    setState(() {
      _loader = false;
    });
  }

  // void getUniversities() async {
  //   var universitiesRes = await listData.getUniversities();
  //   List<dynamic> universities = universitiesRes['results'];
  //   universityData =
  //       (universities).map((i) => UniversityResponse.fromJson(i)).toList();
  //   for (int i = 0; i < universityData.length; i++) {
  //     if (universityData[i].slug == _userResponse.campus.university.slug)
  //       selectedUniversity = universityData[i];
  //   }
  //   getCampuses(selectedUniversity.slug);
  // }

  // void getCampuses(String universitySlug) async {
  //   var campusRes = await listData.getCampuses(universitySlug);
  //   List<dynamic> campuses = campusRes['results'];
  //   campusData = (campuses).map((i) => CampusResponse.fromJson(i)).toList();
  //   setState(() {
  //     _loader = false;
  //     selectedCampus = campusData[0];
  //   });
  // }

  _handleSaveDetails(context) async {
    showLoading();
    if (_passwordController.text != "") {
      bool passFlag = await profileData.changePassword(
          token, _passwordController.text, _newPasswordController.text);
      if (passFlag) {
        var res = await addNewItem({
          "first_name": _nameController.text,
          "last_name": _lastnameController.text,
          "email_address": _emailController.text,
          "phone": _mobileController.text,
        }, _image);
        Utils.showSnackBar(_key, profileUpdated);
      } else
        Utils.showSnackBar(_key, passwordDoNotMatch);
    } else
      var res = await addNewItem({
        "first_name": _nameController.text,
        "last_name": _lastnameController.text,
        "email_address": _emailController.text,
        "phone": _mobileController.text,
      }, _image);
    Utils.showSnackBar(_key, profileUpdated);
    var _response = await profileData.getMyProfileData(token);
    if (_response[0] == true) {
      _userResponse = _response[1];
      Provider.of<UserModel>(context, listen: false).updateUser(_userResponse);
    }
    hideLoading();
  }

  void showLoading() {
    setState(() {
      _loader = true;
    });
  }

  void hideLoading() {
    setState(() {
      _loader = false;
    });
  }

  Future<Map<String, dynamic>> addNewItem(var body, File file) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    String token = shared.getString("token");
    var stream;
    var length;
    var mulipartFile;
    var request = new http.MultipartRequest("PUT",
        Uri.parse(saveEditProfileUrl + _userResponse.id.toString() + "/"));
    if (file != null) {
      stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
      length = await file.length();
      mulipartFile = new http.MultipartFile('profile_pic', stream, length,
          filename: basename(file.path));
    }
    request.headers['Authorization'] = "Token " + token;
    request.fields['first_name'] = body['first_name'];
    request.fields['last_name'] = body['last_name'];
    request.fields['email_address'] = body['email_address'];
    request.fields['id'] = _userResponse.id.toString();
    // request.fields['campus'] = selectedCampus.name;
    request.fields['phone'] = body['phone'];
    if (file != null) {
      request.files.add(mulipartFile);
    }

    http.StreamedResponse postresponse = await request.send();
    if (postresponse.statusCode == 200) {
      var res = await http.Response.fromStream(postresponse);
      return json.decode(res.body);
    } else {
      throw new Exception("Error while fetching data");
    }
  }

  void _takeImageFromCamera() async {
    var image =
        await Picker.ImagePicker.pickImage(source: Picker.ImageSource.camera);
    setState(() {
      _image = image;
    });
  }

  void _takeImageFromGallery() async {
    var image =
        await Picker.ImagePicker.pickImage(source: Picker.ImageSource.gallery);
    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: CustomCloseAppBar(
        title: accountDetails,
      ),
      body: _loader
          ? Center(child: CupertinoActivityIndicator())
          : Column(
              children: <Widget>[
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: <Widget>[
                      _buildAuthenticationUi(context),
                    ],
                  ),
                ),
              ],
            ),
      bottomNavigationBar: _buildBottomButton(context),
    );
  }

  Widget _buildAuthenticationUi(context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        autovalidate: _validate,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: InkWell(
                onTap: () {
                  showAlertDialog(context);
                },
                child: Stack(
                    alignment: AlignmentDirectional.center,
                    overflow: Overflow.clip,
                    children: <Widget>[
                      ClipOval(
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Container(
                            width: 100.0,
                            height: 100.0,
                            decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withOpacity(0.2)),
                            child: _image == null
                                ? CachedNetworkImage(
                                    imageUrl: _userResponse.profilePic != null
                                        ? _userResponse.profilePic
                                        : userImageUrl,
                                    errorWidget: (context, url, error) =>
                                        new Icon(Icons.error),
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(_image),
                          ),
                        ),
                      ),
                      Container(
                        width: 100.0,
                        height: 100.0,
                        child: new BackdropFilter(
                          filter:
                              new ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
                          child: new Container(
                            decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withOpacity(0.2)),
                          ),
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                      ),
                      Container(
                        width: 40.0,
                        height: 40.0,
                        child: new Image.asset(
                          'images/icons/camera_icon.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ]),
              ),
            ),
            SizedBox(height: 16),
            Container(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      surname,
                      style: CustomFontStyle.RegularTextStyle(disabledGrey),
                    ),
                    Text(
                      _userResponse.lastName,
                      style:
                          CustomFontStyle.bottomButtonTextStyle(disabledGrey),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            Container(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      firstname,
                      style: CustomFontStyle.RegularTextStyle(disabledGrey),
                    ),
                    Text(
                      _userResponse.firstName,
                      style:
                          CustomFontStyle.bottomButtonTextStyle(disabledGrey),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            Container(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      mailAddress,
                      style: CustomFontStyle.RegularTextStyle(disabledGrey),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: 400,
                      decoration: BoxDecoration(
                          color: cloudsColor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          )),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 8.0),
                        child: TextFormField(
                          validator: validateEmail,
                          decoration:
                              new InputDecoration.collapsed(hintText: 'Email'),
                          style: TextStyle(
                            letterSpacing: 1.0,
                            fontFamily: 'MontserratMedium',
                            color: Colors.black,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w300,
                          ),
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            Container(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Phone Number",
                      style: CustomFontStyle.RegularTextStyle(disabledGrey),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: 400,
                      decoration: BoxDecoration(
                          color: cloudsColor,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.all(
                            Radius.circular(8.0),
                          )),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 8.0),
                        child: TextFormField(
                          validator: validatephone,
                          decoration: new InputDecoration.collapsed(
                              hintText: 'Phone Number'),
                          style: TextStyle(
                            letterSpacing: 1.0,
                            fontFamily: 'MontserratMedium',
                            color: Colors.black,
                            fontSize: 14.0,
                            fontWeight: FontWeight.w300,
                          ),
                          controller: _mobileController,
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                color: cloudsColor,
                shape: BoxShape.rectangle,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                child: TextFormField(
                  obscureText: true,
                  controller: _passwordController,
                  keyboardType: TextInputType.text,
                  style: CustomFontStyle.regularFormTextStyle(blackColor),
                  decoration:
                      new InputDecoration.collapsed(hintText: oldPassword),
                ),
              ),
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
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 8.0),
                    child: TextFormField(
                      key: passKey,
                      obscureText: true,
                      style: TextStyle(
                        letterSpacing: 1.0,
                        fontFamily: 'MontserratMedium',
                        color: Colors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w300,
                      ),
                      keyboardType: TextInputType.text,
                      controller: _newPasswordController,
                      decoration:
                          new InputDecoration.collapsed(hintText: password),
                      validator: (password) {
                        String pattern =
                            r'^(?=.*[a-zA-Z])(?=.*\d)[A-Za-z\d!@#$%^&*()_+]{8,20}';
                        RegExp regExp = new RegExp(pattern);
                        if (_passwordController.text != "") {
                          if (password.length == 0) {
                            return noEmptyFields;
                          } else if (!regExp.hasMatch(password)) {
                            return passwordShould8digits;
                          } else {
                            return null;
                          }
                        } else
                          return null;
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
                      obscureText: true,
                      keyboardType: TextInputType.text,
                      style: TextStyle(
                        letterSpacing: 1.0,
                        fontFamily: 'MontserratMedium',
                        color: Colors.black,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w300,
                      ),
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
          ],
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
              _handleSaveDetails(context);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: blackBellyColor,
              shape: BoxShape.rectangle,
            ),
            child: Container(
              width: double.infinity,
              height: 50,
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Center(
                  child: Text(
                    update,
                    style: TextStyle(
                      letterSpacing: 1.0,
                      fontFamily: 'MontserratMedium',
                      color: whiteBellyColor,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                    ),
                    textScaleFactor: 1.2,
                  ),
                ),
              ),
            ),
          ),
        ));
  }

  showAlertDialog(BuildContext context) {
    // set up the list options
    Widget optionOne = CupertinoDialogAction(
      child: const Text('camera'),
      onPressed: () {
        _takeImageFromCamera();
        Navigator.of(context).pop();
      },
    );
    Widget optionTwo = CupertinoDialogAction(
      child: const Text('gallery'),
      onPressed: () {
        _takeImageFromGallery();
        Navigator.of(context).pop();
      },
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
            data: ThemeData.light(),
            child: CupertinoAlertDialog(
              title: const Text('Set photo'),
              content:
                  new Text("Select a photo or take a picture with your camera"),
              actions: <Widget>[
                optionOne,
                optionTwo,
              ],
            ));
      },
    );
  }
}

String validateName(String value) {
  if (value.length == 0) {
    return noEmptyFields;
  }
  return null;
}

String validatephone(String value) {
  if (value.length != 13) {
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
