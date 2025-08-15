import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_link/core/widgets/widgets.dart';
import 'package:learn_link/view/auth/login/login_view.dart';
import 'package:learn_link/view/small_kids/kids_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  final kidsController = Get.put(KidsController());
  RxString token = ''.obs;
  RxString userName = ''.obs;
  RxString userId = ''.obs;
  RxString role = ''.obs;

  Future saveUser({
    required String userToken,
    required String userId,
    required String userName,
    required String userRole,

    // required String userAge
  }) async {
    try {
      if (kDebugMode) {
        print('Saving User');
      }
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", userToken);
      await prefs.setString("id", userId);
      await prefs.setString("name", userName);
      await prefs.setString("role", userRole);

      //update variable instantlyt

      token.value = userToken;
      this.userId.value = userId;
      this.userName.value = userName;
      role.value = userRole;
    } catch (e) {
      if (kDebugMode) {
        print('Failed To Save User ${e.toString()}');
      }
    }
  }

  Future deleteUser() async {
    try {
      if (kDebugMode) print('Deleting user');
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove("id");
      await prefs.remove("name");
      await prefs.remove("role");

      // Clear observables immediately
      token.value = '';
      userId.value = '';
      userName.value = '';
      role.value = '';
    } catch (e) {
      if (kDebugMode) print('Failed To delete User ${e.toString()}');
    }
  }

  Future SaveKidsScore(
      {int? phonemeMatchingScore,
      double? phonemeMatchingScoreTime,
      int? phonemeMatchingErrors,
      int? letterRecognitionScore,
      double? letterRecognitionTime,
      int? letterRecognitionErrors,
      int? numberSequenceScore,
      double? numberSequenceTime,
      int? numberSequenceErrors,
      int? memoryPatterScore,
      double? memoryPatterTime,
      int? memoryPatterErrors}) async {
    try {
      final SharedPreferences dataPrefs = await SharedPreferences.getInstance();

      //PHONEMEMATCHING SECTION   "Voice will be played'
      if (phonemeMatchingScore != null &&
          phonemeMatchingScoreTime != null &&
          phonemeMatchingErrors != null) {
        await dataPrefs.setInt("phonemeMatchingScore", phonemeMatchingScore);
        await dataPrefs.setDouble(
            "phonemeMatchingScoreTime", phonemeMatchingScoreTime);
        await dataPrefs.setInt("phonemeMatchingErrors", phonemeMatchingErrors);
      }
//////////////////LETTER RECOGNITION SECTION///////////////// Recognize letter

      if (letterRecognitionScore != null &&
          letterRecognitionTime != null &&
          letterRecognitionErrors != null) {
        await dataPrefs.setInt(
            "letterRecognitionScore", letterRecognitionScore);
        await dataPrefs.setDouble(
            "letterRecognitionTime", letterRecognitionTime);
        await dataPrefs.setInt(
            "letterRecognitionErrors", letterRecognitionErrors);
      }

//////////////////////////ATTENTION SECTION SCORE/////////////////////  sequence

      if (numberSequenceScore != null &&
          numberSequenceTime != null &&
          numberSequenceErrors != null) {
        await dataPrefs.setInt("numberSequenceScore", numberSequenceScore);
        await dataPrefs.setDouble("numberSequenceTime", numberSequenceTime);
        await dataPrefs.setInt("numberSequenceErrors", numberSequenceErrors);
      }

///////////////////////////////Pattern Memory///////////////////// Colorfull Circles attention module

      if (memoryPatterScore != null &&
          memoryPatterTime != null &&
          memoryPatterErrors != null) {
        await dataPrefs.setInt("memoryPatterScore", memoryPatterScore);
        await dataPrefs.setDouble("memoryPatterTime", memoryPatterTime);
        await dataPrefs.setInt("memoryPatterErrors", memoryPatterErrors);
      }
      print(' Kids Score saved successfully of Memory Pattern $memoryPatterScore $memoryPatterTime $memoryPatterErrors ');
      print(' Kids Score saved successfully of Number Sequence $numberSequenceScore $numberSequenceTime $numberSequenceErrors ');
      print(' Kids Score saved successfully of Phonemec matching Sequence $phonemeMatchingScore $phonemeMatchingScoreTime $phonemeMatchingErrors ');
      print(' Kids Score saved successfully of Letter Recognition $letterRecognitionScore $letterRecognitionTime $letterRecognitionErrors');




    } catch (e) {
      if (kDebugMode) {
        print("Unable to Save Kids Data ${e.toString()}");
      }
    }
  }


  Future<void> showKidsSavedScores({context}) async {
    final prefs = await SharedPreferences.getInstance();

    final phonemeMatchingScore = prefs.getInt("phonemeMatchingScore") ?? 0;
    final phonemeMatchingTime = prefs.getDouble("phonemeMatchingScoreTime") ?? 0.0;
    final phonemeMatchingErrors = prefs.getInt("phonemeMatchingErrors") ?? 0;

    final letterRecognitionScore = prefs.getInt("letterRecognitionScore") ?? 0;
    final letterRecognitionTime = prefs.getDouble("letterRecognitionTime") ?? 0.0;
    final letterRecognitionErrors = prefs.getInt("letterRecognitionErrors") ?? 0;

    final numberSequenceScore = prefs.getInt("numberSequenceScore") ?? 0;
    final numberSequenceTime = prefs.getDouble("numberSequenceTime") ?? 0.0;
    final numberSequenceErrors = prefs.getInt("numberSequenceErrors") ?? 0;

    final memoryPatterScore = prefs.getInt("memoryPatterScore") ?? 0;
    final memoryPatterTime = prefs.getDouble("memoryPatterTime") ?? 0.0;
    final memoryPatterErrors = prefs.getInt("memoryPatterErrors") ?? 0;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Saved Results",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Phoneme Matching:Scores $phonemeMatchingScore , Time: ${phonemeMatchingTime.toStringAsFixed(0)} s, Errors $phonemeMatchingErrors ",style: TextStyle(color: Colors.black),),
              Widgets.heightSpaceH1,
              Text("Letter Recognition:Scores $letterRecognitionScore ,Time: ${letterRecognitionTime.toStringAsFixed(0)} s,Errors $letterRecognitionErrors",style: TextStyle(color: Colors.black),),
              Widgets.heightSpaceH1,
              Text("Number Sequence:Scores $numberSequenceScore ,Time: ${numberSequenceTime.toStringAsFixed(0)} s,Errors $numberSequenceErrors ",style: TextStyle(color: Colors.black),),
              Widgets.heightSpaceH1,
              Text("Memory Pattern:Scores $memoryPatterScore , Time: ${memoryPatterTime.toStringAsFixed(0)}s, Errors $memoryPatterErrors ",style: TextStyle(color: Colors.black),),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: ()async{
              bool? diagnosedValue = await showDialog<bool?>(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text("Guardian Diagnosis",style: TextStyle(color: Colors.black),),
                  content: Text("Is the student dyslexic?",style: TextStyle(color: Colors.black),),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, true), // Dyslexic
                      child: Text("Dyslexic",style: TextStyle(color: Colors.black),),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, false), // Not Dyslexic
                      child: Text("Not Dyslexic",style: TextStyle(color: Colors.black),),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, null), // Don't know
                      child: Text("Don't Know",style: TextStyle(color: Colors.black),),
                    ),
                  ],
                ),
              );
              await kidsController.SubmitKidsReport(context, diagnosedValue);
            },
            child: Text("Diagnose",style: TextStyle(color: Colors.black),),
          ),
        ],
      ),
    );
  }

  Future saveScore({
    double? numberSequenceAccuracy,
    int? attentionScore,
    int? readingScore,
    int? letterReversalScore,
    int? writingScore,
  }) async {
    try {
      final SharedPreferences dataPrefs = await SharedPreferences.getInstance();

      if (attentionScore != null) {
        await dataPrefs.setInt("attentionScore", attentionScore);
      }

      if (numberSequenceAccuracy != null) {
        await dataPrefs.setDouble(
            "numberSequenceAccuracy", numberSequenceAccuracy);
      }

      if (readingScore != null) {
        await dataPrefs.setInt("readingScore", readingScore);
      }

      if (letterReversalScore != null) {
        await dataPrefs.setInt("letterReversalScore", letterReversalScore);
      }

      if (writingScore != null) {
        await dataPrefs.setInt("writingScore", writingScore);
      }

      print(' Score saved successfully');
    } catch (e) {
      print('❌ Failed to save score: ${e.toString()}');
    }
  }

  Future fetchUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token.value = prefs.getString('token') ?? '';
    userName.value = prefs.getString('name') ?? '';
    userId.value = prefs.getString('id') ?? '';
    role.value = prefs.getString('role') ?? '';
  }

  Future deleteScore() async {
    try {
      if (kDebugMode) {
        print('Deleting score...');
      }
      final SharedPreferences deleteDataPrefs =
          await SharedPreferences.getInstance();
      await deleteDataPrefs.remove("attentionScore");
      await deleteDataPrefs.remove("readingScore");
      await deleteDataPrefs.remove("letterReversal");
      await deleteDataPrefs.remove("writingScore");
    } catch (e) {
      if (kDebugMode) {
        print('Failed To delete score ${e.toString()}');
      }
    }
  }

  logOutUser() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
      prefs.remove('token');
      prefs.remove('name');
      prefs.remove('id');
      prefs.remove('role');
      token.value = '';
      userName.value = '';
      userId.value = '';

      Get.offAll(Login());
      Get.snackbar("Success", "User logged out");
    } catch (e) {
      Get.snackbar("Error", "Failed to logout user");
    }
  }

  Future saveCurrentStudentDetail({required String studentId, required String studentAge})async{
    try{
    SharedPreferences pref=await SharedPreferences.getInstance();
    pref.setString("id",studentId);
    pref.setString("age",studentAge.toString());

    print('student id=$studentId');
    print('student age=$studentAge');

    }catch(e){
      print("Failed to  save current student detail");



    }

  }


}
