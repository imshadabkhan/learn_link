import 'package:shared_preferences/shared_preferences.dart';

class UserController {
  String? token;
  Future saveUser(
      {required String userToken, required String userId, required String userName, required String userRole}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.setString("token",userToken);
    final id = prefs.setString("id", userId);
    final name = prefs.setString("name", userName);
    final role = prefs.setString("role", userRole);
  }


  Future deleteUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove("id");
    prefs.remove("name");
    prefs.remove("role");
  }


  Future saveScore() async {
    final SharedPreferences dataPrefs = await SharedPreferences.getInstance();
    final attentionScore =
        dataPrefs.setString("attentionScore", "attentionScore");
    final readingScore = dataPrefs.setString("readingScore", "reading");
    final letterReversalScore =
        dataPrefs.setString("letterReversal", "letterReversal");
    final writingScore = dataPrefs.setString("writingScore", "writingScore");
  }



  Future deleteScore() async {
    final SharedPreferences deleteDataPrefs = await SharedPreferences.getInstance();
    deleteDataPrefs.remove("attentionScore");
    deleteDataPrefs.remove("readingScore");
    deleteDataPrefs.remove("letterReversal");
    deleteDataPrefs.remove("writingScore");
  }


}
