import 'dart:async';
import 'package:background_location/background_location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:BellyDelivery/constants/Color.dart';
import 'package:BellyDelivery/constants/Constants.dart';
import 'package:BellyDelivery/constants/String.dart';
import 'package:BellyDelivery/constants/Style.dart';
import 'package:BellyDelivery/data/authentication_data.dart';
import 'package:BellyDelivery/data/home_page_data.dart';
import 'package:BellyDelivery/models/bucket_in_hand_provider_model.dart';
import 'package:BellyDelivery/models/bucket_notification_response.dart';
import 'package:BellyDelivery/models/user_provider_model.dart';
import 'package:BellyDelivery/ui/screens/bucket_detail_page.dart';
import 'package:BellyDelivery/ui/screens/my_page_screen.dart';
import 'package:BellyDelivery/ui/widgets/countDownTimer.dart';
import 'package:BellyDelivery/ui/widgets/no_internet_dialog.dart';
import 'package:BellyDelivery/ui/widgets/other_notification_dialog.dart';
import 'package:BellyDelivery/ui/widgets/tracking_enabled.dart';
import 'package:BellyDelivery/utils/internet_connectivity.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Completer<GoogleMapController> _mapController = Completer();
  bool pressed = false;
  AuthDataSource authData = new AuthDataSource();
  HomeDataSource _homeDataSource = new HomeDataSource();
  BucketNotificationResponse data;
  String token;
  Set<Marker> markers = Set();
  Set<Marker> tempMarkers = Set();
  bool _isLoading = false;
  bool _onlineStatus = false;
  bool _isBucketAvailable = false;
  bool _isBucketInHand = false;
  BucketInHandModel _bucketInHandProvider;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      new FlutterLocalNotificationsPlugin();
  PageController controller = PageController();
  int currentPageValue = 0;
  UserModel _userProvider;
  String latitude = "waiting...";
  String longitude = "waiting...";
// deliLocations
  FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  Timer _timer;
  final _key = new GlobalKey<ScaffoldState>();
  GlobalKey<BucketDetailPageState> _keyBucketDetailState = GlobalKey();
  bool displayDelivery = false;
  bool verify = false;

  @override
  void initState() {
    super.initState();
    getFCMToken();
    getSharedPrefs();
    var android = new AndroidInitializationSettings('mipmap/ic_launcher');
    var ios = new IOSInitializationSettings();
    var platform = new InitializationSettings(android, ios);
    flutterLocalNotificationsPlugin.initialize(platform);
    Future.delayed(Duration(seconds: 1), () {
      MyConnectivity.instance.initialise();
      MyConnectivity.instance.myStream.listen((onData) {
        if (MyConnectivity.instance.isIssue(onData)) {
          if (MyConnectivity.instance.isShow == false) {
            MyConnectivity.instance.isShow = true;
            showDialogNoInternet(context).then((onValue) {
              MyConnectivity.instance.isShow = false;
            });
          }
        } else {
          if (MyConnectivity.instance.isShow == true) {
            Navigator.of(context).pop();
            MyConnectivity.instance.isShow = false;
          }
        }
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_userProvider == null) {
      _userProvider = Provider.of<UserModel>(context);
      print('new provider instatiation');
    }
    if (_userProvider.user == null) _userProvider.getInitialData();
    _bucketInHandProvider = Provider.of<BucketInHandModel>(context);
  }

  @override
  void dispose() {
    BackgroundLocation.stopLocationService();
    print('location service dispose');
    super.dispose();
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      _isBucketInHand = prefs.getBool('bucketInHand');
      token = prefs.getString('token');
      verify = prefs.getBool('verify');
      print('Token of belly Boy $token');
    } on Exception catch (error) {
      print(error);
      return null;
    }
    getUserOnlineStatus();
    getInitTrackingData();
  }

  void getInitTrackingData() async {
    var response = await _homeDataSource.checkTrackingEnabled(token);
    if (response['tracking_status']) {
      print('trackinggggggggggg trackingggggggg');
      if (!response['sharing_status']) showTrackingDialog(context);
      if (response['order_id'] != null)
        enableBackgroundTracking(response['order_id']);
    } else {
      print('unUNUNkinggggggggggg trackingggggggg');
    }
  }

  void getUserOnlineStatus() async {
    setState(() {
      _isLoading = true;
    });
    _onlineStatus = await _homeDataSource.userOnlineStatus(token);
    getNotificationData();
  }

  void getNotificationData() async {
    if (!_isLoading)
      setState(() {
        _isLoading = true;
      });
    data = await _homeDataSource.getNewOrders(token);
    print('data data data ${data.count}');
    setState(() {
      if (data.count > 0)
        _isBucketAvailable = true;
      else
        _isBucketAvailable = false;
      _isLoading = false;
    });
  }

  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  void getFCMToken() async {
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        onDidReceiveLocalNotification(message);
        return;
      },
      onResume: (Map<String, dynamic> message) {
        print('on resume $message');
        if (message['type'] == "pickuporder")
          getNotificationData();
        else
          onDidReceiveLocalNotification(message);
        return;
      },
      onLaunch: (Map<String, dynamic> message) {
        print('on launch $message');
        return;
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));

    _firebaseMessaging.getToken().then((fcmToken) {
      try {
        print("fcm token : " + fcmToken);
        authData.sendFCMToken(token, fcmToken);
      } on Exception catch (e) {
        print(e);
      }
    });
  }

  Future onDidReceiveLocalNotification(Map<String, dynamic> message) async {
    if (message['type'] == "pickuporder") {
      getNotificationData();
      FlutterRingtonePlayer.playNotification();
    } else if (message['type'] == "enable_location_share") {
      print("first pickup from rest");
      _bucketInHandProvider.updateBucketNumber();
      _bucketInHandProvider.updateOrderPickUpStatus(true);
      bool _enableTracking =
          await _homeDataSource.isTrackingEnabled(token, message['bucket_id']);
      if (_enableTracking) {
        showTrackingDialog(context);
        enableBackgroundTracking(message['bucket_id']);
      }
    } else if (message['type'] == "restaurant_initiate_pickup") {
      print("pickup_order_initate");
      _keyBucketDetailState.currentState.getData();
    } else if (message['type'] != "bucket_already_accepted" &&
        message['aps'] != null) showOtherNotificationDialog(context, message);
  }

  saveLastLocationTime() async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('lastLocUpdatedTimeStamp', timestamp);
  }

  Future<DateTime> getLastLocationTime() async {
    final prefs = await SharedPreferences.getInstance();
    int timestamp = prefs.getInt('lastLocUpdatedTimeStamp');
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return dateTime;
  }

  void enableBackgroundTracking(bucketId) async {
    _bucketInHandProvider.updateOrderPickUpStatus(true);

    var res =
        await _homeDataSource.startStopLocationSharing(token, bucketId, "True");
    if (res[0]) {
      saveLastLocationTime();
      print('enteeeeeeeeeeredddd');
      BackgroundLocation.startLocationService();
      BackgroundLocation().getCurrentLocation().then((location) {
        print('insssssssssside baaaackground');
        _fireStore
            .collection('deliLocations')
            .doc(res[1])
            .set({'posLat': location.latitude, 'posLng': location.longitude})
            .then((value) => print('Value Added !!!!!!!!!!!!!!!!!!'))
            .catchError((onError) {
              print('error is found on setting data $onError');
            });
      }).catchError((onError) {
        print('errrrrrrrrrrorrrr');
        print(onError);
      });
      BackgroundLocation.getLocationUpdates((location) async {
        DateTime now = DateTime.now();
        DateTime before = await getLastLocationTime();
        Duration timeDifference = now.difference(before);
        print('getLocUpdates');
        if (timeDifference.inSeconds > 10) {
          _fireStore.collection('deliLocations').document(res[1]).setData(
              {'posLat': location.latitude, 'posLng': location.longitude});
          print("""\n
      Latitude:  ${location.latitude.toString()}
      Longitude: ${location.longitude.toString()}
      """);
          saveLastLocationTime();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      body: Stack(
        children: <Widget>[
          _buildGoogleMap(context),
          _earningsBar(),
          _buildVerify(),
          _onlineOfflineButton(),
          _buildOrderCards()
        ],
      ),
    );
  }

  Widget _buildVerify() {
    return verify
        ? SizedBox.shrink()
        : Align(
            alignment: Alignment.center,
            child: Container(
                width: 300,
                height: 100,
                color: Colors.white,
                child: Center(
                  child: Text(
                    'Please visit your Leader for Verification',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                )),
          );
  }

  Widget _earningsBar() {
    return Align(
      alignment: Alignment.topCenter,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyPage()),
          );
        },
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 50.0),
          width: 180.0,
          height: 50.0,
          child: new Container(
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius:
                    new BorderRadius.all(const Radius.circular(50.0))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                SizedBox(
                  width: 20,
                ),
                _userProvider.user == null
                    ? Text(
                        "",
                        style: CustomFontStyle.smallTextStyle(greenBellyColor),
                      )
                    : Text(
                        "₹ " + _userProvider.pendingReward,
                        style: CustomFontStyle.mediumBoldTextStyle(
                            greenBellyColor),
                      ),
                Spacer(),
                CircleAvatar(
                  radius: 20.0,
                  backgroundImage: NetworkImage(_userProvider.user == null
                      ? userImageUrl
                      : _userProvider.user.profilePic),
                  backgroundColor: Colors.transparent,
                ),
                SizedBox(
                  width: 4,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCards() {
    if (_isBucketAvailable && !displayDelivery)
      _addOrderMarkers(currentPageValue);
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(
          margin: EdgeInsets.symmetric(vertical: 20.0),
          height: 300.0,
          child: _isLoading
              ? Center(child: CupertinoActivityIndicator())
              : _isBucketAvailable
                  ? PageView.builder(
                      itemCount: data.count,
                      onPageChanged: (pageIndex) {
                        setState(() {
                          currentPageValue = pageIndex;
                        });
                        displayDelivery
                            ? _addOrderMarkersOfDeliveryLocation(
                                currentPageValue)
                            : _addOrderMarkers(currentPageValue);
                      },
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, itemIndex) {
                        return new Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: _boxes(data.bucket[itemIndex], itemIndex));
                      },
                    )
                  : Container()),
    );
  }

  Widget _boxes(Order _bucketData, int _bucketIndex) {
    return GestureDetector(
      onDoubleTap: () {
        _gotoLocation(double.parse(_bucketData.pickUpLocation.lat),
            double.parse(_bucketData.pickUpLocation.long));
      },
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BucketDetailPage(
                        bucketId: _bucketData.id,
                        stateKey: _keyBucketDetailState,
                        bucketAcceptCallback: () {
                          getNotificationData();
                        })),
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          _bucketData.slottime.substring(11, 16),
                          style: CustomFontStyle.mediumTextStyle(blackColor),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          _bucketData.restaurantName,
                          style:
                              CustomFontStyle.mediumBoldTextStyle(blackColor),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.location_on,
                            color: greyColor,
                            size: 16,
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Text(
                            _bucketData.pickUpLocation.place,
                            style: CustomFontStyle.RegularTextStyle(greyColor),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      data.sec != 0
                          ? Center(
                              child: CountDownTimer(
                              launchDate: DateTime.parse(data.deliNotiUpto),
                              whenTimeExpires: () {
                                markers.clear();
                                setState(() {
                                  _isBucketAvailable = false;
                                });
                              },
                            ))
                          : Container(),
                      SizedBox(
                        height: 10,
                      ),
                      data.sec != 0
                          ? Center(
                              child: Text(
                                acceptInTwoMinute,
                                style:
                                    CustomFontStyle.RegularTextStyle(greyColor),
                              ),
                            )
                          : Container(),
                      SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: RaisedButton(
                          onPressed: () {
                            if (!displayDelivery) {
                              print('enterrrrrrrrrrrrw');
                              setState(() {
                                displayDelivery = true;
                              });
                              _addOrderMarkersOfDeliveryLocation(_bucketIndex);
                            } else {
                              print('show deliver location1!!!');
                              setState(() {
                                displayDelivery = false;
                              });
                            }
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(
                                Icons.location_on,
                                color: Colors.amber,
                              ),
                              Text(displayDelivery
                                  ? "Show Pickup Location"
                                  : 'Show Delivery Location')
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                      height: 50,
                      width: double.infinity,
                      color: blackColor,
                      child: InkWell(
                        onTap: () async {
                          if (!_bucketData.bucketAccepted) {
                            bool _bucketAccepted = await _homeDataSource
                                .bucketStatusChange(token, _bucketData.id);
                            if (_bucketAccepted)
                              getNotificationData();
                            else {
                              getNotificationData();
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      _buildDialog(context));
                            }
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
                              padding: const EdgeInsets.only(
                                  left: 16.0, right: 16.0),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      _bucketData.bucketAccepted
                                          ? accepted
                                          : accept,
                                      style:
                                          CustomFontStyle.bottomButtonTextStyle(
                                              whiteColor),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Icon(Icons.check_circle,
                                        color: _bucketData.bucketAccepted
                                            ? yellow
                                            : blackColor)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ))
                ],
              ),
              decoration: BoxDecoration(
                  color: cloudsColor,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  )),
            ),
          )),
    );
  }

  Widget _onlineOfflineButton() {
    return Positioned(
      bottom: _isBucketAvailable ? 320 : 60,
      left: 10,
      child: InkWell(
        splashColor: disabledGrey,
        onTap: () async {
          bool _success = await _homeDataSource.userStatusChange(
              token, _onlineStatus ? 'offline' : 'online');
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (_onlineStatus && _success) {
            //markers.clear();
            prefs.setBool('userStatus', false);
          } else if (!_onlineStatus && _success)
            prefs.setBool('userStatus', true);
          getUserOnlineStatus();
        },
        child: Container(
          width: 112.0,
          height: 30.0,
          child: new Container(
            decoration: new BoxDecoration(
                color: _onlineStatus ? blackColor : Colors.white,
                borderRadius: new BorderRadius.all(const Radius.circular(8.0))),
            child: Center(
              child: Text(
                _onlineStatus ? online : offline,
                style: CustomFontStyle.smallTextStyle(
                    _onlineStatus ? whiteColor : greenBellyColor),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoogleMap(BuildContext context) {
    CameraPosition _defaultPos =
        new CameraPosition(target: LatLng(9.9312, 76.2673), zoom: 12);
    if (_isBucketAvailable && !displayDelivery)
      _addOrderMarkers(currentPageValue);
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: GoogleMap(
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          initialCameraPosition: _defaultPos,
          onMapCreated: onMapCreated,
          markers: markers),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    this._mapController.complete(controller);
    getCurrentUserLocation();
  }

  void getCurrentUserLocation() {
    BackgroundLocation().getCurrentLocation().then((locationData) {
      LatLng target = LatLng(locationData.latitude, locationData.longitude);
      moveToLocation(target);
    }).catchError((error) {
      // TODO: Handle the exception here
      print(error);
    });
  }

  void moveToLocation(LatLng latLng) {
    print('hellooooooooo');
    this._mapController.future.then((controller) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: latLng,
            zoom: 15.0,
          ),
        ),
      );
    });
  }

  Future<void> _addOrderMarkersOfDeliveryLocation(int _selectedIndex) async {
    tempMarkers.clear();
    if (!_isLoading && data.bucket.length != 0) {
      print('iam here   ${data.bucket[_selectedIndex].deliverLocation.long}');
      Marker resultMarker = Marker(
          markerId: MarkerId(data.bucket[_selectedIndex].id),
          infoWindow: InfoWindow(
              title: "",
              snippet: data.bucket[_selectedIndex].deliverLocation.place),
          icon: BitmapDescriptor.defaultMarker,
          // .fromAsset("images/icons/map_marker.png"),
          position: LatLng(
              double.parse(data.bucket[_selectedIndex].deliverLocation.lat),
              double.parse(data.bucket[_selectedIndex].deliverLocation.long)));
      tempMarkers.add(resultMarker);
      setState(() {
        markers = tempMarkers;
      });
    }
    LatLng latLng = LatLng(
        double.parse(data.bucket[_selectedIndex].deliverLocation.lat),
        double.parse(data.bucket[_selectedIndex].deliverLocation.long));

    moveToLocation(latLng);
  }

  Future<void> _addOrderMarkers(int _selectedIndex) async {
    tempMarkers.clear();
    if (!_isLoading && data.bucket.length != 0) {
      for (int i = 0; i < data.bucket.length; i++) {
        print(
            'iam RESTAURANT   ${data.bucket[_selectedIndex].pickUpLocation.long}');
        Marker resultMarker = Marker(
            markerId: MarkerId(data.bucket[_selectedIndex].restaurantName),
            infoWindow: InfoWindow(
                title: "", snippet: data.bucket[_selectedIndex].restaurantName),
            icon: BitmapDescriptor.defaultMarker,
            // .fromAsset("images/icons/map_marker.png"),
            position: LatLng(
                double.parse(data.bucket[_selectedIndex].pickUpLocation.lat),
                double.parse(data.bucket[_selectedIndex].pickUpLocation.long)));
        tempMarkers.add(resultMarker);
      }
      setState(() {
        markers = tempMarkers;
      });
    }
    LatLng latLng = LatLng(double.parse(data.bucket[0].pickUpLocation.lat),
        double.parse(data.bucket[0].pickUpLocation.long));

    moveToLocation(latLng);
  }

  Future<void> _gotoLocation(double lat, double long) async {
    final GoogleMapController controller = await _mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(lat, long),
      zoom: 12,
      tilt: 50.0,
      bearing: 45.0,
    )));
  }
}

Widget _buildDialog(context) {
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
              height: 40,
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Icon(
                Icons.notification_important,
                color: blackColor,
                size: 40,
              ),
            ),
            Container(
              height: 20,
            ),
            Text(
              "Order by another courier\n The order has been placed.",
              style: CustomFontStyle.regularFormTextStyle(blackColor),
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
  );
}
