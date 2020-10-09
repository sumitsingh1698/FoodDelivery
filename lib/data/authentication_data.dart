import 'dart:async';
import 'package:BellyDelivery/constants/Constants.dart';
import 'package:BellyDelivery/utils/network_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:BellyDelivery/utils/base_url.dart';

class AuthDataSource {
  NetworkUtil _netUtil = new NetworkUtil();
  static final baseUrl = BaseUrl().mainUrl;
  static final loginAuthUrl = baseUrl + "delilogin/";
  static final verifyPhone = baseUrl + "verifyphone/";
  static final sendOtp = baseUrl + "sendotp/";
  static final sendSignUpOtp = baseUrl + "generateotp/";
  static final verifyOtp = baseUrl + "verifyotp/";
  static final signUpVerifyOtp = baseUrl + "signup_verifyotp/";
  static final signUpFormPost = baseUrl + "usersignup/";
  static final resetPassUrl = baseUrl + "resetpassword/";
  static final sendFcmTokenUrl = baseUrl + "fcmdeliuser/";

  Future<bool> signUpPhoneValidation(phone, countryDialCode) {
    String url = verifyPhone + "?phone=$phone";

    return _netUtil.signUpPhoneValidation(url).then((dynamic res) async {
      if (res['status']) {
        return false;
      } else {
        return true;
      }
    });
  }

  Future<List> sendSignUpOtpCode(phone) {
    Map<String, String> body = {
      'mobile': phone,
      'country_code': countryCode,
    };

    return _netUtil.sendOtp(sendSignUpOtp, body).then((dynamic res) async {
      if (res['status']) {
        return [true];
      } else {
        return [false, res['message']];
      }
    });
  }

  Future<bool> sendOtpCode(phone) {
    Map<String, String> body = {
      'mobile': phone,
      'country_code': countryCode,
    };

    return _netUtil.sendOtp(sendOtp, body).then((dynamic res) async {
      if (res['status']) {
        return true;
      } else {
        return false;
      }
    });
  }

  Future<bool> verifyOtpCode(phone, otp) {
    Map<String, String> body = {
      'mobile': phone,
      'country_code': countryCode,
      'otp': otp
    };

    return _netUtil.sendOtp(verifyOtp, body).then((dynamic res) async {
      if (res['status']) {
        return true;
      } else {
        return false;
      }
    });
  }

  Future<bool> signUpOtpAuthentication(data) {
    return _netUtil
        .signUpOtpAuthentication(signUpVerifyOtp, data)
        .then((dynamic res) async {
      print('Response of Sign Up is $res');
      if (res['status']) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        print('TOKENID:${res['token']}');
        prefs.setString('token', res['token']);
        prefs.setBool('loggedIn', true);
        prefs.setString('user_name', res['name']);
        prefs.setString('last_name', res['surname']);
        prefs.setString('user_phone', res['phonenumber']);
        // prefs.setString('user_university', res['university']);
        // prefs.setString('user_campus', res['campus']);
        prefs.setBool('userStatus', true);
        prefs.setBool('bucketInHand', false);
        prefs.setBool('verify', res['verified']);
        return true;
      } else {
        return false;
      }
    });
  }

  Future<bool> loginPasswordAuthentication(phone, password) {
    Map<String, String> body = {
      'phone': phone,
      'password': password,
    };
    print(body);
    return _netUtil
        .loginPasswordAuthentication(loginAuthUrl, body)
        .then((dynamic res) async {
      print('sigin response is $res');
      if (res['status']) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', res['token']);
        prefs.setBool('loggedIn', true);
        prefs.setString('user_name', res['name']);
        prefs.setString('last_name', res['surname']);
        prefs.setString('user_phone', res['phonenumber']);
        prefs.setBool('verify', res['verified']);
        return true;
      } else {
        return false;
      }
    });
  }

  Future<bool> sendFCMToken(token, fcmToken) {
    Map<String, String> body = {'fcm_token': fcmToken};
    return _netUtil
        .postFCMToken(sendFcmTokenUrl, token, body)
        .then((dynamic res) async {
      if (res['status']) {
        return true;
      } else {
        return false;
      }
    });
  }

  Future<bool> passwordResetPhoneValidation(phone, countryDialCode) {
    String url = verifyPhone + "?phone=$phone";

    return _netUtil.signUpPhoneValidation(url).then((dynamic res) async {
      if (res['status']) {
        return true;
      } else {
        return false;
      }
    });
  }

  Future<bool> resetPassword(phone, password) {
    Map<String, String> body = {
      'mobile': phone,
      'password': password,
    };
    return _netUtil
        .loginPasswordAuthentication(resetPassUrl, body) //not changed
        .then((dynamic res) async {
      if (res['status']) {
        return true;
      } else {
        return false;
      }
    });
  }
}
