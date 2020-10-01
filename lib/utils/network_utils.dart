import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkUtil {
  static NetworkUtil _instance = new NetworkUtil.internal();

  NetworkUtil.internal();

  factory NetworkUtil() => _instance;

  Future<dynamic> signUpPhoneValidation(String url) async {
    var response = await http.get(url);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(response.body);
    return parsed;
  }

  Future<dynamic> sendOtp(String url, data) async {
    var _body = json.encode(data);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: _body);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(response.body);
    return parsed;
  }

  Future<dynamic> signUpOtpAuthentication(String url, data) async {
    var _body = json.encode(data);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: _body);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      final Map parsed = json.decode(utf8.decode(response.bodyBytes));
      print('signup otp $parsed');
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    print(parsed);
    return parsed;
  }

  Future<dynamic> loginPasswordAuthentication(String url, data) async {
    var _body = json.encode(data);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: _body);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    return parsed;
  }

  Future<dynamic> getCampuses(String url) async {
    var response = await http.get(url);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    return parsed;
  }

  Future<dynamic> getUniversities(String url) async {
    var response = await http.get(url);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    return parsed;
  }

  Future<dynamic> getUserRestaurants(String url, token) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Authorization': "Token " + token
    };
    var response = await http.get(url, headers: requestHeaders);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    return parsed;
  }

  Future<dynamic> postLoginRequest(String url, data) async {
    var _body = json.encode(data);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: _body);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    return parsed;
  }

  Future<dynamic> signUpFormSubmission(String url, data) async {
    var _body = json.encode(data);
    var response = await http.post(url,
        headers: {"Content-Type": "application/json"}, body: _body);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(response.body);
    return parsed;
  }

  Future<dynamic> getNewOrders(String url, token) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Authorization': "Token " + token
    };
    var response = await http.get(url, headers: requestHeaders);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      final Map parsed = json.decode(utf8.decode(response.bodyBytes));
      print(parsed);
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    return parsed;
  }

  Future<dynamic> isTrackingEnabled(String url, token) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Authorization': "Token " + token
    };
    var response = await http.get(url, headers: requestHeaders);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    return parsed;
  }

  Future<dynamic> deliveryStatusChange(String url, token) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Authorization': "Token " + token
    };
    var response = await http.post(url, headers: requestHeaders);
    final int statusCode = response.statusCode;
    print(response.body.toString());
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    return parsed;
  }

  Future<dynamic> postStatusChange(String url, token) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Authorization': "Token " + token
    };
    var response = await http.post(url, headers: requestHeaders);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    return parsed;
  }

  Future<dynamic> getStatusChangeConfirm(String url, token, _body) async {
    Map<String, String> requestHeaders = {
      // 'Content-type': 'application/json',
      'Authorization': "Token " + token
    };
    var response = await http.post(url, headers: requestHeaders, body: _body);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      final Map parsed = json.decode(utf8.decode(response.bodyBytes));
      print('parsed data of confirm $parsed');
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    print('parsed data of confirm $parsed');
    return parsed;
  }

  Future<dynamic> clearCartItems(String url, String token) async {
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Authorization': "Token " + token
    };
    var response = await http.get(url, headers: requestHeaders);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    return parsed;
  }

  Future<dynamic> postFCMToken(String url, token, data) async {
    var _body = json.encode(data);
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Authorization': "Token " + token
    };
    var response = await http.post(url, headers: requestHeaders, body: _body);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    return parsed;
  }

  Future<dynamic> putData(String url, data, token) async {
    var _body = json.encode(data);
    Map<String, String> requestHeaders = {
      'Content-type': 'application/json',
      'Authorization': "Token " + token
    };
    var response = await http.put(url, headers: requestHeaders, body: _body);
    final int statusCode = response.statusCode;
    if (statusCode < 200 || statusCode > 400 || json == null) {
      throw new Exception("Error while fetching data");
    }
    final Map parsed = json.decode(utf8.decode(response.bodyBytes));
    return parsed;
  }
}
