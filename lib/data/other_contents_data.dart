import 'package:BellyDelivery/models/other_content_model.dart';
import 'package:BellyDelivery/utils/base_url.dart';
import 'package:BellyDelivery/utils/network_utils.dart';

class OtherContentsData {
  NetworkUtil _netUtil = new NetworkUtil();
  static final String baseUrl = BaseUrl().mainUrl;
  static final String helpContents = baseUrl + "help/";
  static final String aboutContents = baseUrl + "aboutwasedari/";
  static final String paymentContents = baseUrl + "payment/";

  Future<OtherContentModel> getHelpContents() {
    return _netUtil.getUniversities(helpContents).then((dynamic res) async {
      OtherContentModel response;
      if (res['results'].isNotEmpty) {
        response = OtherContentModel.fromJson(res['results'][0]);
      }
      return response;
    });
  }

  Future<OtherContentModel> getAboutWasederiContents() {
    return _netUtil.getUniversities(aboutContents).then((dynamic res) async {
      OtherContentModel response;
      if (res['results'].isNotEmpty) {
        response = OtherContentModel.fromJson(res['results'][0]);
      }
      return response;
    });
  }

  Future<OtherContentModel> getPaymentContents() {
    return _netUtil.getUniversities(paymentContents).then((dynamic res) async {
      OtherContentModel response;
      if (res['results'].isNotEmpty) {
        response = OtherContentModel.fromJson(res['results'][0]);
      }
      return response;
    });
  }
}
