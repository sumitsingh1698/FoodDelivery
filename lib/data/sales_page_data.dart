import 'package:BellyDelivery/models/sales_response.dart';
import 'package:BellyDelivery/utils/base_url.dart';
import 'package:BellyDelivery/utils/network_utils.dart';

class SalesPageData {
  NetworkUtil _netUtil = new NetworkUtil();
  static final baseUrl = BaseUrl().mainUrl;
  static final String salesUrl = baseUrl + "sales/";

  Future<SalesResponse> getCurrentSales(String token) {
    print('Req is ?date=2020-02-19&start=false&end=false ,token is $token');
    String url = salesUrl + "?date=2020-02-19&start=false&end=false";
    return _netUtil.getNewOrders(url, token).then((dynamic res) async {
      print('Res is $res');
      SalesResponse response = SalesResponse.fromJson(res);
      return response;
    });
  }

  Future<SalesResponse> getSalesLeft(String token, String date) {
    String url = salesUrl + "?date=$date&start=true&end=false";
    return _netUtil.getNewOrders(url, token).then((dynamic res) async {
      print('response of my sales page is $res');
      SalesResponse response = SalesResponse.fromJson(res);
      return response;
    });
  }

  Future<SalesResponse> getSalesRight(String token, String date) {
    String url = salesUrl + "?date=$date&start=false&end=true";
    return _netUtil.getNewOrders(url, token).then((dynamic res) async {
      SalesResponse response = SalesResponse.fromJson(res);
      return response;
    });
  }
}
