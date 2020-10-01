import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:BellyDelivery/constants/Constants.dart';
import 'package:BellyDelivery/constants/Style.dart';
import 'package:BellyDelivery/constants/String.dart';
import 'package:BellyDelivery/data/my_profile_data.dart';
import 'package:BellyDelivery/models/user_provider_model.dart';
import 'package:BellyDelivery/ui/screens/help_page.dart';
import 'package:BellyDelivery/ui/screens/my_sales_page.dart';
import 'package:BellyDelivery/ui/screens/profile_edit_page.dart';
import 'package:BellyDelivery/ui/screens/welcome_screen.dart';
import 'package:BellyDelivery/ui/widgets/custom_close_app_bar.dart';
import 'package:BellyDelivery/constants/Color.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  String userName, lastName, fullName;
  bool isLoading = false;
  String token;
  UserModel _userProvider;
  ProfileDataSource profileData = new ProfileDataSource();

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_userProvider == null) {
      _userProvider = Provider.of<UserModel>(context);
      print('new provider instatiation');
    }
    _userProvider.getInitialData();
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      token = prefs.getString('token');
      setState(() {
        userName = prefs.getString('user_name');
        lastName = prefs.getString('last_name');
        fullName = lastName + " " + userName;
      });
    } on Exception catch (error) {
      print(error);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomCloseAppBar(
        title: myPage,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    buildInfoDetail(),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoDetail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 12.0),
        Container(
          height: 20,
          color: cloudsColor,
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileEditPage()),
            );
          },
          child: Container(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.only(
                  left: 24.0, right: 24.0, top: 20.0, bottom: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 70.0,
                          width: 70.0,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(new Radius.circular(70.0)),
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: CachedNetworkImageProvider(
                                    _userProvider.user == null
                                        ? userImageUrl
                                        : _userProvider.user.profilePic),
                              )),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Text(
                          _userProvider.user == null
                              ? fullName
                              : _userProvider.user.lastName +
                                  " " +
                                  _userProvider.user.firstName,
                          style:
                              CustomFontStyle.regularBoldTextStyle(blackColor),
                        ),
                      ]),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: disabledGrey,
                    size: 20.0,
                  ),
                ],
              ),
            ),
          ),
        ),
        Container(
          height: 20,
          color: cloudsColor,
        ),
        Container(
            child: Padding(
              padding: EdgeInsets.only(
                  left: 24.0, right: 24.0, top: 16.0, bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: Image.asset(
                          'images/icons/cod_cash_icon.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(
                        width: 24,
                      ),
                      Text(
                        collectedCashAmount,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                            fontSize: 15.0),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "₹ " + _userProvider.cashCollected,
                        style:
                            CustomFontStyle.bottomButtonTextStyle(blackColor),
                      ),
                      SizedBox(
                        width: 30,
                      ),
                      SizedBox(
                        width: 20,
                      )
                    ],
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: cloudsColor,
                  width: 1.0,
                ),
              ),
            )),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MySalesPage()),
            );
          },
          child: Container(
              child: Padding(
                padding: EdgeInsets.only(
                    left: 24.0, right: 24.0, top: 16.0, bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: Image.asset(
                            'images/icons/sales_icon.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(
                          width: 24,
                        ),
                        Text(
                          sales,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              fontSize: 15.0),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          "₹ " + _userProvider.pendingReward,
                          style:
                              CustomFontStyle.bottomButtonTextStyle(blackColor),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: disabledGrey,
                          size: 20.0,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: cloudsColor,
                    width: 1.0,
                  ),
                ),
              )),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HelpPage()),
            );
          },
          child: Container(
              child: Padding(
                padding: EdgeInsets.only(
                    left: 24.0, right: 24.0, top: 16.0, bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: Image.asset(
                            'images/icons/help_icon.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(
                          width: 24,
                        ),
                        Text(
                          help,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              fontSize: 15.0),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: disabledGrey,
                      size: 20.0,
                    ),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: cloudsColor,
                    width: 1.0,
                  ),
                ),
              )),
        ),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MySalesPage()),
            );
          },
          child: Container(
              child: Padding(
                padding: EdgeInsets.only(
                    left: 24.0, right: 24.0, top: 16.0, bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                          width: 20,
                          child: Image.asset(
                            'images/icons/sales_icon.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(
                          width: 24,
                        ),
                        Text(
                          'Monthly Sales',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                              fontSize: 15.0),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          "₹ " + _userProvider.pendingReward,
                          style:
                              CustomFontStyle.bottomButtonTextStyle(blackColor),
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: disabledGrey,
                          size: 20.0,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: cloudsColor,
                    width: 1.0,
                  ),
                ),
              )),
        ),
        Container(
          height: 30,
          color: cloudsColor,
        ),
        InkWell(
          onTap: () {
            containerForSheet<String>(
              context: context,
              child: CupertinoActionSheet(
                  title: Text(
                    areYouSureWantLogout,
                    style: CustomFontStyle.smallTextStyle(greyColor),
                  ),
                  actions: <Widget>[
                    CupertinoActionSheetAction(
                      child: Text(
                        signOut,
                        style: CustomFontStyle.buttonTextStyle(redColor),
                      ),
                      onPressed: () {
                        _handleLogout();
                      },
                    ),
                  ],
                  cancelButton: CupertinoActionSheetAction(
                    child: Text(
                      no,
                      style: CustomFontStyle.buttonTextStyle(blueColor),
                    ),
                    isDefaultAction: true,
                    onPressed: () {
                      Navigator.pop(context, 'Cancel');
                    },
                  )),
            );
          },
          child: Container(
              child: Padding(
                padding: EdgeInsets.only(
                    left: 24.0, right: 24.0, top: 16.0, bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      signOut,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                          fontSize: 15.0),
                    ),
                  ],
                ),
              ),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: cloudsColor,
                    width: 1.0,
                  ),
                  bottom: BorderSide(
                    color: cloudsColor,
                    width: 1.0,
                  ),
                ),
              )),
        ),
      ],
    );
  }

  void containerForSheet<T>({BuildContext context, Widget child}) {
    showCupertinoModalPopup<T>(
      context: context,
      builder: (BuildContext context) => child,
    ).then<void>((T value) {});
  }

  _handleLogout() async {
    _userProvider.logout();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => WelcomePage()),
        (Route<dynamic> route) => false);
  }
}
