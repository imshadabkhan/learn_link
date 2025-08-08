import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GuardianController extends GetxController {
  final nameController = TextEditingController();
  final ageController = TextEditingController();

  var gender = ''.obs;
  var isDyslexic = false.obs;
  var hasParentHistory = false.obs;

  List<Map<String, String>> studentHistory = <Map<String, String>>[].obs;

  void registerStudent() {
    if (nameController.text.isEmpty ||
        ageController.text.isEmpty ||
        gender.value.isEmpty) {
      Get.snackbar("Error", "Please fill all fields",
          backgroundColor: Colors.red);
      return;
    }

    studentHistory.add({
      'name': nameController.text,
      'age': ageController.text,
      'gender': gender.value,
      'label': isDyslexic.value ? 'Dyslexic' : 'Not Dyslexic',
      'parent_history': hasParentHistory.value ? 'Yes' : 'No',
    });

    // Clear inputs
    nameController.clear();
    ageController.clear();
    gender.value = '';
    isDyslexic.value = false;
    hasParentHistory.value = false;

    Get.snackbar("Success", "Student registered successfully",
        backgroundColor: Colors.green);
  }

  void toggleLabel(int index) {
    studentHistory[index]['label'] =
    studentHistory[index]['label'] == 'Dyslexic' ? 'Not Dyslexic' : 'Dyslexic';
    update();
  }
}
