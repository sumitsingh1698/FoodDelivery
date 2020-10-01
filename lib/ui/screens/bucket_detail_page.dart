import 'dart:ui';
import 'package:background_location/background_location.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:BellyDelivery/constants/Color.dart';
import 'package:BellyDelivery/constants/String.dart';
import 'package:BellyDelivery/constants/Style.dart';
import 'package:BellyDelivery/data/home_page_data.dart';
import 'package:BellyDelivery/models/bucket_detail_response.dart' as detail;
import 'package:BellyDelivery/models/bucket_in_hand_provider_model.dart';
import 'package:BellyDelivery/models/order_delivery_response.dart';
import 'package:BellyDelivery/models/user_provider_model.dart';
import 'package:BellyDelivery/ui/widgets/reward_dialog.dart';

class BucketDetailPage extends StatefulWidget {
  final bucketId;
  final Key stateKey;
  final Function bucketAcceptCallback;

  BucketDetailPage({this.bucketId, this.stateKey, this.bucketAcceptCallback})
      : super(key: stateKey);

  @override
  BucketDetailPageState createState() => BucketDetailPageState();
}

class BucketDetailPageState extends State<BucketDetailPage> {
  bool pressed = false;
  bool _dataLoaded = false;
  String token;
  HomeDataSource _bucketDetailDataSource = new HomeDataSource();
  detail.Order data;

  // UserModel _userModel;
  BucketInHandModel _bucketInHandProvider;

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_bucketInHandProvider == null) {
      _bucketInHandProvider = Provider.of<BucketInHandModel>(context);
      print('bucket inhand provider instatiation');
    }
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    getData();
  }

  void getData() async {
    data = await _bucketDetailDataSource.bucketDetails(token, widget.bucketId);
    setState(() {
      _dataLoaded = true;
    });
    bool temp = false;
    if (data.isPickupStarted) temp = true;
    if (temp)
      _bucketInHandProvider.updateOrderPickUpStatus(true);
    else
      _bucketInHandProvider.updateOrderPickUpStatus(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: !_dataLoaded
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
                ),
              )
            : CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: blackColor,
                    floating: false,
                    pinned: true,
                    expandedHeight: 200.0,
                    iconTheme: IconThemeData(
                      color: whiteColor, //change your color here
                    ),
                    actions: <Widget>[
//              _bucketInHandProvider.getOrderPickUpStatus
//                  ? SpriteAnimation()
//                  : Container(),
                      IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: () {
                          getData();
                        },
                      )
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      // title: Text(
                      //   "There is " + data.count.toString() + "Orders",
                      //   style: CustomFontStyle.regularFormTextStyle(whiteColor),
                      // ),
                      background: Container(
                          child: CarouselSlider.builder(
                        height: 400.0,
                        enableInfiniteScroll: false,
                        autoPlay: false,
                        autoPlayInterval: Duration(seconds: 5),
                        itemCount: 1,
                        itemBuilder: (BuildContext context, int itemIndex) =>
                            data.restaurantImage != null
                                ? Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: CachedNetworkImageProvider(
                                              data.restaurantImage),
                                          fit: BoxFit.cover),
                                    ),
                                    child: new BackdropFilter(
                                      filter: new ImageFilter.blur(
                                          sigmaX: 2.0, sigmaY: 2.0),
                                      child: new Container(
                                        decoration: new BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.0)),
                                      ),
                                    ),
                                  )
                                : Container(),
                      )),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        // print(data.count);
                        return orderItem(data, index);
                      },
                      childCount: 1,
                    ),
                  )
                ],
              ),
      ),
      bottomNavigationBar: _dataLoaded && (!data.bucketAccepted)
          ? _buildBottomButton(context)
          : null,
    );
  }

  Widget orderItem(detail.Order _order, int index) {
    return Container(
      width: 327.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 15.0, top: 15.0, bottom: 10),
            child: Text(
              (index + 1).toString() + ". " + _order.restaurantName,
              style: CustomFontStyle.regularBoldTextStyle(blackColor),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  pickupLocation,
                  style: CustomFontStyle.mediumTextStyle(greyColor),
                ),
                InkWell(
                  onTap: () {
                    launch("tel:${_order.restaurantPhone}");
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.call,
                      color: blackColor,
                      size: 30,
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.location_on,
                color: blackColor,
                size: 16,
              ),
              SizedBox(
                width: 4,
              ),
              Expanded(
                child: Text(
                  _order.pickUpAddress,
                  style: CustomFontStyle.mediumTextStyle(blackColor),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 15.0, bottom: 8),
            child: Text(
              orderContents,
              style: CustomFontStyle.regularFormTextStyle(greyColor),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 15,
              ),
              Text(
                "ID " + _order.orderNo,
                style: CustomFontStyle.mediumTextStyle(blackColor),
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                _order.user.name,
                style: CustomFontStyle.mediumTextStyle(blackColor),
              ),
              SizedBox(
                width: 15,
              ),
              Text(
                _order.slottime.substring(11, 16),
                style: CustomFontStyle.mediumTextStyle(blackColor),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              launch("tel:${_order.userPhone}");
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 10.0, bottom: 8),
              child: Text(
                callCustomer,
                style: CustomFontStyle.regularFormTextStyle(blueColor),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 1,
              color: cloudsColor,
            ),
          ),
          Padding(
              padding: EdgeInsets.only(left: 15.0, right: 15.0),
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: _order.orderitems.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) => Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                _order.orderitems[index].itemName +
                                    " x " +
                                    _order.orderitems[index].count.toString(),
                                style: TextStyle(color: blackColor),
                              ),
                            ),
                            Text(
                              "₹ " +
                                  _order.orderitems[index].itemPrice.toString(),
                              style: TextStyle(color: blackColor),
                            )
                          ],
                        ),
                      ))),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 1,
              color: cloudsColor,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 15.0, right: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  subTotal,
                  style: TextStyle(color: greyColor),
                ),
                Text(
                  "   ₹ " + _order.grandtotal.toString(),
                  style: TextStyle(color: greyColor),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  totalAmount,
                  style: TextStyle(color: blackColor),
                ),
                Text(
                  "   ₹ " + _order.grandtotal.toString(),
                  style: TextStyle(color: blackColor),
                ),
              ],
            ),
          ),
          Container(
            height: 1,
            color: cloudsColor,
          ),
          Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  dropLocation,
                  style: CustomFontStyle.mediumTextStyle(greyColor),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Icon(
                      Icons.location_on,
                      color: blackColor,
                      size: 16,
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    Expanded(
                      child: Text(
                        _order.deliveryAddress,
                        style: CustomFontStyle.mediumTextStyle(blackColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          //Padding(padding: EdgeInsets.only(top: 50.0)),
          data.bucketAccepted &&
                  _order.isPickupStarted &&
                  (!_order.isOrderCancel)
              ? InkWell(
                  onTap: () async {
                    print('hgdjgsvjgfvjsfdgvc ${widget.bucketId}');
                    print('order ID ${_order.id}');
                    OrderDeliveryResponse _orderDeliveredRes =
                        await _bucketDetailDataSource.orderDeliveryStatusChange(
                            token, widget.bucketId, _order.id);

                    if (_orderDeliveredRes.lastOrder) {
                      showRewardDialog(context, _orderDeliveredRes.reward);
                      Provider.of<UserModel>(context, listen: false)
                          .getPendingCashData(token);
                      _bucketInHandProvider.updateBucketInHandStatus(false);
                      var res = await _bucketDetailDataSource
                          .startStopLocationSharing(
                              token, widget.bucketId, "False");
                      if (res[0]) {
                        BackgroundLocation.stopLocationService();
                      }
                    } else if (_orderDeliveredRes.status) getData();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: greenBellyColor,
                      shape: BoxShape.rectangle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: double.infinity,
                        height: 50,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Text(
                                      _order.isDeliveredOrder
                                          ? delivered
                                          : confirmDelivery,
                                      style: CustomFontStyle.buttonTextStyle(
                                          blackColor),
                                    ),
                                    Text(
                                      _order.paymentMethod == "COD"
                                          ? collectCash
                                          : "",
                                      style: CustomFontStyle.smallTextStyle(
                                          whiteColor),
                                    ),
                                  ],
                                ),
                                _order.isDeliveredOrder
                                    ? SizedBox(
                                        width: 10,
                                      )
                                    : Container(),
                                Icon(Icons.check_circle,
                                    color: _order.isDeliveredOrder
                                        ? blackColor
                                        : yellow)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              data.bucketAccepted &&
                      !_order.isOrderCancel &&
                      !_order.isDeliveredOrder
                  ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () async {
                          bool _shouldCancel = await showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return Theme(
                                  data: ThemeData.light(),
                                  child: CupertinoAlertDialog(
                                    content: Text(
                                      doYouWantToCancelOrder,
                                      style: CustomFontStyle.mediumTextStyle(
                                          blackColor),
                                    ),
                                    actions: <Widget>[
                                      CupertinoDialogAction(
                                        child: const Text(yes),
                                        onPressed: () {
                                          Navigator.pop(context, true);
                                        },
                                      ),
                                      CupertinoDialogAction(
                                        child: const Text(no),
                                        onPressed: () {
                                          Navigator.pop(context, false);
                                        },
                                      ),
                                    ],
                                  ));
                            },
                          );
                          if (_shouldCancel) {
                            OrderDeliveryResponse _orderCancelledRes =
                                await _bucketDetailDataSource
                                    .orderCancelledStatusChange(
                                        token, widget.bucketId, _order.id);

                            if (_orderCancelledRes.lastOrder) {
                              showRewardDialog(
                                  context, _orderCancelledRes.reward);
                              Provider.of<UserModel>(context, listen: false)
                                  .getPendingCashData(token);
                              _bucketInHandProvider
                                  .updateBucketInHandStatus(false);
                              var res = await _bucketDetailDataSource
                                  .startStopLocationSharing(
                                      token, widget.bucketId, "False");
                              // Utils.showSnackBar(_key, res[1]);
                              if (res[0]) {
                                BackgroundLocation.stopLocationService();
                              }
                            } else if (_orderCancelledRes.status) getData();
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Icon(Icons.not_interested, color: blackColor),
                            Text(
                              cancelDelivery,
                              style: TextStyle(
                                color: blackColor,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'NotoSansJP',
                                fontSize: 12.0,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container(),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBottomButton(context) {
    return InkWell(
      onTap: () async {
        bool _bucketAccepted = await _bucketDetailDataSource.bucketStatusChange(
            token, widget.bucketId);
        if (_bucketAccepted) {
          getData();
          widget.bucketAcceptCallback();
        } else
          showDialog(
              context: context,
              builder: (BuildContext context) => _buildDialog(context));
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    data.bucketAccepted ? accepted : accept,
                    style: CustomFontStyle.bottomButtonTextStyle(whiteColor),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.check_circle,
                      color: data.bucketAccepted ? yellow : blackColor)
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
}
