import 'package:BellyDelivery/utils/base_url.dart';
import 'package:BellyDelivery/utils/network_utils.dart';

class ListData {
  NetworkUtil _netUtil = new NetworkUtil();
  static final baseUrl = BaseUrl().mainUrl;
  static final String campusListUrl =
      "http://15.207.180.104/userapp/campuslist/";
  static final String universityList =
      "http://15.207.180.104/userapp/universitylist/";

  Future<Map> getCampuses(String universitySlug) {
    String url = campusListUrl + "?slug=$universitySlug";
    return _netUtil.getCampuses(url).then((dynamic res) async {
      return res;
    });
  }

  Future<Map> getUniversities() {
    return _netUtil.getUniversities(universityList).then((dynamic res) async {
      return res;
    });
  }
}
