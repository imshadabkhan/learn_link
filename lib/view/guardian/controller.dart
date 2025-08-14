import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_link/core/constants/api_endpoints.dart';
import 'package:learn_link/core/services/http_service.dart';
import 'package:learn_link/core/widgets/widgets.dart';

class GuardianController extends GetxController {

  RxBool isloading = false.obs;
  var gender = ''.obs;
  var isDyslexic = false.obs;
  RxBool hasParentHistory = false.obs;
RxString selectedGender ='Male'.obs;
  var studentData = <Map<String, dynamic>>[].obs;


  Future registerStudent({
    required String name,
    required String age,
    required String gender,
    required bool ParentHistory,
    required bool isDyslexic,
  }) async {
    Map<String, dynamic> data = {
      "name": name,
      "age": age,
      "gender": gender,
      "parent_history_dyslexia": ParentHistory,
      "is_dyslexic": isDyslexic,
    };

    Widgets.showLoader("Registering Student");
    try {
      final response = await ApiService.postData(
        endpoint: Endpoints.registerStudent,
        data: data,
      );

      if (response["message"] == "Student created successfully") {
        Widgets.hideLoader();
        Get.snackbar(
            "Registration Completed",
            "Student registered successfully"
        );
      } else {
        Widgets.hideLoader();
        Get.snackbar("Error", response["message"].toString());
      }
    } catch (e) {
      Widgets.hideLoader();
      debugPrint("Error registering student: $e");
    }
  }


  Future getRegisteredStudents() async {
    try {
      debugPrint("ger");
      isloading.value = true;
      final response = await ApiService.getData(endPoint: Endpoints.getStudents);

      if (response["students"] == null || (response["students"] as List).isEmpty) {
        debugPrint("No students registered");
      } else {

        studentData.clear();


        studentData.assignAll(
          (response["students"] as List).map((student) {
            return {
              "id": student["_id"],
              "name": student["name"],
              "age": student["age"].toString(),
              "gender": student["gender"],
              "parent_history": student["parent_history_dyslexia"],
              "label": student["dyslexiaLabel"] ?? "unknown",
            };
          }).toList(),
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Get Registered Student ${e.toString()}");
    } finally {
      isloading.value = false;
    }
  }
}



