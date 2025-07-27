import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController{
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
      // final age = prefs.setString("age", userAge);
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
        await dataPrefs.setDouble("numberSequenceAccuracy", numberSequenceAccuracy);
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
}
