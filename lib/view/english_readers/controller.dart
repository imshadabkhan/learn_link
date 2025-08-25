import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_link/controller/usercontroller.dart';
import 'package:learn_link/core/constants/api_endpoints.dart';
import 'package:learn_link/core/services/http_service.dart';
import 'package:learn_link/view/bottom_bar/bottomnavbar.dart';
import 'package:learn_link/view/english_readers/user_homepage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EnglishReaderController extends GetxController {
  final userController = Get.find<UserController>();
  var studentId;


  Future<void> SubmitReport({
    required BuildContext context,
    bool? diagnosedDyslexic,
    required int ageStartedReading,userAge,familyHistoryOfDyslexia
  }) async {
    try {
      // Load saved scores
      final prefs = await SharedPreferences.getInstance();














    var studentData = {
    "student": prefs.getString('role') == 'user'
    ? prefs.getString('id')
        : prefs.getString('studentId'),
    "age": prefs.getString('role') == 'user'
    ? userAge ?? 9
        : int.tryParse(prefs.getString("studentAge") ?? "5") ?? 5,
        "letterReversalCount": prefs.getInt("letterReversalErrorCount") ?? 0,
        "ageStartedReading": ageStartedReading,
        "familyHistoryOfDyslexia":
        prefs.getString('role') == 'guardian' ? prefs.getBool("familyHistoryOfDyslexia") : familyHistoryOfDyslexia,

        "diagnosedDyslexic": diagnosedDyslexic,
        "phonemeMatching": {
          "score": prefs.getInt("phonemeMatchingScore") ?? 0,
          "time": prefs.getDouble("phonemeMatchingScoreTime") ?? 0.0,
          "errorsCount": prefs.getInt("phonemeMatchingErrors") ?? 0,
        },
        "letterRecognition": {
          "score": prefs.getInt("letterRecognitionScore") ?? 0,
          "time": (prefs.getDouble("letterRecognitionTime") ?? 0.0).round(),
          "errorsCount": prefs.getInt("letterRecognitionErrors") ?? 0,
        },
        "attention": {
          "score": prefs.getInt("attentionScore") ?? 0,
          "time": (prefs.getInt("attentionTime") ?? 0.0).round(),
          "errorsCount": prefs.getInt("attentionErrorCounts") ?? 0,
        },
        "patternMemory": {
          "score": prefs.getInt("memoryPatterScore") ?? 0,
          "time": prefs.getDouble("memoryPatterTime") ?? 0.0,
          "errorsCount": prefs.getInt("memoryPatterErrors") ?? 0,
        },
        "reading": {
          "pronunciationAccuracy":
         ( prefs.getDouble("speakingPronunciationAccuracy") ?? 0.0).round(),
          "readingSpeedWpm":
          (prefs.getDouble("speakingReadingSpeedWpm") ?? 0.0).round(),
          "timeTaken": prefs.getInt("speakingTimeTaken") ?? 0,
          "totalErrors": prefs.getInt("speakingTotalErrors") ?? 0,
          "wrongWords": prefs.getInt("speakingWrongWords") ?? 0,
          "totalScore": (prefs.getDouble("speakingTotalScore") ?? 0).round(),
          "readingFluency":(prefs.getDouble("speakingReadingFluency") ?? 0.0).round(),
        },
      };
debugPrint("student data ${studentData}");
      // Send to backend
      final response = await ApiService.postData(
        data: studentData,
        endpoint: Endpoints.submitEnglishResult,
      );



      if (response != null && response["success"] == true) {
        _showDiagnosisDialog(context, response["result"]);
      } else {
        Get.snackbar("Error", response?["message"] ?? "Failed to submit student report");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  void _showDiagnosisDialog(BuildContext context, Map<String, dynamic> data) {
    bool diagnosed = data["diagnosedDyslexic"] ?? false;
    bool modelDiagnosis = data["diagnosedByModel"] ?? false;

    // safe access helpers
    int _getScore(Map? section) => section?["score"] ?? 0;
    double _getTotalScore(Map? section) => section?["totalScore"]?.toDouble() ?? 0.0;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          diagnosed ? "Possible Dyslexia Detected" : "No Signs of Dyslexia",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: diagnosed ? Colors.red : Colors.green,
          ),
        ),
        content: SizedBox(
          height: 240,
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
              Text("Scores Summary:",
                  style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
              SizedBox(height: 8),
              Text("Phoneme Matching: ${_getScore(data["phonemeMatching"])}",style: TextStyle(color: Colors.black),),
              Text("Letter Recognition: ${_getScore(data["letterRecognition"])}",style: TextStyle(color: Colors.black),),
              Text("Attention: ${_getScore(data["attention"])}",style: TextStyle(color: Colors.black),),
              Text("Pattern Memory: ${_getScore(data["patternMemory"])}",style: TextStyle(color: Colors.black),),
              Text("Reading Score: ${_getTotalScore(data["reading"])}",style: TextStyle(color: Colors.black),),
              SizedBox(height: 8),
              Text("Model Diagnosis: $modelDiagnosis",
                  style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.to(() => GuardianNavBar()),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }
}
