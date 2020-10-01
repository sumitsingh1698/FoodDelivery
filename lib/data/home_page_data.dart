import 'dart:async';
import 'package:BellyDelivery/models/bucket_detail_response.dart' as detail;
import 'package:BellyDelivery/models/bucket_notification_response.dart';
import 'package:BellyDelivery/models/order_delivery_response.dart';
import 'package:BellyDelivery/utils/network_utils.dart';
import 'package:BellyDelivery/utils/base_url.dart';

class HomeDataSource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final baseUrl = BaseUrl().mainUrl;
  static final userOnlineStatusUrl = baseUrl + "status/";
  static final newBucketList = baseUrl + "listorder/";
  static final bucketDetailUrl = baseUrl + "orderdetails/";
  static final bucketAcceptUrl = baseUrl + "orderaccept/";
  static final orderDeliveryCompletedUrl = baseUrl + "orderdelivered/";
  static final orderCancelUrl = baseUrl + "cancelorder/";
  static final isTrackingEnabledUrl = baseUrl + "tracking/";
  static final checkTrackingUrl = baseUrl + "checktracking/";
  static final shareLocationStatusChangeUrl = baseUrl + "savelocationstatus/";

  Future<BucketNotificationResponse> getNewOrders(token) {
    return _netUtil
        .getNewOrders(newBucketList, token)
        .then((dynamic res) async {
      BucketNotificationResponse response =
          BucketNotificationResponse.fromJson(res);
      print(res);
      return response;
    });
  }

  Future<detail.Order> bucketDetails(token, bucketId) {
    print('Order Id for order details $bucketId');
    String url = bucketDetailUrl + "?id=$bucketId";
    return _netUtil.getNewOrders(url, token).then((dynamic res) async {
      print('response of bucket detail is $res');
      detail.Order response = detail.Order.fromJson(res);
      return response;
    });
  }

  Future<bool> userStatusChange(token, status) {
    String url = baseUrl + "$status/";
    return _netUtil.postStatusChange(url, token).then((dynamic res) async {
      if (res['status']) {
        return true;
      } else {
        return false;
      }
    });
  }

  Future<bool> userOnlineStatus(token) {
    return _netUtil
        .getNewOrders(userOnlineStatusUrl, token)
        .then((dynamic res) async {
      if (res['status']) {
        return true;
      } else {
        return false;
      }
    });
  }

  Future<bool> bucketStatusChange(token, bucketId) {
    String url = bucketAcceptUrl + "?id=$bucketId";
    return _netUtil.postStatusChange(url, token).then((dynamic res) async {
      print('Bucket Status is changed to $res');
      if (res['status']) {
        return true;
      } else {
        return false;
      }
    });
  }

  Future<OrderDeliveryResponse> orderDeliveryStatusChange(
      token, bucketId, orderId) {
    print('bucket Id is !!!!!!!!! $bucketId');
    print('order Id is !!!!!!!!  $orderId');
    String url = orderDeliveryCompletedUrl;
    Map body = {"order_id": "$orderId"};
    return _netUtil
        .getStatusChangeConfirm(url, token, body)
        .then((dynamic res) async {
      OrderDeliveryResponse response = OrderDeliveryResponse.fromJson(res);
      return response;
    });
  }

  Future<OrderDeliveryResponse> orderCancelledStatusChange(
      token, bucketId, orderId) {
    String url = orderCancelUrl + "?bucket_id=$bucketId" + "&order_id=$orderId";
    return _netUtil.deliveryStatusChange(url, token).then((dynamic res) async {
      OrderDeliveryResponse response = OrderDeliveryResponse.fromJson(res);
      return response;
    });
  }

  Future<bool> isTrackingEnabled(token, bucketId) {
    String url = isTrackingEnabledUrl + "?bucket_id=$bucketId";
    return _netUtil.isTrackingEnabled(url, token).then((dynamic res) async {
      if (res['status']) {
        return true;
      } else {
        return false;
      }
    });
  }

  Future<Map> checkTrackingEnabled(token) {
    return _netUtil
        .isTrackingEnabled(checkTrackingUrl, token)
        .then((dynamic res) async {
      return res;
    });
  }

  Future<List> startStopLocationSharing(token, bucketId, status) {
    print("order ID $bucketId ");
    String url = shareLocationStatusChangeUrl +
        "?order_id=$bucketId" +
        "&status=$status";
    return _netUtil.postStatusChange(url, token).then((dynamic res) async {
      if (res['status']) {
        return [true, res['delivery_staff']];
      } else {
        print("tracking share location $res");
        return [false, res['message']];
      }
    });
  }
}
