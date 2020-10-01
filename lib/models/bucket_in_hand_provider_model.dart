import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BucketInHandModel extends ChangeNotifier {
  BucketInHandModel() {
    getSharedPrefs();
  }

  /// Internal, private state of the cart.
  bool bucketInHand = false;
  bool orderPickUpStarted = false;
  String bucketId;
  int bucketNumber = 0;

  void getCurrentCartData(token) async {}

  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      String token = prefs.getString('token');
      getCurrentCartData(token);
    } on Exception catch (error) {
      print(error);
      return null;
    }
  }

  void updateBucketInHandStatus(bool flag) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('bucketInHand', flag);
    bucketInHand = flag;
    if (!flag) orderPickUpStarted = false;
    notifyListeners();
  }

  bool get getOrderPickUpStatus => orderPickUpStarted;

  void updateOrderPickUpStatus(bool flag) {
    orderPickUpStarted = flag;
    notifyListeners();
  }

  int get getBucketNumber => bucketNumber;

  void updateBucketNumber() {
    bucketNumber++;
    notifyListeners();
  }
}
