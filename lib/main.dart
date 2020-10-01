import 'dart:async';

import 'package:BellyDelivery/constants/String.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:BellyDelivery/models/user_provider_model.dart';
import 'package:BellyDelivery/ui/screens/home_screen.dart';
import 'package:BellyDelivery/ui/screens/welcome_screen.dart';
import 'models/bucket_in_hand_provider_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State createState() => new MyAppState();

  MyApp({Key key}) : super(key: key);
}

class MyAppState extends State<MyApp> {
  Widget _defaultHome = new WelcomePage();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    initSharedPreference();
  }

  void initSharedPreference() async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    var loggedIn = _sharedPreferences.getBool("loggedIn").toString();
    if (loggedIn != 'null' && loggedIn != 'false') {
      Timer(Duration(milliseconds: 1500), () async {
        setState(() {
          _loading = false;
          _defaultHome = new HomePage();
        });
      });
    } else
      Timer(Duration(milliseconds: 1500), () {
        setState(() {
          _loading = false;
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: BucketInHandModel()),
          ChangeNotifierProvider.value(value: UserModel()),
        ],
        child: new MaterialApp(
          debugShowCheckedModeBanner: false,
          home: _loading ? SplashScreen() : _defaultHome,
          title: 'Belly Delivery',
          theme: ThemeData(
              platform: TargetPlatform.iOS, primarySwatch: Colors.blue),
        ));
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(1, 190, 100, 1),
      // greenBellyColor,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Center(
          child: Container(
        height: MediaQuery.of(context).size.height * 0.3,
        width: MediaQuery.of(context).size.width,
        child: Image.asset(
          'images/splashscreen.png',
          fit: BoxFit.contain,
        ),
      )),
    );
  }
}
