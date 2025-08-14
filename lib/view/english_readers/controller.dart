import 'package:get/get.dart';
import 'package:learn_link/core/constants/api_endpoints.dart';
import 'package:learn_link/core/services/http_service.dart';

class EnglishSpeakerModuleController extends GetxController {
  Future submitResult() async {
    var data = {};
    try {
      final response = ApiService.postData(
          endpoint: Endpoints.submitEnglishResult, data: data);
    } catch (e) {}
  }
}
