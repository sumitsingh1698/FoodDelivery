import 'dart:async';

import 'package:BellyDelivery/models/user_provider_model.dart';
import 'package:BellyDelivery/utils/base_url.dart';
import 'package:BellyDelivery/utils/network_utils.dart';

class ProfileDataSource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final baseUrl = BaseUrl().mainUrl;
  static final myProfileDataUrl = baseUrl + "myprofile/";
  static final changePasswordUrl = baseUrl + "changepassword/";
  static final cashPendingUrl = baseUrl + "rewardcashcollected/";

  Future<List> getMyProfileData(token) {
    return _netUtil
        .getNewOrders(myProfileDataUrl, token)
        .then((dynamic res) async {
      print("getMyProfileData $res");
      User response;
      if (res['results'].isNotEmpty) {
        response = User.fromJson(res['results'][0]);
      }

      if (response != null) {
        return [true, response];
      } else {
        return [false, "No data"];
      }
    });
  }

  Future<List> getPendingCashData(token) {
    return _netUtil
        .getNewOrders(cashPendingUrl, token)
        .then((dynamic res) async {
      if (res['status']) {
        return [true, res['reward_cod']];
      } else {
        return [false, "0"];
      }
    });
  }

  Future<bool> changePassword(token, password, newPassword) {
    Map<String, String> body = {
      'old_password': password,
      'new_password': newPassword
    };
    return _netUtil
        .putData(
      changePasswordUrl,
      body,
      token,
    )
        .then((dynamic res) async {
      print(res.toString());
      return res['status'];
    });
  }
}
