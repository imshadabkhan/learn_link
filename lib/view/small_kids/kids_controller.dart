import 'package:get/get.dart';
import 'package:learn_link/core/constants/api_endpoints.dart';
import 'package:learn_link/core/routes/app_routes.dart';
import 'package:learn_link/core/services/http_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class KidsController extends GetxController {
  Future<void> SubmitKidsReport(BuildContext context, bool? diagnosedDyslexic) async {
    try {
      // Load saved scores
      final prefs = await SharedPreferences.getInstance();

      var kidsData = {
        "diagnosedDyslexic": diagnosedDyslexic,
        "studentId": prefs.getString('id'),
        "age": prefs.getString("age"),
        "tasks": {
          "phonemeMatching": {
            "score": prefs.getInt("phonemeMatchingScore") ?? 0,
            "time": prefs.getDouble("phonemeMatchingScoreTime") ?? 0.0,
            "errors": prefs.getInt("phonemeMatchingErrors") ?? 0
          },
          "letterRecognition": {
            "score": prefs.getInt("letterRecognitionScore") ?? 0,
            "time": prefs.getDouble("letterRecognitionTime") ?? 0.0,
            "errors": prefs.getInt("letterRecognitionErrors") ?? 0
          },
          "attention": {
            "score": prefs.getInt("numberSequenceScore") ?? 0,
            "time": prefs.getDouble("numberSequenceTime") ?? 0.0,
            "errors": prefs.getInt("numberSequenceErrors") ?? 0
          },
          "patternMemory": {
            "score": prefs.getInt("memoryPatterScore") ?? 0,
            "time": prefs.getDouble("memoryPatterTime") ?? 0.0,
            "errors": prefs.getInt("memoryPatterErrors") ?? 0
          }
        }
      };

      // Send to backend
      final response = await ApiService.postData(
        data: kidsData,
        endpoint: Endpoints.submitKidsResult,
      );

      if (response != null && response["success"] == true) {
        // Show diagnosis result
        _showDiagnosisDialog(context, response["data"]);
      } else {
        Get.snackbar("Error", "Failed to submit kids report");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  void _showDiagnosisDialog(BuildContext context, Map<String, dynamic> data) {
    bool diagnosed = data["diagnosedDyslexic"];
    bool modelDiagnosis = data["diagnosedByModel"] ?? false;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          diagnosed
              ? "Possible Dyslexia Detected"
              : "No Signs of Dyslexia",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: diagnosed ? Colors.orange : Colors.green,
          ),
        ),
        content: SizedBox(
          height: 220,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                diagnosed
                    ? "Our assessment indicates signs of dyslexia. This is not a final diagnosis — please consult a professional."
                    : "Based on the test, no signs of dyslexia were detected.",
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              SizedBox(height: 16),
              Text("Scores Summary:", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
              SizedBox(height: 8),
              Text("Phoneme Matching: ${data["tasks"]["phonemeMatching"]["score"]}",style: TextStyle(color: Colors.black),),
              Text("Letter Recognition: ${data["tasks"]["letterRecognition"]["score"]}",style: TextStyle(color: Colors.black),),
              Text("Attention: ${data["tasks"]["attention"]["score"]}",style: TextStyle(color: Colors.black),),
              Text("Pattern Memory: ${data["tasks"]["patternMemory"]["score"]}",style: TextStyle(color: Colors.black),),
              SizedBox(height: 8),
              Text("Model Diagnosis: $modelDiagnosis", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),

            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.toNamed(AppRoutes.guardianDashboard),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }
}
