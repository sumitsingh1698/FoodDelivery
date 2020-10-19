import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:BellyDelivery/constants/Constants.dart';
import 'package:BellyDelivery/data/my_profile_data.dart';

class UserModel with ChangeNotifier {
  UserModel() {
    getInitialData();
  }

  User user;
  String cashCollected = "0";
  String pendingReward = "0";
  bool loading = false;

  void getMyProfileData(token) async {
    ProfileDataSource _profileData = new ProfileDataSource();
    var _response = await _profileData.getMyProfileData(token);
    if (_response[0] == true) user = _response[1];
  }

  void getPendingCashData(token) async {
    ProfileDataSource _profileData = new ProfileDataSource();
    var _response = await _profileData.getPendingCashData(token);
    if (_response[0] == true) {
      cashCollected = _response[1]['pending_collected_cash'].toString();
      pendingReward = _response[1]['pending_reward'].toString();
    }
  }

  User get getUser => user;

  Future<Null> getInitialData() async {
    print('initial data');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      String token = prefs.getString('token');
      print("|$token|");
      if (token != '') {
        getMyProfileData(token);
        getPendingCashData(token);
      }
    } on Exception catch (error) {
      print(error);
      return null;
    }
  }

  void updateUser(User _user) {
    user.id = _user.id;
    user.firstName = _user.firstName;
    user.lastName = _user.lastName;
    user.emailAddress = _user.emailAddress;
    user.campus = _user.campus;
    user.phone = _user.phone;
    user.profilePic = _user.profilePic;
    user.countryPrefix = _user.countryPrefix;
    notifyListeners();
  }

  void logout() async {
    user = null;
    cashCollected = "0";
    pendingReward = "0";
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user_phone', '');
    prefs.setBool('loggedIn', false);
    prefs.remove('verify');
    prefs.setString('token', "");
    prefs.setString('user_name', "");
    prefs.setString('last_name', "");
  }
}

class User {
  int id;
  String firstName;
  String lastName;
  String emailAddress;
  Campus campus;
  String phone;
  String profilePic;
  String countryPrefix;

  User(
      {this.id,
      this.firstName,
      this.lastName,
      this.emailAddress,
      this.campus,
      this.phone,
      this.profilePic,
      this.countryPrefix});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    emailAddress = json['email_address'];
    campus =
        json['campus'] != null ? new Campus.fromJson(json['campus']) : null;
    phone = json['phone'];
    profilePic = json['profile_pic'] ?? userImageUrl;
    countryPrefix = json['country_prefix'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email_address'] = this.emailAddress;
    if (this.campus != null) {
      data['campus'] = this.campus.toJson();
    }
    data['phone'] = this.phone;
    data['profile_pic'] = this.profilePic;
    data['country_prefix'] = this.countryPrefix;
    return data;
  }
}

class Campus {
  String name;
  University university;
  String slug;

  Campus({this.name, this.university, this.slug});

  Campus.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    university = json['university'] != null
        ? new University.fromJson(json['university'])
        : null;
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    if (this.university != null) {
      data['university'] = this.university.toJson();
    }
    data['slug'] = this.slug;
    return data;
  }
}

class University {
  String name;
  String slug;
  int id;

  University({this.name, this.slug, this.id});

  University.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    slug = json['slug'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['slug'] = this.slug;
    data['id'] = this.id;
    return data;
  }
}
