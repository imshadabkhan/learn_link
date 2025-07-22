import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController {
  String? token;
  Future saveUser(
      {required String userToken,
      required String userId,
      required String userName,
      required String userRole,required String userAge}) async {
    try {
      if (kDebugMode) {
        print('Saving User');
      }
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.setString("token", userToken);
      final id = prefs.setString("id", userId);
      final name = prefs.setString("name", userName);
      final role = prefs.setString("role", userRole);
      final age = prefs.setString("age", userAge);
    }catch(e){
      if (kDebugMode) {
        print('Failed To Save User ${e.toString()}');
      }
    }
  }

  Future deleteUser() async {
    try {
      if (kDebugMode) {
        print('Deleting user');
      }
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('token');
      prefs.remove("id");
      prefs.remove("name");
      prefs.remove("role");
    } catch (e) {
      if (kDebugMode) {
        print('Failed To delete User ${e.toString()}');
      }
    }
  }

  Future saveScore() async {
    try {
      if (kDebugMode) {
        print('Saving score...');
      }
      final SharedPreferences dataPrefs = await SharedPreferences.getInstance();
      final attentionScore =
          dataPrefs.setString("attentionScore", "attentionScore");
      final readingScore = dataPrefs.setString("readingScore", "reading");
      final letterReversalScore =
          dataPrefs.setString("letterReversal", "letterReversal");
      final writingScore = dataPrefs.setString("writingScore", "writingScore");
    } catch (e) {
      if (kDebugMode) {
        print('Failed To save score ${e.toString()}');
      }
    }
  }

  Future deleteScore() async {
    try {
      if (kDebugMode) {
        print('Deleting score...');
      }
      final SharedPreferences deleteDataPrefs =
          await SharedPreferences.getInstance();
      deleteDataPrefs.remove("attentionScore");
      deleteDataPrefs.remove("readingScore");
      deleteDataPrefs.remove("letterReversal");
      deleteDataPrefs.remove("writingScore");
    } catch (e) {
      if (kDebugMode) {
        print('Failed To delete score ${e.toString()}');
      }
    }
  }
}
