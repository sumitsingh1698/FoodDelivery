import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:BellyDelivery/constants/Style.dart';
import 'package:BellyDelivery/constants/String.dart';
import 'package:BellyDelivery/data/sales_page_data.dart';
import 'package:BellyDelivery/models/sales_response.dart';
import 'package:BellyDelivery/ui/widgets/custom_close_app_bar.dart';
import 'package:BellyDelivery/constants/Color.dart';

class MySalesPage extends StatefulWidget {
  @override
  _MySalesPageState createState() => _MySalesPageState();
}

class _MySalesPageState extends State<MySalesPage> {
  SalesResponse data;
  String token;
  bool _initialDataLoading = true;
  bool _dataLoaded = true;
  SalesPageData _salesPageDataSource = new SalesPageData();

  @override
  void initState() {
    super.initState();
    getSharedPrefs();
  }

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    getData();
  }

  void getData() async {
    print('inside get DATA');
    data = await _salesPageDataSource.getCurrentSales(token);
    print('get data dat ${data.buckets}');

    setState(() {
      _initialDataLoading = false;
    });
  }

  void getLeftData(String _date) async {
    setState(() {
      _dataLoaded = false;
    });
    data = await _salesPageDataSource.getSalesLeft(token, _date);
    setState(() {
      _dataLoaded = true;
    });
  }

  void getRightData(String _date) async {
    setState(() {
      _dataLoaded = false;
    });
    data = await _salesPageDataSource.getSalesRight(token, _date);
    setState(() {
      _dataLoaded = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomCloseAppBar(
        title: sales,
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
                    !_initialDataLoading
                        ? buildInfoDetail()
                        : CupertinoActivityIndicator(),
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
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(
                left: 24.0, right: 24.0, top: 16.0, bottom: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    getLeftData(data.startOfWeek);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 6.0),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                      size: 24.0,
                    ),
                  ),
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        data.startOfWeek + " - " + data.endOfWeek,
                        style: CustomFontStyle.smallTextStyle(blackColor),
                      ),
                      Text(
                        "₹ " + data.totalReward.toString(),
                        style: CustomFontStyle.mediumBoldTextStyle(blackColor),
                      ),
                    ]),
                GestureDetector(
                  onTap: () {
                    getRightData(data.endOfWeek);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 6.0),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                      size: 24.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          width: double.infinity,
          color: cloudsColor,
          child: Padding(
            padding: EdgeInsets.only(
                left: 24.0, right: 24.0, top: 16.0, bottom: 16.0),
            child: Row(
              children: <Widget>[
                Text(
                  data.text,
                  textAlign: TextAlign.center,
                  style: CustomFontStyle.smallTextStyle(blackColor),
                ),
              ],
            ),
          ),
        ),
        !_dataLoaded
            ? Center(
                child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: CupertinoActivityIndicator()),
              )
            : data.buckets == null || data.buckets.length == 0
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        noBucketsTheseDays,
                        style: CustomFontStyle.regularFormTextStyle(blackColor),
                      ),
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(vertical: 15.0),
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount:
                          data.buckets.length == null ? 0 : data.buckets.length,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) =>
                          Container(
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: 24.0, right: 24.0, top: 16.0, bottom: 16.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Expanded(
                                    child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: 1,
                                        shrinkWrap: true,
                                        physics: ClampingScrollPhysics(),
                                        itemBuilder: (BuildContext context,
                                                int i) =>
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Text(
                                                    "ID " +
                                                        "${data.buckets[index].orderNo}",
                                                    style: CustomFontStyle
                                                        .regularFormTextStyle(
                                                            blackColor),
                                                  ),
                                                  Text(
                                                    "${data.buckets[index].restaurantName}",
                                                    style: CustomFontStyle
                                                        .regularFormTextStyle(
                                                            blackColor),
                                                  ),
                                                ],
                                              ),
                                            )),
                                  ),
                                  Column(
                                    //crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        data.buckets[index].bucketAcceptedTime
                                                .substring(0, 4) +
                                            "/" +
                                            data.buckets[index]
                                                .bucketAcceptedTime
                                                .substring(5, 7) +
                                            "/" +
                                            data.buckets[index]
                                                .bucketAcceptedTime
                                                .substring(8, 10),
                                        style: CustomFontStyle
                                            .regularFormTextStyle(greyColor),
                                      ),
                                      Text(
                                        "₹ " +
                                            data.buckets[index].reward
                                                .toInt()
                                                .toString(),
                                        style: CustomFontStyle
                                            .regularBoldTextStyle(blackColor),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Container(
                                height: 1,
                                color: cloudsColor,
                              )
                            ],
                          ),
                        ),
                      ),
                    )),
      ],
    );
  }
}
